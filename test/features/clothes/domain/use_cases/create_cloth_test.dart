import 'package:clothes/features/clothes/domain/entities/cloth.dart';
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
      final cloth = Cloth(id: clothId, creationDate: DateTime.now());
      test(
        'should create new cloth in the repository',
        () async {
          // arrange
          when(() => repository.createCloth(cloth))
              .thenAnswer((_) async => const Right(clothId));
          // act
          final result = await useCase(CreateClothParams(cloth: cloth));
          // assert
          expect(result, equals(const Right(clothId)));
          verify(() => repository.createCloth(cloth)).called(1);
          verifyNoMoreInteractions(repository);
        },
      );
    },
  );

  group(
    'CreateClothParams',
    () {
      test('should return correct props', () {
        final cloth = Cloth(id: 1, creationDate: DateTime.now());
        expect(CreateClothParams(cloth: cloth).props, [cloth]);
      });
    },
  );
}
