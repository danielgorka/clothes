import 'package:clothes/features/clothes/presentation/blocs/clothes/clothes_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'ClothesUpdated',
    () {
      test('should return correct props', () {
        final loadClothes = LoadClothes();
        expect(
          loadClothes.props,
          [],
        );
      });
    },
  );
}
