import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class EditClothPage extends StatelessWidget {
  final int clothId;
  const EditClothPage({
    Key? key,
    @PathParam('clothId')
    required this.clothId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Text(clothId.toString()),
      ),
    );
  }
}
