import 'package:clothes/features/clothes/data/models/cloth_tag_model.dart';
import 'package:clothes/features/clothes/domain/entities/cloth_tag.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/entities.dart';
import '../../../../helpers/models.dart';

void main() {
  group(
    'ClothTagModel',
    () {
      final json = {
        'id': clothTagModel1.id,
        'type': clothTagModel1.type,
        'name': clothTagModel1.name,
      };

      test('should return correct props', () {
        expect(
          clothTagModel1.props,
          [clothTagModel1.id, clothTagModel1.type, clothTagModel1.name],
        );
      });

      group(
        'fromEntity',
        () {
          test(
            'should return a valid model from ClothTag entity',
            () {
              // act
              final result = ClothTagModel.fromEntity(clothTag1);
              // assert
              expect(result, equals(clothTagModel1));
            },
          );
        },
      );

      group(
        'toEntity',
        () {
          test(
            'should return a valid ClothTag entity from model',
            () {
              // act
              final result = clothTagModel1.toEntity();
              // assert
              expect(result, clothTag1);
            },
          );
          test(
            'should return ClothTagType.other when model contains unknown type',
            () {
              // act
              final result = clothTagModelWithUnknownType.toEntity();
              // assert
              expect(result.type, ClothTagType.other);
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
              final result = ClothTagModel.fromJson(json);
              // assert
              expect(result, equals(clothTagModel1));
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
              final result = clothTagModel1.toJson();
              // assert
              expect(result, json);
            },
          );
        },
      );
    },
  );
}
