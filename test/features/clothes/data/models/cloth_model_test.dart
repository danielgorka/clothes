import 'package:clothes/features/clothes/data/models/cloth_model.dart';
import 'package:clothes/features/clothes/domain/entities/cloth.dart';
import 'package:clothes/features/clothes/domain/entities/cloth_image.dart';
import 'package:clothes/features/clothes/domain/entities/cloth_tag.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'ClothModel',
    () {
      const id = 1;
      const name = 'Name';
      const description = 'Description';
      const images = [
        ClothImage(id: 0, path: 'path1'),
        ClothImage(id: 1, path: 'path2'),
      ];
      const imagesIds = [0, 1];
      const tags = [
        ClothTag(id: 2, type: ClothTagType.color, name: 'Red'),
        ClothTag(id: 3, type: ClothTagType.clothKind, name: 'T-shirt'),
        ClothTag(id: 4, type: ClothTagType.other, name: 'Summer'),
      ];
      const tagsIds = [2, 3, 4];
      const favourite = true;
      const order = 1;
      final creationDate = DateTime(2017, 9, 7, 17, 30, 59, 1);

      final allImages = images +
          [
            const ClothImage(id: 132, path: 'path/423'),
          ];
      final allTags = tags +
          [
            const ClothTag(
                id: 431, type: ClothTagType.other, name: 'Other tag'),
          ];

      final cloth = Cloth(
        id: id,
        name: name,
        description: description,
        images: images,
        tags: tags,
        favourite: favourite,
        order: order,
        creationDate: creationDate,
      );

      final clothModel = ClothModel(
        id: id,
        name: name,
        description: description,
        imagesIds: imagesIds,
        tagsIds: tagsIds,
        favourite: favourite,
        order: order,
        creationDate: creationDate,
      );

      final json = {
        'id': id,
        'name': name,
        'description': description,
        'imagesIds': imagesIds,
        'tagsIds': tagsIds,
        'favourite': favourite,
        'order': order,
        'creationDate': '2017-09-07T17:30:59.001',
      };

      test('should return correct props', () {
        expect(clothModel.props, [
          id,
          name,
          description,
          imagesIds,
          tagsIds,
          favourite,
          order,
          creationDate,
        ]);
      });

      group(
        'fromEntity',
        () {
          test(
            'should return a valid model from Cloth entity',
            () {
              // act
              final result = ClothModel.fromEntity(cloth);
              // assert
              expect(result, equals(clothModel));
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
              final result = clothModel.toEntity(
                images: allImages,
                tags: allTags,
              );
              // assert
              expect(result, cloth);
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
              expect(result, equals(clothModel));
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
              final result = clothModel.toJson();
              // assert
              expect(result, json);
            },
          );
        },
      );
    },
  );
}
