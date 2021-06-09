import 'dart:typed_data';

import 'package:clock/clock.dart';
import 'package:clothes/core/error/exceptions.dart';
import 'package:clothes/core/platform/path_provider.dart';
import 'package:clothes/features/clothes/data/data_sources/images/images_local_data_source.dart';
import 'package:file/memory.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path/path.dart' as p;

class MockPathProvider extends Mock implements BasePathProvider {}

void main() {
  group(
    'ImagesLocalDataSource',
    () {
      const folderPath = 'path/images';
      const notFolderPath = 'path/images2';
      late Clock mockClock;
      late MemoryFileSystem mockFileSystem;
      late ImagesLocalDataSource imagesLocalDataSource;

      setUp(() async {
        mockClock = Clock.fixed(DateTime(2021, 6, 9, 17, 5, 12, 132));
        mockFileSystem = MemoryFileSystem();
        await mockFileSystem.directory(folderPath).create(recursive: true);
        imagesLocalDataSource = ImagesLocalDataSource(
          clock: mockClock,
          fileSystem: mockFileSystem,
          folderPath: folderPath,
        );
      });

      group(
        'init',
        () {
          test(
            'should get local app path and create there image folder '
            'when initiating data source in the native environment '
            'and return data source instance',
            () async {
              // arrange
              final mockPathProvider = MockPathProvider();
              const path = 'app/path';
              when(() => mockPathProvider.getAppPath())
                  .thenAnswer((_) => Future.value(path));
              // act
              final result = await ImagesLocalDataSource.init(
                fileSystem: mockFileSystem,
                pathProvider: mockPathProvider,
              );
              // assert
              expect(result, isA<ImagesLocalDataSource>());
              verify(() => mockPathProvider.getAppPath()).called(1);
              verifyNoMoreInteractions(mockPathProvider);
              final dirExists = await mockFileSystem
                  .directory(p.join(path, ImagesLocalDataSource.folderName))
                  .exists();
              expect(dirExists, isTrue);
            },
          );
        },
      );

      group(
        'saveImage',
        () {
          test(
            'should write image to new file which '
            'name is milliseconds since epoch',
            () async {
              // arrange
              final image = Uint8List.fromList([1, 2, 3, 4]);
              final expectedPath = p.join(
                folderPath,
                '${mockClock.now().millisecondsSinceEpoch}.png',
              );
              // act
              final result = await imagesLocalDataSource.saveImage(image);
              // assert
              expect(result, equals(expectedPath));
              final fileContent =
                  await mockFileSystem.file(expectedPath).readAsBytes();
              expect(fileContent, equals(image));
            },
          );
          test(
            'should write image to new file which name contains '
            'additional number if base file already exists',
            () async {
              // arrange
              final baseName =
                  mockClock.now().millisecondsSinceEpoch.toString();
              await mockFileSystem
                  .file(p.join(folderPath, '$baseName.png'))
                  .create();
              await mockFileSystem
                  .file(p.join(folderPath, '$baseName-1.png'))
                  .create();
              await mockFileSystem
                  .file(p.join(folderPath, '$baseName-2.png'))
                  .create();

              final image = Uint8List.fromList([1, 2, 3, 4]);
              final expectedPath = p.join(
                folderPath,
                '$baseName-3.png',
              );
              // act
              final result = await imagesLocalDataSource.saveImage(image);
              // assert
              expect(result, equals(expectedPath));
              final fileContent =
                  await mockFileSystem.file(expectedPath).readAsBytes();
              expect(fileContent, equals(image));
            },
          );
        },
      );
      group(
        'deleteImage',
        () {
          test(
            'should delete file at specified path if exists',
            () async {
              // arrange
              final filePath = p.join(folderPath, '1234567890.png');
              await mockFileSystem.file(filePath).create();
              // act
              await imagesLocalDataSource.deleteImage(filePath);
              // assert
              final fileExists = await mockFileSystem.file(filePath).exists();
              expect(fileExists, isFalse);
            },
          );
          test(
            'should do nothing if specified path does not exist',
            () async {
              // arrange
              final filePath = p.join(folderPath, '1234567890.png');
              // act
              await imagesLocalDataSource.deleteImage(filePath);
              // assert
              final fileExists = await mockFileSystem.file(filePath).exists();
              expect(fileExists, isFalse);
            },
          );
          test(
            'should throws LocalStorageException '
            'if specified path is not in base folder',
            () async {
              // arrange
              final filePath = p.join(notFolderPath, '1234567890.png');
              await mockFileSystem.file(filePath).create();
              // act
              final func = imagesLocalDataSource.deleteImage;
              // assert
              await expectLater(
                func(filePath),
                throwsA(const TypeMatcher<LocalStorageException>()),
              );
              final fileExists = await mockFileSystem.file(filePath).exists();
              expect(fileExists, isTrue);
            },
          );
        },
      );
    },
  );
}
