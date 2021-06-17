import 'package:clothes/features/clothes/data/models/cloth_image_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/entities.dart';
import '../../../../helpers/models.dart';

void main() {
  group(
    'ClothImageModel',
    () {
      final json = {
        'id': clothImageModel1.id,
        'path': clothImageModel1.path,
      };

      test('should return correct props', () {
        expect(
          clothImageModel1.props,
          [clothImageModel1.id, clothImageModel1.path],
        );
      });

      group(
        'fromEntity',
        () {
          test(
            'should return a valid model from ClothImage entity',
            () {
              // act
              final result = ClothImageModel.fromEntity(clothImage1);
              // assert
              expect(result, equals(clothImageModel1));
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
              final result = clothImageModel1.toEntity();
              // assert
              expect(result, clothImage1);
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
              expect(result, equals(clothImageModel1));
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
              final result = clothImageModel1.toJson();
              // assert
              expect(result, json);
            },
          );
        },
      );
    },
  );
}
