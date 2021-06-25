import 'package:clothes/l10n/l10n.dart';
import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final Widget? image;
  final String? message;
  final VoidCallback? onTryAgain;

  const ErrorView({
    Key? key,
    this.image,
    this.message,
    this.onTryAgain,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (image != null) image!,
          Text(
            message ?? context.l10n.somethingWentWrong,
            style: const TextStyle(fontSize: 18.0),
          ),
          if (onTryAgain != null)
            TextButton(
              onPressed: onTryAgain,
              child: Text(context.l10n.tryAgain),
            ),
        ],
      ),
    );
  }
}
