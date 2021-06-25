import 'package:clothes/core/domain/entities/base_image.dart';

class ClothImage extends BaseImage {
  const ClothImage({
    required int id,
    required String path,
  }) : super(id: id, path: path);
}
