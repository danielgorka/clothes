import 'package:clothes/features/clothes/domain/repositories/base_clothes_repository.dart';
import 'package:clothes/features/clothes/domain/use_cases/remove_cloth_image.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockClothesRepository extends Mock implements BaseClothesRepository {}

void main() {
  group(
    'RemoveClothImage',
    () {
      late RemoveClothImage useCase;
      late MockClothesRepository repository;

      setUp(() {
        repository = MockClothesRepository();
        useCase = RemoveClothImage(repository);
      });

      const imageId = 1;
      test(
        'should remove image from cloth in the repository',
        () async {
          // arrange
          when(() => repository.removeClothImage(imageId))
              .thenAnswer((_) async => null);
          // act
          final result =
              await useCase(const RemoveClothImageParams(id: imageId));
          // assert
          expect(result, equals(null));
          verify(() => repository.removeClothImage(imageId)).called(1);
          verifyNoMoreInteractions(repository);
        },
      );
    },
  );

  group(
    'RemoveClothImageParams',
    () {
      test('should return correct props', () {
        const imageId = 1;
        expect(
          const RemoveClothImageParams(id: imageId).props,
          [imageId],
        );
      });
    },
  );
}
