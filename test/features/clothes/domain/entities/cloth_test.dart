import 'package:clothes/features/clothes/domain/entities/cloth.dart';
import 'package:clothes/features/clothes/domain/entities/cloth_image.dart';
import 'package:clothes/features/clothes/domain/entities/cloth_tag.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/entities.dart';

void main() {
  group(
    'Cloth',
    () {
      group(
        'empty',
        () {
          test(
            'should create empty cloth',
            () {
              // act
              final result = Cloth.empty();
              // assert
              expect(result.id, equals(0));
            },
          );
        },
      );

      group(
        'copyWith',
        () {
          test(
            'should return unchanged model when '
            'running copyWith without arguments',
            () {
              // act
              final newCloth = cloth1.copyWith();
              // assert
              expect(newCloth, equals(cloth1));
            },
          );
          test(
            'should return a valid updated model',
            () {
              // arrange
              const newId = 92;
              const newName = 'Top';
              const newDescription = 'Pretty';
              const newImages = [
                ClothImage(id: 2, path: 'new/path'),
              ];
              const newTags = [
                ClothTag(
                  id: 3,
                  type: ClothTagType.color,
                  name: 'Red',
                )
              ];
              const newFavourite = false;
              const newOrder = 4;
              final newCreationDate = DateTime(2021, 6, 7, 22, 30, 43, 10);
              // act
              final newCloth = cloth1.copyWith(
                id: newId,
                name: newName,
                description: newDescription,
                images: newImages,
                tags: newTags,
                favourite: newFavourite,
                order: newOrder,
                creationDate: newCreationDate,
              );
              // assert
              expect(
                newCloth,
                equals(
                  Cloth(
                    id: newId,
                    name: newName,
                    description: newDescription,
                    images: newImages,
                    tags: newTags,
                    // ignore: avoid_redundant_argument_values
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

      test('should return correct props', () {
        expect(cloth1.props, [
          cloth1.id,
          cloth1.name,
          cloth1.description,
          cloth1.images,
          cloth1.tags,
          cloth1.favourite,
          cloth1.order,
          cloth1.creationDate,
        ]);
      });
    },
  );
}
