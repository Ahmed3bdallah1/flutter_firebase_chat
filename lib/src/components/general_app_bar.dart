import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GeneralAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const GeneralAppBar({
    super.key,
    this.title,
    this.actions,
  });
  final Widget? title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: title,
      actions: [
        ...actions ?? [],
      ],
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 56);
}