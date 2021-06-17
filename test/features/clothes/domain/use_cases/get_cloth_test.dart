import 'package:clothes/features/clothes/domain/repositories/base_clothes_repository.dart';
import 'package:clothes/features/clothes/domain/use_cases/get_cloth.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/entities.dart';

class MockClothesRepository extends Mock implements BaseClothesRepository {}

void main() {
  group(
    'GetCloth',
    () {
      late GetCloth useCase;
      late MockClothesRepository repository;

      setUp(() {
        repository = MockClothesRepository();
        useCase = GetCloth(repository);
      });

      test(
        'should get cloth by id from the repository',
        () async {
          // arrange
          when(() => repository.getCloth(cloth1.id))
              .thenAnswer((_) async => Right(cloth1));
          // act
          final result = await useCase(GetClothParams(id: cloth1.id));
          // assert
          expect(result, equals(Right(cloth1)));
          verify(() => repository.getCloth(cloth1.id)).called(1);
          verifyNoMoreInteractions(repository);
        },
      );
    },
  );

  group(
    'GetClothParams',
    () {
      test('should return correct props', () {
        const id = 1;
        expect(const GetClothParams(id: id).props, [id]);
      });
    },
  );
}
