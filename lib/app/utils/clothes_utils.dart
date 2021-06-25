import 'package:flutter/material.dart';

// ignore: avoid_classes_with_only_static_members
abstract class ClothesUtils {
  static const aspectRatio = 3 / 4;

  static final borderRadius = BorderRadius.circular(32.0);

  static const gridDelegate = SliverGridDelegateWithMaxCrossAxisExtent(
    maxCrossAxisExtent: 250.0,
    childAspectRatio: aspectRatio,
    mainAxisSpacing: 16.0,
    crossAxisSpacing: 16.0,
  );

  static EdgeInsets gridViewPadding(BuildContext context) => EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16.0,
        left: 16.0,
        right: 16.0,
        bottom: 16.0,
      );
}
