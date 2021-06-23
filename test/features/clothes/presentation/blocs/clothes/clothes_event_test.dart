import 'dart:typed_data';

import 'package:clothes/features/clothes/presentation/blocs/clothes/clothes_bloc.dart';
import 'package:clothes/features/clothes/presentation/blocs/edit_image/edit_image_bloc.dart'
    hide PickImage;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'LoadClothes',
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

  group(
    'PickImage',
    () {
      test('should return correct props', () {
        const source = ImagePickerSource.gallery;
        const pickImage = PickImage(source: source);
        expect(
          pickImage.props,
          [source],
        );
      });
    },
  );

  group(
    'ImagePicked',
    () {
      test('should return correct props', () {
        final image = Uint8List.fromList([1, 2, 3, 4]);
        final imagePicked = ImagePicked(image: image);
        expect(
          imagePicked.props,
          [image],
        );
      });
    },
  );

  group(
    'CreateEmptyCloth',
    () {
      test('should return correct props', () {
        final createEmptyCloth = CreateEmptyCloth();
        expect(
          createEmptyCloth.props,
          [],
        );
      });
    },
  );

  group(
    'CancelAction',
    () {
      test('should return correct props', () {
        final cancelAction = CancelAction();
        expect(
          cancelAction.props,
          [],
        );
      });
    },
  );
}
