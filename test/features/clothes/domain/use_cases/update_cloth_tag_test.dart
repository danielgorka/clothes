import 'package:clothes/features/clothes/domain/entities/cloth_tag.dart';
import 'package:clothes/features/clothes/domain/repositories/clothes_repository.dart';
import 'package:clothes/features/clothes/domain/use_cases/update_cloth_tag.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockClothesRepository extends Mock implements BaseClothesRepository {}

void main() {
  group(
    'UpdateClothTag',
    () {
      late UpdateClothTag useCase;
      late MockClothesRepository repository;

      setUp(() {
        repository = MockClothesRepository();
        useCase = UpdateClothTag(repository);
      });

      const clothTag = ClothTag(
        id: 0,
        type: ClothTagType.other,
        name: 'NewTag',
      );
      test(
        'should update tag in the repository',
        () async {
          // arrange
          when(() => repository.updateClothTag(clothTag))
              .thenAnswer((_) async => null);
          // act
          final result =
              await useCase(const UpdateClothTagParams(tag: clothTag));
          // assert
          expect(result, equals(null));
          verify(() => repository.updateClothTag(clothTag)).called(1);
          verifyNoMoreInteractions(repository);
        },
      );
    },
  );

  group(
    'UpdateClothTagParams',
    () {
      test('should return correct props', () {
        const clothTag = ClothTag(
          id: 0,
          type: ClothTagType.other,
          name: 'NewTag',
        );
        expect(
          const UpdateClothTagParams(tag: clothTag).props,
          [clothTag],
        );
      });
    },
  );
}
