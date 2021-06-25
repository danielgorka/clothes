import 'package:clothes/l10n/l10n.dart';
import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  final Widget? image;
  final String? message;

  const EmptyView({
    Key? key,
    this.image,
    this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (image != null) image!,
          Text(
            message ?? context.l10n.nothingToShow,
            style: const TextStyle(fontSize: 18.0),
          ),
        ],
      ),
    );
  }
}
