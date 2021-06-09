import 'dart:typed_data';

import 'package:clock/clock.dart';
import 'package:clothes/core/error/exceptions.dart';
import 'package:clothes/core/platform/path_provider.dart';
import 'package:clothes/features/clothes/data/data_sources/images/base_images_local_data_source.dart';
import 'package:file/file.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';

class ImagesLocalDataSource extends BaseImagesLocalDataSource {
  static const folderName = 'images';

  final Clock clock;
  final FileSystem fileSystem;
  final String folderPath;

  @visibleForTesting
  ImagesLocalDataSource({
    this.clock = const Clock(),
    required this.fileSystem,
    required this.folderPath,
  });

  static Future<ImagesLocalDataSource> init({
    required FileSystem fileSystem,
    required BasePathProvider pathProvider,
  }) async {
    final appPath = await pathProvider.getAppPath();
    final dir = fileSystem.directory(join(appPath, folderName));
    await dir.create(recursive: true);
    return ImagesLocalDataSource(
      fileSystem: fileSystem,
      folderPath: dir.path,
    );
  }

  @override
  Future<String> saveImage(Uint8List image) async {
    final baseName = clock.now().millisecondsSinceEpoch.toString();
    var number = 0;
    var file = fileSystem.file(join(folderPath, '$baseName.png'));
    while (await file.exists()) {
      number++;
      file = fileSystem.file(join(folderPath, '$baseName-$number.png'));
    }
    await file.writeAsBytes(image);
    return file.path;
  }

  @override
  Future<void> deleteImage(String path) async {
    final file = fileSystem.file(path);
    if (!isWithin(folderPath, path)) {
      throw LocalStorageException();
    }
    if (await file.exists()) {
      await file.delete();
    }
  }
}
