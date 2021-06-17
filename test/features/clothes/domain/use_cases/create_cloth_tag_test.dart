import 'package:clothes/features/clothes/domain/repositories/base_clothes_repository.dart';
import 'package:clothes/features/clothes/domain/use_cases/create_cloth_tag.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/entities.dart';

class MockClothesRepository extends Mock implements BaseClothesRepository {}

void main() {
  group(
    'CreateClothTag',
    () {
      late CreateClothTag useCase;
      late MockClothesRepository repository;

      setUp(() {
        repository = MockClothesRepository();
        useCase = CreateClothTag(repository);
      });

      test(
        'should create new tag in the repository',
        () async {
          const newId = 2;
          // arrange
          when(() => repository.createClothTag(clothTag1))
              .thenAnswer((_) async => const Right(newId));
          // act
          final result =
              await useCase(const CreateClothTagParams(tag: clothTag1));
          // assert
          expect(result, equals(const Right(newId)));
          verify(() => repository.createClothTag(clothTag1)).called(1);
          verifyNoMoreInteractions(repository);
        },
      );
    },
  );

  group(
    'CreateClothTagParams',
    () {
      test('should return correct props', () {
        expect(
          const CreateClothTagParams(tag: clothTag1).props,
          [clothTag1],
        );
      });
    },
  );
}
