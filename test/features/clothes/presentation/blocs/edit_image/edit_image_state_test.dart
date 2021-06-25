import 'dart:typed_data';

import 'package:clothes/features/clothes/presentation/blocs/edit_image/edit_image_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'EditImageState',
    () {
      const status = EditImageStatus.editing;
      final image = Uint8List.fromList([1, 2, 3, 4]);
      final editImageState = EditImageState(
        status: status,
        image: image,
      );

      group(
        'copyWith',
        () {
          test(
            'should return unchanged state when '
            'running copyWith without arguments',
            () {
              // act
              final newEditImageState = editImageState.copyWith();
              // assert
              expect(newEditImageState, equals(editImageState));
            },
          );
          test(
            'should return a valid updated model',
            () {
              // arrange
              const newStatus = EditImageStatus.canceled;
              final newImage = Uint8List.fromList([5, 6, 7]);
              // act
              final newEditImageState = editImageState.copyWith(
                status: newStatus,
                image: newImage,
              );
              // assert
              expect(
                newEditImageState,
                equals(
                  EditImageState(
                    status: newStatus,
                    image: newImage,
                  ),
                ),
              );
            },
          );
        },
      );

      test(
        'should return correct props',
        () {
          expect(
            editImageState.props,
            [
              status,
              image,
            ],
          );
        },
      );
    },
  );
}
