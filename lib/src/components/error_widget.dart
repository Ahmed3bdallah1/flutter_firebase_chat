import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  final Object? object;
  final StackTrace? stackTrace;
  final String? message;
  final Future Function()? onRetry;

  const CustomErrorWidget({
    super.key,
    this.object,
    this.stackTrace,
    this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final msg = message ?? object.toString();
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            msg,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) SizedBox(height: 8),
          if (onRetry != null)
            ReloadButton(
              onTap: onRetry,
              size: 25,
              color: Theme.of(context).primaryColor,
            ),
        ],
      ),
    );
  }
}

class ReloadButton extends StatelessWidget {
  const ReloadButton(
      {super.key, this.onTap, this.size = 18, this.color,this.icon = Icons.refresh});

  final Function()? onTap;
  final double size;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      mini: true,
      onPressed: onTap,
      child: Center(
        child: Icon(
          icon,
          size: size,
          color: color?? Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
