import 'package:clothes/features/clothes/presentation/blocs/edit_cloth/edit_cloth_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'SetCloth',
    () {
      test('should return correct props', () {
        const clothId = 3;
        const setCloth = SetCloth(clothId: clothId);
        expect(
          setCloth.props,
          [clothId],
        );
      });
    },
  );

  group(
    'ChangeFavourite',
    () {
      test('should return correct props', () {
        const favourite = true;
        const changeFavourite = ChangeFavourite(favourite: favourite);
        expect(
          changeFavourite.props,
          [favourite],
        );
      });
    },
  );

  group(
    'ClearError',
    () {
      test('should return correct props', () {
        expect(
          ClearError().props,
          [],
        );
      });
    },
  );

  group(
    'ClearAction',
    () {
      test('should return correct props', () {
        expect(
          ClearAction().props,
          [],
        );
      });
    },
  );

  group(
    'CloseCloth',
    () {
      test('should return correct props', () {
        expect(
          CloseCloth().props,
          [],
        );
      });
    },
  );
}
