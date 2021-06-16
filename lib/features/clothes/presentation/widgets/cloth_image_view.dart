import 'package:clothes/app/utils/clothes_utils.dart';
import 'package:clothes/features/clothes/domain/entities/cloth_image.dart';
import 'package:clothes/features/clothes/presentation/widgets/image_view.dart';
import 'package:flutter/material.dart';

class ClothImageView extends StatelessWidget {
  final ClothImage? image;
  const ClothImageView({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: ClothesUtils.aspectRatio,
      child: ClipRRect(
        borderRadius: ClothesUtils.borderRadius,
        child:
            image != null ? ImageView(path: image!.path) : const NoImageView(),
      ),
    );
  }
}

@visibleForTesting
class NoImageView extends StatelessWidget {
  const NoImageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 64.0,
          color: Theme.of(context).disabledColor,
        ),
      ),
    );
  }
}
