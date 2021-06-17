import 'package:clothes/features/clothes/presentation/blocs/clothes/clothes_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/entities.dart';

void main() {
  group(
    'Loaded',
    () {
      test('should return correct props', () {
        final loaded = Loaded(clothes: clothes1);
        expect(
          loaded.props,
          [clothes1],
        );
      });
    },
  );
}
