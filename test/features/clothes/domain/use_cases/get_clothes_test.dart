import 'package:clothes/core/use_cases/no_params.dart';
import 'package:clothes/features/clothes/domain/repositories/base_clothes_repository.dart';
import 'package:clothes/features/clothes/domain/use_cases/get_clothes.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/entities.dart';

class MockClothesRepository extends Mock implements BaseClothesRepository {}

void main() {
  group(
    'GetClothes',
    () {
      late GetClothes useCase;
      late MockClothesRepository repository;

      setUp(() {
        repository = MockClothesRepository();
        useCase = GetClothes(repository);
      });

      test(
        'should get all clothes from the repository',
        () async {
          // arrange
          when(() => repository.getClothes()).thenAnswer((_) =>
              Stream.fromIterable([Right(emptyClothes), Right(clothes1)]));
          // act
          final stream = useCase(NoParams());
          // assert
          await expectLater(
            stream,
            emitsInOrder([Right(emptyClothes), Right(clothes1)]),
          );
          verify(() => repository.getClothes()).called(1);
          verifyNoMoreInteractions(repository);
        },
      );
    },
  );
}
