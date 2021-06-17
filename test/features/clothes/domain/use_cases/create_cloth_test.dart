import 'package:clothes/features/clothes/domain/repositories/base_clothes_repository.dart';
import 'package:clothes/features/clothes/domain/use_cases/create_cloth.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/entities.dart';

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

      test(
        'should create new cloth in the repository',
        () async {
          // arrange
          when(() => repository.createCloth(cloth1))
              .thenAnswer((_) async => Right(cloth1.id));
          // act
          final result = await useCase(CreateClothParams(cloth: cloth1));
          // assert
          expect(result, equals(Right(cloth1.id)));
          verify(() => repository.createCloth(cloth1)).called(1);
          verifyNoMoreInteractions(repository);
        },
      );
    },
  );

  group(
    'CreateClothParams',
    () {
      test('should return correct props', () {
        expect(CreateClothParams(cloth: cloth1).props, [cloth1]);
      });
    },
  );
}
