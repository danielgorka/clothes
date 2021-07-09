import 'package:clothes/app/utils/clothes_utils.dart';
import 'package:clothes/features/clothes/domain/entities/cloth.dart';
import 'package:clothes/features/clothes/presentation/widgets/cloth_image_view.dart';
import 'package:clothes/features/clothes/presentation/widgets/image_shadow.dart';
import 'package:flutter/material.dart';

class ClothItem extends StatelessWidget {
  final Cloth cloth;
  final VoidCallback? onTap;

  const ClothItem({
    Key? key,
    required this.cloth,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: ClothesUtils.borderRadius,
      child: Stack(
        children: [
          ClothImageView(
            image: cloth.images.isNotEmpty ? cloth.images.first : null,
          ),
          if (cloth.name.isNotEmpty)
            const ImageShadow(
              side: ShadowSide.bottom,
            ),
          if (cloth.name.isNotEmpty)
            Positioned(
              bottom: 8.0,
              left: 0.0,
              right: 0.0,
              child: Text(
                cloth.name,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: ClothesUtils.borderRadius,
                onTap: onTap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
