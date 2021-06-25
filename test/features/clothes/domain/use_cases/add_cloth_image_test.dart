import 'dart:typed_data';

import 'package:clothes/features/clothes/domain/repositories/base_clothes_repository.dart';
import 'package:clothes/features/clothes/domain/use_cases/add_cloth_image.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/entities.dart';

class MockClothesRepository extends Mock implements BaseClothesRepository {}

void main() {
  group(
    'AddClothImage',
    () {
      late AddClothImage useCase;
      late MockClothesRepository repository;

      setUp(() {
        repository = MockClothesRepository();
        useCase = AddClothImage(repository);
      });

      const clothId = 1;
      final imageData = Uint8List(10);
      test(
        'should add image to cloth in the repository',
        () async {
          // arrange
          when(() => repository.addClothImage(clothId, imageData))
              .thenAnswer((_) async => const Right(clothImage1));
          // act
          final result = await useCase(
              AddClothImageParams(clothId: clothId, image: imageData));
          // assert
          expect(result, equals(const Right(clothImage1)));
          verify(() => repository.addClothImage(clothId, imageData)).called(1);
          verifyNoMoreInteractions(repository);
        },
      );
    },
  );

  group(
    'AddClothImageParams',
    () {
      test('should return correct props', () {
        const clothId = 1;
        final imageData = Uint8List(10);
        expect(
          AddClothImageParams(clothId: clothId, image: imageData).props,
          [clothId, imageData],
        );
      });
    },
  );
}
