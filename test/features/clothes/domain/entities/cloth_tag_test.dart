import 'package:clothes/features/clothes/domain/entities/cloth_tag.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'ClothTag',
    () {
      test('should return correct props', () {
        const id = 1;
        const type = ClothTagType.clothKind;
        const name = 'T-shirt';
        expect(
          const ClothTag(id: id, type: type, name: name).props,
          [id, type, name],
        );
      });
    },
  );
}
