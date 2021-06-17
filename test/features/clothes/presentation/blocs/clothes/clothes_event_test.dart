import 'package:clothes/features/clothes/presentation/blocs/clothes/clothes_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/entities.dart';

void main() {
  group(
    'ClothesUpdated',
    () {
      test('should return correct props', () {
        final clothesUpdated = ClothesUpdated(clothes: clothes1);
        expect(
          clothesUpdated.props,
          [clothes1],
        );
      });
    },
  );
}
