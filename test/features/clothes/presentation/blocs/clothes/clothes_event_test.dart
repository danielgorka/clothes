import 'package:clothes/features/clothes/domain/entities/cloth.dart';
import 'package:clothes/features/clothes/presentation/blocs/clothes/clothes_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'ClothesUpdated',
    () {
      test('should return correct props', () {
        final cloth = Cloth(id: 1, creationDate: DateTime.now());
        final clothes = List.filled(2, cloth);
        final clothesUpdated = ClothesUpdated(clothes: clothes);
        expect(
          clothesUpdated.props,
          [clothes],
        );
      });
    },
  );
}
