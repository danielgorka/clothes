import 'dart:typed_data';

import 'package:clothes/core/platform/app_image_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';

class MockPickedFile extends Mock implements PickedFile {}

class MockImagePicker extends Mock implements ImagePicker {}

void main() {
  group(
    'AppImagePicker',
    () {
      late MockPickedFile mockPickedFile;
      late MockImagePicker mockImagePicker;
      late AppImagePicker appImagePicker;

      setUp(() {
        mockPickedFile = MockPickedFile();
        mockImagePicker = MockImagePicker();
        appImagePicker = AppImagePicker(imagePicker: mockImagePicker);
      });

      final image = Uint8List.fromList([1, 2, 3, 4]);

      group(
        'pickImage',
        () {
          const source = ImageSource.gallery;

          test(
            'should call ImagePicker.getImage() and '
            'return PickedFile.readAsBytes()',
            () async {
              // arrange
              when(() => mockPickedFile.readAsBytes())
                  .thenAnswer((_) => Future.value(image));
              when(() => mockImagePicker.getImage(source: source))
                  .thenAnswer((_) => Future.value(mockPickedFile));
              // act
              final result = await appImagePicker.pickImage(source);
              // assert
              expect(result, equals(image));
              verify(() => mockPickedFile.readAsBytes()).called(1);
              verify(() => mockImagePicker.getImage(source: source)).called(1);
              verifyNoMoreInteractions(mockPickedFile);
              verifyNoMoreInteractions(mockImagePicker);
            },
          );
          test(
            'should return null when ImagePicker.getImage() returns null',
            () async {
              // arrange
              when(() => mockImagePicker.getImage(source: source))
                  .thenAnswer((_) => Future.value(null));
              // act
              final result = await appImagePicker.pickImage(source);
              // assert
              expect(result, isNull);
              verify(() => mockImagePicker.getImage(source: source)).called(1);
              verifyNoMoreInteractions(mockImagePicker);
            },
          );
        },
      );

      group(
        'retrieveLostData',
        () {
          test(
            'should call ImagePicker.getLostData() and '
            'return PickedFile.readAsBytes()',
            () async {
              // arrange
              final lostData = LostData(file: mockPickedFile);
              when(() => mockPickedFile.readAsBytes())
                  .thenAnswer((_) => Future.value(image));
              when(() => mockImagePicker.getLostData())
                  .thenAnswer((_) => Future.value(lostData));
              // act
              final result = await appImagePicker.retrieveLostData();
              // assert
              expect(result, equals(image));
              verify(() => mockPickedFile.readAsBytes()).called(1);
              verify(() => mockImagePicker.getLostData()).called(1);
              verifyNoMoreInteractions(mockPickedFile);
              verifyNoMoreInteractions(mockImagePicker);
            },
          );
          test(
            'should return null when ImagePicker.getLostData() '
            'returns LostData with null file',
            () async {
              // arrange
              final emptyLostData = LostData.empty();
              when(() => mockImagePicker.getLostData())
                  .thenAnswer((_) => Future.value(emptyLostData));
              // act
              final result = await appImagePicker.retrieveLostData();
              // assert
              expect(result, isNull);
              verify(() => mockImagePicker.getLostData()).called(1);
              verifyNoMoreInteractions(mockImagePicker);
            },
          );
        },
      );
    },
  );
}
