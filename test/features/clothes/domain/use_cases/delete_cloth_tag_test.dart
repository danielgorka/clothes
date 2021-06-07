import 'package:clothes/features/clothes/domain/repositories/base_clothes_repository.dart';
import 'package:clothes/features/clothes/domain/use_cases/delete_cloth_tag.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockClothesRepository extends Mock implements BaseClothesRepository {}

void main() {
  group(
    'DeleteClothTag',
    () {
      late DeleteClothTag useCase;
      late MockClothesRepository repository;

      setUp(() {
        repository = MockClothesRepository();
        useCase = DeleteClothTag(repository);
      });

      const tagId = 1;
      test(
        'should delete image from cloth in the repository',
        () async {
          // arrange
          when(() => repository.deleteClothTag(tagId))
              .thenAnswer((_) async => null);
          // act
          final result = await useCase(const DeleteClothTagParams(id: tagId));
          // assert
          expect(result, equals(null));
          verify(() => repository.deleteClothTag(tagId)).called(1);
          verifyNoMoreInteractions(repository);
        },
      );
    },
  );

  group(
    'DeleteClothTagParams',
    () {
      test('should return correct props', () {
        const tagId = 1;
        expect(
          const DeleteClothTagParams(id: tagId).props,
          [tagId],
        );
      });
    },
  );
}
