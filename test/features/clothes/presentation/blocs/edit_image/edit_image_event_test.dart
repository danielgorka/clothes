import 'package:clothes/features/clothes/presentation/blocs/edit_image/edit_image_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'PickImage',
    () {
      test('should return correct props', () {
        const source = ImagePickerSource.gallery;
        const pickImage = PickImage(imagePickerSource: source);
        expect(
          pickImage.props,
          [source],
        );
      });
    },
  );

  group(
    'CancelEditingImage',
    () {
      test('should return correct props', () {
        expect(
          CancelEditingImage().props,
          [],
        );
      });
    },
  );

  group(
    'CompleteEditingImage',
    () {
      test('should return correct props', () {
        expect(
          CompleteEditingImage().props,
          [],
        );
      });
    },
  );
}
