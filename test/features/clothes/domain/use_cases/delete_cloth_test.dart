import 'package:clothes/features/clothes/domain/repositories/clothes_repository.dart';
import 'package:clothes/features/clothes/domain/use_cases/delete_cloth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockClothesRepository extends Mock implements BaseClothesRepository {}

void main() {
  group(
    'DeleteCloth',
    () {
      late DeleteCloth useCase;
      late MockClothesRepository repository;

      setUp(() {
        repository = MockClothesRepository();
        useCase = DeleteCloth(repository);
      });

      const clothId = 1;
      test(
        'should delete cloth in the repository',
        () async {
          // arrange
          when(() => repository.deleteCloth(clothId))
              .thenAnswer((_) async => null);
          // act
          final result = await useCase(const DeleteClothParams(id: clothId));
          // assert
          expect(result, equals(null));
          verify(() => repository.deleteCloth(clothId)).called(1);
          verifyNoMoreInteractions(repository);
        },
      );
    },
  );

  group(
    'UpdateClothParams',
    () {
      test('should return correct props', () {
        const clothId = 1;
        expect(const DeleteClothParams(id: clothId).props, [clothId]);
      });
    },
  );
}
