import 'dart:convert';
import 'dart:typed_data';

import 'package:clothes/features/clothes/data/data_sources/images/base_images_local_data_source.dart';

class ImagesLocalDataSourceWeb extends BaseImagesLocalDataSource {
  @override
  Future<String> saveImage(Uint8List image) async {
    final base64 = base64Encode(image);
    return 'data:image/png;base64,$base64';
  }

  @override
  Future<void> deleteImage(String path) async {
    // Empty method
  }
}
