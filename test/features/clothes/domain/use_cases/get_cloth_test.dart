import 'package:clothes/features/clothes/domain/entities/cloth.dart';
import 'package:clothes/features/clothes/domain/repositories/clothes_repository.dart';
import 'package:clothes/features/clothes/domain/use_cases/get_cloth.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

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

      const clothId = 1;
      final cloth = Cloth(id: clothId, creationDate: DateTime.now());
      test(
        'should get cloth by id from the repository',
        () async {
          // arrange
          when(() => repository.getCloth(clothId))
              .thenAnswer((_) async => Right(cloth));
          // act
          final result = await useCase(const GetClothParams(id: clothId));
          // assert
          expect(result, equals(Right(cloth)));
          verify(() => repository.getCloth(clothId)).called(1);
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
