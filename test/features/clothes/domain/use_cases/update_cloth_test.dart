import 'package:clothes/features/clothes/domain/entities/cloth.dart';
import 'package:clothes/features/clothes/domain/repositories/base_clothes_repository.dart';
import 'package:clothes/features/clothes/domain/use_cases/update_cloth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockClothesRepository extends Mock implements BaseClothesRepository {}

void main() {
  group(
    'UpdateCloth',
    () {
      late UpdateCloth useCase;
      late MockClothesRepository repository;

      setUp(() {
        repository = MockClothesRepository();
        useCase = UpdateCloth(repository);
      });

      const clothId = 1;
      final cloth = Cloth(id: clothId, creationDate: DateTime.now());
      test(
        'should update cloth in the repository',
        () async {
          // arrange
          when(() => repository.updateCloth(cloth))
              .thenAnswer((_) async => null);
          // act
          final result = await useCase(UpdateClothParams(cloth: cloth));
          // assert
          expect(result, equals(null));
          verify(() => repository.updateCloth(cloth)).called(1);
          verifyNoMoreInteractions(repository);
        },
      );
    },
  );

  group(
    'UpdateClothParams',
    () {
      test('should return correct props', () {
        final cloth = Cloth(id: 1, creationDate: DateTime.now());
        expect(UpdateClothParams(cloth: cloth).props, [cloth]);
      });
    },
  );
}
