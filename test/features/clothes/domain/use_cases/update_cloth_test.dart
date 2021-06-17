import 'package:clothes/features/clothes/domain/repositories/base_clothes_repository.dart';
import 'package:clothes/features/clothes/domain/use_cases/update_cloth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/entities.dart';

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

      test(
        'should update cloth in the repository',
        () async {
          // arrange
          when(() => repository.updateCloth(cloth1))
              .thenAnswer((_) async => null);
          // act
          final result = await useCase(UpdateClothParams(cloth: cloth1));
          // assert
          expect(result, equals(null));
          verify(() => repository.updateCloth(cloth1)).called(1);
          verifyNoMoreInteractions(repository);
        },
      );
    },
  );

  group(
    'UpdateClothParams',
    () {
      test('should return correct props', () {
        expect(UpdateClothParams(cloth: cloth1).props, [cloth1]);
      });
    },
  );
}
