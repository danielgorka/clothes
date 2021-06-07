import 'package:clothes/features/clothes/data/models/cloth_tag_model.dart';
import 'package:clothes/features/clothes/domain/entities/cloth_tag.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'ClothTagModel',
    () {
      const id = 1;
      const type = 'color';
      const name = 'path';

      const clothTag = ClothTag(
        id: id,
        type: ClothTagType.color,
        name: name,
      );

      const clothTagModel = ClothTagModel(
        id: id,
        type: type,
        name: name,
      );
      const json = {
        'id': id,
        'type': type,
        'name': name,
      };

      test('should return correct props', () {
        expect(
          clothTagModel.props,
          [id, type, name],
        );
      });

      group(
        'fromEntity',
        () {
          test(
            'should return a valid model from ClothTag entity',
            () {
              // act
              final result = ClothTagModel.fromEntity(clothTag);
              // assert
              expect(result, equals(clothTagModel));
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
              final result = clothTagModel.toEntity();
              // assert
              expect(result, clothTag);
            },
          );
          test(
            'should return ClothTagType.other when model contains unknown type',
            () {
              // arrange
              const clothTagModelWithUnknownType = ClothTagModel(
                id: id,
                type: 'unknown type',
                name: name,
              );
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
              expect(result, equals(clothTagModel));
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
              final result = clothTagModel.toJson();
              // assert
              expect(result, json);
            },
          );
        },
      );
    },
  );
}
