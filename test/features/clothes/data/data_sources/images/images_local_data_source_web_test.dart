import 'dart:typed_data';

import 'package:clothes/features/clothes/data/data_sources/images/images_local_data_source_web.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'ImagesLocalDataSourceWeb',
    () {
      late ImagesLocalDataSourceWeb imagesLocalDataSourceWeb;

      setUp(() {
        imagesLocalDataSourceWeb = ImagesLocalDataSourceWeb();
      });

      group(
        'saveImage',
        () {
          test(
            'should compose data url and return it',
            () async {
              // arrange
              final image = Uint8List.fromList([1, 2, 3, 4]);
              const imageUrl = 'data:image/png;base64,AQIDBA==';
              // act
              final result = await imagesLocalDataSourceWeb.saveImage(image);
              // assert
              expect(result, equals(imageUrl));
            },
          );
        },
      );

      group(
        'deleteImage',
        () {
          test(
            'should do nothing',
            () async {
              // act
              await imagesLocalDataSourceWeb.deleteImage('path');
            },
          );
        },
      );
    },
  );
}
