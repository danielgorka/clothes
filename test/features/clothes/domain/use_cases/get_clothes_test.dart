import 'package:clothes/core/use_cases/no_params.dart';
import 'package:clothes/features/clothes/domain/entities/cloth.dart';
import 'package:clothes/features/clothes/domain/repositories/base_clothes_repository.dart';
import 'package:clothes/features/clothes/domain/use_cases/get_clothes.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

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

      final emptyList = <Cloth>[];
      final clothes = [
        Cloth(id: 0, creationDate: DateTime.now()),
        Cloth(id: 1, creationDate: DateTime.now()),
        Cloth(id: 2, creationDate: DateTime.now()),
      ];
      test(
        'should get all clothes from the repository',
        () async {
          // arrange
          when(() => repository.getClothes()).thenAnswer(
              (_) => Stream.fromIterable([Right(emptyList), Right(clothes)]));
          // act
          final stream = useCase(NoParams());
          // assert
          await expectLater(
            stream,
            emitsInOrder([Right(emptyList), Right(clothes)]),
          );
          verify(() => repository.getClothes()).called(1);
          verifyNoMoreInteractions(repository);
        },
      );
    },
  );
}
