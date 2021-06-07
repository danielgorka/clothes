import 'package:clothes/core/use_cases/no_params.dart';
import 'package:clothes/features/clothes/domain/repositories/base_clothes_repository.dart';
import 'package:clothes/features/clothes/domain/use_cases/create_cloth.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockClothesRepository extends Mock implements BaseClothesRepository {}

void main() {
  group(
    'CreateCloth',
    () {
      late CreateCloth useCase;
      late MockClothesRepository repository;

      setUp(() {
        repository = MockClothesRepository();
        useCase = CreateCloth(repository);
      });

      const clothId = 1;
      test(
        'should create new cloth in the repository',
        () async {
          // arrange
          when(() => repository.createCloth())
              .thenAnswer((_) async => const Right(clothId));
          // act
          final result = await useCase(NoParams());
          // assert
          expect(result, equals(const Right(clothId)));
          verify(() => repository.createCloth()).called(1);
          verifyNoMoreInteractions(repository);
        },
      );
    },
  );
}
