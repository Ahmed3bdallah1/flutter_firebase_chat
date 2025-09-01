import 'package:flutter/material.dart';
import 'error_widget.dart';

class NotFoundWidget extends StatelessWidget {
  const NotFoundWidget({
    required this.title,
    this.message,
    this.onTryAgain,
    this.center = true,
    super.key,
    this.style,
  });

  final String title;
  final String? message;
  final TextStyle? style;
  final bool center;
  final VoidCallback? onTryAgain;

  @override
  Widget build(BuildContext context) {
    final message = this.message;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 32,
          horizontal: 16,
        ),
        child: Column(
          mainAxisAlignment:
              center ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: style??Theme.of(context).textTheme.titleLarge,
            ),
            if (message != null)
              const SizedBox(
                height: 16,
              ),
            if (message != null)
              Text(
                message,
                textAlign: TextAlign.center,
              ),
            if (onTryAgain != null)
              SizedBox(
                height: 8,
              ),
            if (onTryAgain != null)
              ReloadButton(
                onTap: onTryAgain,
                size: 25,
                color: Theme.of(context).primaryColor,
              ),
          ],
        ),
      ),
    );
  }
}
