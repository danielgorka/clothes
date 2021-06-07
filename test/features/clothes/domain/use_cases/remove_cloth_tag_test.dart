import 'package:clothes/features/clothes/domain/repositories/base_clothes_repository.dart';
import 'package:clothes/features/clothes/domain/use_cases/remove_cloth_tag.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockClothesRepository extends Mock implements BaseClothesRepository {}

void main() {
  group(
    'RemoveClothTag',
    () {
      late RemoveClothTag useCase;
      late MockClothesRepository repository;

      setUp(() {
        repository = MockClothesRepository();
        useCase = RemoveClothTag(repository);
      });

      const tagId = 1;
      test(
        'should remove image from cloth in the repository',
        () async {
          // arrange
          when(() => repository.removeClothTag(tagId))
              .thenAnswer((_) async => null);
          // act
          final result = await useCase(const RemoveClothTagParams(id: tagId));
          // assert
          expect(result, equals(null));
          verify(() => repository.removeClothTag(tagId)).called(1);
          verifyNoMoreInteractions(repository);
        },
      );
    },
  );

  group(
    'RemoveClothTagParams',
    () {
      test('should return correct props', () {
        const tagId = 1;
        expect(
          const RemoveClothTagParams(id: tagId).props,
          [tagId],
        );
      });
    },
  );
}
