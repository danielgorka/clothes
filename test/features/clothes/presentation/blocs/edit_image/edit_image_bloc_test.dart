import 'dart:async';
import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:clothes/core/error/exceptions.dart';
import 'package:clothes/core/platform/app_image_picker.dart';
import 'package:clothes/features/clothes/presentation/blocs/edit_image/edit_image_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';

class MockAppImagePicker extends Mock implements BaseAppImagePicker {}

void main() {
  group(
    'EditImageBloc',
    () {
      late MockAppImagePicker mockAppImagePicker;
      late EditImageBloc editImageBloc;

      setUp(() {
        mockAppImagePicker = MockAppImagePicker();
        editImageBloc = EditImageBloc(appImagePicker: mockAppImagePicker);
      });

      tearDown(() {
        editImageBloc.close();
      });

      final image = Uint8List.fromList([1, 2, 3, 4]);
      const imagePickerSource = ImagePickerSource.gallery;
      const imageSource = ImageSource.gallery;

      test(
        'initial state status should be picking',
        () {
          // assert
          expect(
            editImageBloc.state.status,
            equals(EditImageStatus.picking),
          );
        },
      );

      group(
        'PickImage',
        () {
          blocTest(
            'should emit state with status editing and image data '
            'when AppImagePicker returns nonnull data',
            build: () {
              when(() => mockAppImagePicker.pickImage(imageSource))
                  .thenAnswer((_) => Future.value(image));
              return editImageBloc;
            },
            act: (EditImageBloc bloc) => bloc
              ..add(
                const PickImage(
                  imagePickerSource: imagePickerSource,
                ),
              ),
            expect: () => [
              const EditImageState(),
              EditImageState(
                status: EditImageStatus.editing,
                image: image,
              ),
            ],
            verify: (_) {
              verify(() => mockAppImagePicker.pickImage(imageSource)).called(1);
              verifyNoMoreInteractions(mockAppImagePicker);
            },
          );
          blocTest(
            'should emit state with status canceled '
            'when AppImagePicker returns null',
            build: () {
              when(() => mockAppImagePicker.pickImage(imageSource))
                  .thenAnswer((_) => Future.value(null));
              return editImageBloc;
            },
            act: (EditImageBloc bloc) => bloc
              ..add(
                const PickImage(
                  imagePickerSource: imagePickerSource,
                ),
              ),
            expect: () => const [
              EditImageState(),
              EditImageState(status: EditImageStatus.canceled),
            ],
            verify: (_) {
              verify(() => mockAppImagePicker.pickImage(imageSource)).called(1);
              verifyNoMoreInteractions(mockAppImagePicker);
            },
          );
          blocTest(
            'should emit state with status canceled '
            'when AppImagePicker throws ImagePickerException',
            build: () {
              when(() => mockAppImagePicker.pickImage(imageSource))
                  .thenAnswer((_) => Future.error(ImagePickerException()));
              return editImageBloc;
            },
            act: (EditImageBloc bloc) => bloc
              ..add(
                const PickImage(
                  imagePickerSource: imagePickerSource,
                ),
              ),
            expect: () => const [
              EditImageState(),
              EditImageState(status: EditImageStatus.canceled),
            ],
            verify: (_) {
              verify(() => mockAppImagePicker.pickImage(imageSource)).called(1);
              verifyNoMoreInteractions(mockAppImagePicker);
            },
          );
          blocTest(
            'should not freeze the bloc stream when AppImagePicker '
            'returns a future which never complete',
            build: () {
              final completer = Completer<Uint8List>();
              when(() => mockAppImagePicker.pickImage(imageSource))
                  .thenAnswer((_) => completer.future);
              return editImageBloc;
            },
            act: (EditImageBloc bloc) => bloc
              ..add(
                const PickImage(
                  imagePickerSource: imagePickerSource,
                ),
              )
              ..add(CancelEditingImage()),
            expect: () => const [
              EditImageState(),
              EditImageState(status: EditImageStatus.canceled),
            ],
            verify: (_) {
              verify(() => mockAppImagePicker.pickImage(imageSource)).called(1);
              verifyNoMoreInteractions(mockAppImagePicker);
            },
          );
        },
      );

      group(
        'CancelEditingImage',
        () {
          blocTest(
            'should emit state with status canceled when cancel editing image',
            build: () => editImageBloc,
            act: (EditImageBloc bloc) => bloc..add(CancelEditingImage()),
            expect: () => [
              const EditImageState(
                status: EditImageStatus.canceled,
              ),
            ],
          );
        },
      );

      group(
        'CompleteEditingImage',
        () {
          blocTest(
            'should emit state with status completed and image from last state '
            'after editing image',
            build: () {
              when(() => mockAppImagePicker.pickImage(imageSource))
                  .thenAnswer((_) => Future.value(image));
              return editImageBloc;
            },
            act: (EditImageBloc bloc) => bloc
              ..add(const PickImage(imagePickerSource: imagePickerSource))
              ..add(CompleteEditingImage()),
            expect: () => [
              const EditImageState(),
              EditImageState(
                status: EditImageStatus.editing,
                image: image,
              ),
              EditImageState(
                status: EditImageStatus.completed,
                image: image,
              ),
            ],
            verify: (_) {
              verify(() => mockAppImagePicker.pickImage(imageSource)).called(1);
              verifyNoMoreInteractions(mockAppImagePicker);
            },
          );
        },
      );
    },
  );
}
