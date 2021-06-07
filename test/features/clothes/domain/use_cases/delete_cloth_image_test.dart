import 'package:clothes/features/clothes/domain/repositories/base_clothes_repository.dart';
import 'package:clothes/features/clothes/domain/use_cases/delete_cloth_image.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockClothesRepository extends Mock implements BaseClothesRepository {}

void main() {
  group(
    'DeleteClothImage',
    () {
      late DeleteClothImage useCase;
      late MockClothesRepository repository;

      setUp(() {
        repository = MockClothesRepository();
        useCase = DeleteClothImage(repository);
      });

      const imageId = 1;
      test(
        'should delete image from cloth in the repository',
        () async {
          // arrange
          when(() => repository.deleteClothImage(imageId))
              .thenAnswer((_) async => null);
          // act
          final result =
              await useCase(const DeleteClothImageParams(id: imageId));
          // assert
          expect(result, equals(null));
          verify(() => repository.deleteClothImage(imageId)).called(1);
          verifyNoMoreInteractions(repository);
        },
      );
    },
  );

  group(
    'DeleteClothImageParams',
    () {
      test('should return correct props', () {
        const imageId = 1;
        expect(
          const DeleteClothImageParams(id: imageId).props,
          [imageId],
        );
      });
    },
  );
}
