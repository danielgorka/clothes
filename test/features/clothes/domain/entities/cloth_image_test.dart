import 'package:clothes/features/clothes/domain/entities/cloth_image.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'ClothImage',
    () {
      test('should return correct props', () {
        const id = 1;
        const path = 'path';
        // ignore: prefer_const_constructors
        expect(ClothImage(id: id, path: path).props, [id, path]);
      });
    },
  );
}
