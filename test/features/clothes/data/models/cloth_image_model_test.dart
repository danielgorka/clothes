import 'package:clothes/features/clothes/data/models/cloth_image_model.dart';
import 'package:clothes/features/clothes/domain/entities/cloth_image.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'ClothImageModel',
    () {
      const id = 1;
      const path = 'path/image.png';

      const clothImage = ClothImage(
        id: id,
        path: path,
      );

      const clothImageModel = ClothImageModel(
        id: id,
        path: path,
      );
      const json = {
        'id': id,
        'path': path,
      };

      test('should return correct props', () {
        expect(
          clothImageModel.props,
          [id, path],
        );
      });

      group(
        'fromEntity',
        () {
          test(
            'should return a valid model from ClothImage entity',
            () {
              // act
              final result = ClothImageModel.fromEntity(clothImage);
              // assert
              expect(result, equals(clothImageModel));
            },
          );
        },
      );

      group(
        'toEntity',
        () {
          test(
            'should return a valid ClothImage entity from model',
            () {
              // act
              final result = clothImageModel.toEntity();
              // assert
              expect(result, clothImage);
            },
          );
        },
      );

      group(
        'fromJson',
        () {
          test(
            'should return a valid model from JSON',
            () {
              // act
              final result = ClothImageModel.fromJson(json);
              // assert
              expect(result, equals(clothImageModel));
            },
          );
        },
      );

      group(
        'toJson',
        () {
          test(
            'should return a valid JSON from model',
            () {
              // act
              final result = clothImageModel.toJson();
              // assert
              expect(result, json);
            },
          );
        },
      );
    },
  );
}
