import 'package:clothes/features/clothes/domain/entities/cloth.dart';
import 'package:clothes/features/clothes/domain/entities/cloth_image.dart';
import 'package:clothes/features/clothes/domain/entities/cloth_tag.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'Cloth',
    () {
      test('should return correct props', () {
        const id = 1;
        const name = 'Name';
        const description = 'Description';
        const images = [ClothImage(id: 0, path: 'path')];
        const tags = [
          ClothTag(
            id: 0,
            type: ClothTagType.color,
            name: 'Green',
          ),
        ];
        const favourite = true;
        const order = 1;
        final creationDate = DateTime.now();
        expect(
            Cloth(
              id: id,
              name: name,
              description: description,
              images: images,
              tags: tags,
              favourite: favourite,
              order: order,
              creationDate: creationDate,
            ).props,
            [
              id,
              name,
              description,
              images,
              tags,
              favourite,
              order,
              creationDate,
            ]);
      });
    },
  );
}
