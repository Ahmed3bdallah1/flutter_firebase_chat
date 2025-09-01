import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/error_widget.dart';
import '../components/loading_widget.dart';

extension AsyncValueX<T> on AsyncValue<T> {
  Widget customWhen({
    required WidgetRef ref,
    required Refreshable<Future<T>> refreshable,
    bool skipLoadingOnReload = false,
    bool skipLoadingOnRefresh = false,
    bool skipError = false,
    String? messageOnError,
    required Widget Function(T data) data,
    Widget Function(Object error, StackTrace stackTrace)? error,
    Widget Function()? loading,
  }) {
    return when<Widget>(
      loading: () => loading?.call() ?? const LoadingWidget(),
      skipLoadingOnReload: skipLoadingOnReload,
      skipLoadingOnRefresh: skipLoadingOnRefresh,
      skipError: skipError,
      data: data,
      error: (err, trace) =>
          error?.call(err, trace) ??
          CustomErrorWidget(
            stackTrace: trace,
            message: messageOnError,
            object: err,
            onRetry: () {
              return ref.refresh(refreshable);
            },
          ),
    );
  }
}
