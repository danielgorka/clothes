import 'package:clothes/features/clothes/data/models/cloth_model.dart';
import 'package:clothes/features/clothes/domain/entities/cloth_image.dart';
import 'package:clothes/features/clothes/domain/entities/cloth_tag.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/entities.dart';
import '../../../../helpers/models.dart';

void main() {
  group(
    'ClothModel',
    () {
      final allImages = clothImages1 +
          [
            const ClothImage(
              id: 132,
              path: 'path/423',
            ),
          ];
      final allTags = clothTags1 +
          [
            const ClothTag(
              id: 431,
              type: ClothTagType.other,
              name: 'Other tag',
            ),
          ];

      final json = {
        'id': clothModel1.id,
        'name': clothModel1.name,
        'description': clothModel1.description,
        'imagesIds': clothModel1.imagesIds,
        'tagsIds': clothModel1.tagsIds,
        'favourite': clothModel1.favourite,
        'order': clothModel1.order,
        'creationDate': '2017-09-07T17:30:59.001',
      };

      test('should return correct props', () {
        expect(clothModel1.props, [
          clothModel1.id,
          clothModel1.name,
          clothModel1.description,
          clothModel1.imagesIds,
          clothModel1.tagsIds,
          clothModel1.favourite,
          clothModel1.order,
          clothModel1.creationDate,
        ]);
      });

      group(
        'fromEntity',
        () {
          test(
            'should return a valid model from Cloth entity',
            () {
              // act
              final result = ClothModel.fromEntity(cloth1);
              // assert
              expect(result, equals(clothModel1));
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
              final result = clothModel1.toEntity(
                images: allImages,
                tags: allTags,
              );
              // assert
              expect(result, equals(cloth1));
            },
          );
        },
      );

      group(
        'copyWith',
        () {
          test(
            'should return unchanged model when running copyWith wihtout arguments',
            () {
              // act
              final newClothModel = clothModel1.copyWith();
              // assert
              expect(newClothModel, equals(clothModel1));
            },
          );
          test(
            'should return a valid updated model',
            () {
              // arrange
              const newId = 92;
              const newName = 'Top';
              const newDescription = 'Pretty';
              const newImagesIds = [3];
              const newTagsIds = [5];
              const newFavourite = false;
              const newOrder = 4;
              final newCreationDate = DateTime(2021, 6, 7, 22, 30, 43, 10);

              // act
              final newClothModel = clothModel1.copyWith(
                id: newId,
                name: newName,
                description: newDescription,
                imagesIds: newImagesIds,
                tagsIds: newTagsIds,
                favourite: newFavourite,
                order: newOrder,
                creationDate: newCreationDate,
              );
              // assert
              expect(
                newClothModel,
                equals(
                  ClothModel(
                    id: newId,
                    name: newName,
                    description: newDescription,
                    imagesIds: newImagesIds,
                    tagsIds: newTagsIds,
                    favourite: newFavourite,
                    order: newOrder,
                    creationDate: newCreationDate,
                  ),
                ),
              );
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
              final result = ClothModel.fromJson(json);
              // assert
              expect(result, equals(clothModel1));
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
              final result = clothModel1.toJson();
              // assert
              expect(result, json);
            },
          );
        },
      );
    },
  );
}
