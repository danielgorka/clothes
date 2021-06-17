import 'package:clothes/features/clothes/domain/repositories/base_clothes_repository.dart';
import 'package:clothes/features/clothes/domain/use_cases/update_cloth_tag.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/entities.dart';

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

      test(
        'should update tag in the repository',
        () async {
          // arrange
          when(() => repository.updateClothTag(clothTag1))
              .thenAnswer((_) async => null);
          // act
          final result =
              await useCase(const UpdateClothTagParams(tag: clothTag1));
          // assert
          expect(result, equals(null));
          verify(() => repository.updateClothTag(clothTag1)).called(1);
          verifyNoMoreInteractions(repository);
        },
      );
    },
  );

  group(
    'UpdateClothTagParams',
    () {
      test('should return correct props', () {
        expect(
          const UpdateClothTagParams(tag: clothTag1).props,
          [clothTag1],
        );
      });
    },
  );
}
