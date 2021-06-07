import 'package:clothes/features/clothes/domain/entities/cloth_tag.dart';
import 'package:clothes/features/clothes/domain/repositories/base_clothes_repository.dart';
import 'package:clothes/features/clothes/domain/use_cases/create_cloth_tag.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

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

      const tagType = ClothTagType.other;
      const tagName = 'NewTag';
      const clothTag = ClothTag(
        id: 0,
        type: tagType,
        name: tagName,
      );
      test(
        'should create new tag in the repository',
        () async {
          // arrange
          when(() => repository.createClothTag(tagType, tagName))
              .thenAnswer((_) async => const Right(clothTag));
          // act
          final result = await useCase(
              const CreateClothTagParams(type: tagType, name: tagName));
          // assert
          expect(result, equals(const Right(clothTag)));
          verify(() => repository.createClothTag(tagType, tagName)).called(1);
          verifyNoMoreInteractions(repository);
        },
      );
    },
  );

  group(
    'CreateClothTagParams',
    () {
      test('should return correct props', () {
        const tagType = ClothTagType.other;
        const tagName = 'NewTag';
        expect(
          const CreateClothTagParams(type: tagType, name: tagName).props,
          [tagType, tagName],
        );
      });
    },
  );
}
