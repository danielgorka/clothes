import 'package:clothes/features/clothes/domain/entities/cloth_tag.dart';
import 'package:flutter/material.dart';

class TagView extends StatelessWidget {
  final ClothTag tag;
  const TagView({
    Key? key,
    required this.tag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(tag.name),
    );
  }
}
