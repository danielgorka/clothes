import 'dart:typed_data';

abstract class BaseImagesLocalDataSource {
  Future<String> saveImage(Uint8List image);

  Future<void> deleteImage(String path);
}
