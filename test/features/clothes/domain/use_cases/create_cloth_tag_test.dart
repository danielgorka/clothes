import 'package:clothes/features/clothes/domain/entities/cloth_tag.dart';
import 'package:clothes/features/clothes/domain/repositories/base_clothes_repository.dart';
import 'package:clothes/features/clothes/domain/use_cases/create_cloth_tag.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockClothesRepository extends Mock implements BaseClothesRepository {}

void main() {
  const clothTag = ClothTag(
    id: 0,
    type: ClothTagType.other,
    name: 'NewTag',
  );

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
          when(() => repository.createClothTag(clothTag))
              .thenAnswer((_) async => const Right(newId));
          // act
          final result =
              await useCase(const CreateClothTagParams(tag: clothTag));
          // assert
          expect(result, equals(const Right(newId)));
          verify(() => repository.createClothTag(clothTag)).called(1);
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
          const CreateClothTagParams(tag: clothTag).props,
          [clothTag],
        );
      });
    },
  );
}
