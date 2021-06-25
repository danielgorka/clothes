import 'package:clothes/features/clothes/presentation/blocs/clothes/clothes_bloc.dart';
import 'package:clothes/features/clothes/presentation/blocs/edit_image/edit_image_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/entities.dart';

void main() {
  group(
    'PickImageAction',
    () {
      test('should return correct props', () {
        const source = ImagePickerSource.gallery;
        const action = PickImageAction(source: source);

        expect(
          action.props,
          [source],
        );
      });
    },
  );

  group(
    'EditClothAction',
    () {
      test('should return correct props', () {
        const clothId = 4;
        const action = EditClothAction(clothId: clothId);

        expect(
          action.props,
          [clothId],
        );
      });
    },
  );

  group(
    'ClothesState',
    () {
      test('should return correct props', () {
        const status = ClothesStatus.loaded;
        const action = PickImageAction(source: ImagePickerSource.gallery);
        final state = ClothesState(
          status: status,
          action: action,
          clothes: clothes1,
        );
        expect(
          state.props,
          [status, action, clothes1],
        );
      });
    },
  );
}
