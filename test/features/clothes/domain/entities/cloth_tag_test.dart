import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/entities.dart';

void main() {
  group(
    'ClothTag',
    () {
      test('should return correct props', () {
        expect(
          clothTag1.props,
          [clothTag1.id, clothTag1.type, clothTag1.name],
        );
      });
    },
  );
}
