import 'package:clothes/features/clothes/domain/entities/cloth.dart';
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
