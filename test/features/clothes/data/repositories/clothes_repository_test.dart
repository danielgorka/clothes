import 'dart:typed_data';

import 'package:clothes/core/error/exceptions.dart';
import 'package:clothes/core/error/failures.dart';
import 'package:clothes/features/clothes/data/data_sources/clothes_local_data_source.dart';
import 'package:clothes/features/clothes/data/data_sources/images_local_data_source.dart';
import 'package:clothes/features/clothes/data/models/cloth_image_model.dart';
import 'package:clothes/features/clothes/data/models/cloth_model.dart';
import 'package:clothes/features/clothes/data/models/cloth_tag_model.dart';
import 'package:clothes/features/clothes/data/repositories/clothes_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockClothesLocalDataSource extends Mock
    implements BaseClothesLocalDataSource {}

class MockImagesLocalDataSource extends Mock
    implements BaseImagesLocalDataSource {}

typedef MockFunction = dynamic Function();
typedef ActFunction = Future Function();

void main() {
  group(
    'ClothesRepository',
    () {
      late BaseClothesLocalDataSource mockClothesLocalDataSource;
      late BaseImagesLocalDataSource mockImagesLocalDataSource;
      late ClothesRepository repository;

      Future<void> shouldReturnFailure({
        required MockFunction mockFunction,
        required ActFunction actFunction,
        required Exception exception,
        required dynamic expectValue,
      }) async {
        // arrange
        when(mockFunction).thenThrow(exception);
        // act
        final result = await actFunction();
        // assert
        expect(result, equals(expectValue));
        verify(mockFunction).called(1);
      }

      setUp(() {
        mockClothesLocalDataSource = MockClothesLocalDataSource();
        mockImagesLocalDataSource = MockImagesLocalDataSource();
        repository = ClothesRepository(
          clothesDataSource: mockClothesLocalDataSource,
          imagesDataSource: mockImagesLocalDataSource,
        );
      });

      final clothImageData = Uint8List.fromList([1, 2, 3, 4, 5, 6]);

      const clothImageId = 1;
      const clothImagePath = 'path';
      const clothImageModel = ClothImageModel(
        id: clothImageId,
        path: clothImagePath,
      );
      final clothImage = clothImageModel.toEntity();

      const clothTagId = 2;
      const clothTagModel = ClothTagModel(
        id: clothTagId,
        type: 'color',
        name: 'Blue',
      );
      final clothTag = clothTagModel.toEntity();

      const clothId = 3;
      final clothModel = ClothModel(
        id: clothId,
        name: 'T-shirt',
        description: '',
        imagesIds: const [1],
        tagsIds: const [2],
        favourite: true,
        order: 2,
        creationDate: DateTime.now(),
      );
      final cloth = clothModel.toEntity(images: [clothImage], tags: [clothTag]);

      group(
        'getClothes',
        () {
          test(
            'should return stream of lists of all saved clothes',
            () async {
              // arrange
              final clothesModelsList = List.filled(5, clothModel);
              final clothesList = List.filled(5, cloth);

              final secondClothesModelsList = List.filled(6, clothModel);
              final secondClothesList = List.filled(6, cloth);

              final stream = Stream.fromIterable([
                clothesModelsList,
                secondClothesModelsList,
              ]);

              when(() => mockClothesLocalDataSource.getClothes())
                  .thenAnswer((_) => stream);

              when(() => mockClothesLocalDataSource.getClothImages())
                  .thenAnswer((_) => Stream.value([clothImageModel]));
              when(() => mockClothesLocalDataSource.getClothTags())
                  .thenAnswer((_) => Stream.value([clothTagModel]));
              // act
              final result = repository.getClothes();
              // assert
              final eventList = await result.take(2).toList();
              expect(eventList[0].getOrElse(() => []), equals(clothesList));
              expect(
                  eventList[1].getOrElse(() => []), equals(secondClothesList));

              verify(() => mockClothesLocalDataSource.getClothes()).called(1);
              verify(() => mockClothesLocalDataSource.getClothImages())
                  .called(1);
              verify(() => mockClothesLocalDataSource.getClothTags()).called(1);
              verifyNoMoreInteractions(mockClothesLocalDataSource);
              verifyNoMoreInteractions(mockImagesLocalDataSource);
            },
          );
          test(
            'should return stream with DatabaseFailure '
            'when data source return DatabaseException',
            () async {
              // arrange
              when(() => mockClothesLocalDataSource.getClothes())
                  .thenThrow(DatabaseException());
              when(() => mockClothesLocalDataSource.getClothTags())
                  .thenAnswer((_) => Stream.value([clothTagModel]));
              when(() => mockClothesLocalDataSource.getClothImages())
                  .thenAnswer((_) => Stream.value([clothImageModel]));
              // act
              final result = repository.getClothes();
              // assert
              await expectLater(
                result,
                emits(Left(DatabaseFailure())),
              );
              verify(() => mockClothesLocalDataSource.getClothes()).called(1);
              verify(() => mockClothesLocalDataSource.getClothTags()).called(1);
              verify(() => mockClothesLocalDataSource.getClothImages())
                  .called(1);
              verifyNoMoreInteractions(mockClothesLocalDataSource);
              verifyNoMoreInteractions(mockImagesLocalDataSource);
            },
          );
          test(
            'should return stream with ObjectNotFoundFailure '
            'when data source return ObjectNotFoundException',
            () async {
              // arrange
              when(() => mockClothesLocalDataSource.getClothes())
                  .thenThrow(ObjectNotFoundException());
              when(() => mockClothesLocalDataSource.getClothTags())
                  .thenAnswer((_) => Stream.value([clothTagModel]));
              when(() => mockClothesLocalDataSource.getClothImages())
                  .thenAnswer((_) => Stream.value([clothImageModel]));
              // act
              final result = repository.getClothes();
              // assert
              await expectLater(
                result,
                emits(Left(ObjectNotFoundFailure())),
              );
              verify(() => mockClothesLocalDataSource.getClothes()).called(1);
              verify(() => mockClothesLocalDataSource.getClothTags()).called(1);
              verify(() => mockClothesLocalDataSource.getClothImages())
                  .called(1);
              verifyNoMoreInteractions(mockClothesLocalDataSource);
              verifyNoMoreInteractions(mockImagesLocalDataSource);
            },
          );
        },
      );

      group(
        'getCloth',
        () {
          test(
            'should return the cloth with the given id',
            () async {
              // arrange
              when(() => mockClothesLocalDataSource.getCloth(any()))
                  .thenAnswer((_) => Future.value(clothModel));
              when(() => mockClothesLocalDataSource.getClothTag(any()))
                  .thenAnswer((_) => Future.value(clothTagModel));
              when(() => mockClothesLocalDataSource.getClothImage(any()))
                  .thenAnswer((_) => Future.value(clothImageModel));
              // act
              final result = await repository.getCloth(clothId);
              // assert
              expect(result, equals(Right(cloth)));
              verify(() => mockClothesLocalDataSource.getCloth(clothId))
                  .called(1);
              verify(() => mockClothesLocalDataSource.getClothTag(clothTagId))
                  .called(1);
              verify(() =>
                      mockClothesLocalDataSource.getClothImage(clothImageId))
                  .called(1);
              verifyNoMoreInteractions(mockClothesLocalDataSource);
              verifyNoMoreInteractions(mockImagesLocalDataSource);
            },
          );
          test(
            'should return DatabaseFailure when '
            'the data source throws DatabaseException',
            () async {
              await shouldReturnFailure(
                mockFunction: () =>
                    mockClothesLocalDataSource.getCloth(clothId),
                actFunction: () => repository.getCloth(clothId),
                exception: DatabaseException(),
                expectValue: Left(DatabaseFailure()),
              );
              verifyNoMoreInteractions(mockClothesLocalDataSource);
              verifyNoMoreInteractions(mockImagesLocalDataSource);
            },
          );
          test(
            'should return ObjectNotFoundFailure when '
            'the data source throws ObjectNotFoundException',
            () async {
              await shouldReturnFailure(
                mockFunction: () =>
                    mockClothesLocalDataSource.getCloth(clothId),
                actFunction: () => repository.getCloth(clothId),
                exception: ObjectNotFoundException(),
                expectValue: Left(ObjectNotFoundFailure()),
              );
              verifyNoMoreInteractions(mockClothesLocalDataSource);
              verifyNoMoreInteractions(mockImagesLocalDataSource);
            },
          );
        },
      );

      group(
        'createCloth',
        () {
          test(
            'should return id of the created cloth',
            () async {
              // arrange
              const newId = 231;
              when(() => mockClothesLocalDataSource.createCloth(clothModel))
                  .thenAnswer((_) => Future.value(newId));
              // act
              final result = await repository.createCloth(cloth);
              // assert
              expect(result, equals(const Right(newId)));
              verify(() => mockClothesLocalDataSource.createCloth(clothModel))
                  .called(1);
              verifyNoMoreInteractions(mockClothesLocalDataSource);
              verifyNoMoreInteractions(mockImagesLocalDataSource);
            },
          );
          test(
            'should return DatabaseFailure when '
            'the data source throws DatabaseException',
            () async {
              await shouldReturnFailure(
                mockFunction: () =>
                    mockClothesLocalDataSource.createCloth(clothModel),
                actFunction: () => repository.createCloth(cloth),
                exception: DatabaseException(),
                expectValue: Left(DatabaseFailure()),
              );
              verifyNoMoreInteractions(mockClothesLocalDataSource);
              verifyNoMoreInteractions(mockImagesLocalDataSource);
            },
          );
          test(
            'should return ObjectNotFoundFailure when '
            'the data source throws ObjectNotFoundException',
            () async {
              await shouldReturnFailure(
                mockFunction: () =>
                    mockClothesLocalDataSource.createCloth(clothModel),
                actFunction: () => repository.createCloth(cloth),
                exception: ObjectNotFoundException(),
                expectValue: Left(ObjectNotFoundFailure()),
              );
              verifyNoMoreInteractions(mockClothesLocalDataSource);
              verifyNoMoreInteractions(mockImagesLocalDataSource);
            },
          );
        },
      );

      group(
        'updateCloth',
        () {
          test(
            'should return null when cloth was updated successfully',
            () async {
              // arrange
              when(() => mockClothesLocalDataSource.updateCloth(clothModel))
                  .thenAnswer((_) => Future.value(null));
              // act
              final result = await repository.updateCloth(cloth);
              // assert
              expect(result, equals(null));
              verify(() => mockClothesLocalDataSource.updateCloth(clothModel))
                  .called(1);
              verifyNoMoreInteractions(mockClothesLocalDataSource);
              verifyNoMoreInteractions(mockImagesLocalDataSource);
            },
          );
          test(
            'should return DatabaseFailure when '
            'the data source throws DatabaseException',
            () async {
              await shouldReturnFailure(
                mockFunction: () =>
                    mockClothesLocalDataSource.updateCloth(clothModel),
                actFunction: () => repository.updateCloth(cloth),
                exception: DatabaseException(),
                expectValue: DatabaseFailure(),
              );
              verifyNoMoreInteractions(mockClothesLocalDataSource);
              verifyNoMoreInteractions(mockImagesLocalDataSource);
            },
          );
          test(
            'should return ObjectNotFoundFailure when '
            'the data source throws ObjectNotFoundException',
            () async {
              await shouldReturnFailure(
                mockFunction: () =>
                    mockClothesLocalDataSource.updateCloth(clothModel),
                actFunction: () => repository.updateCloth(cloth),
                exception: ObjectNotFoundException(),
                expectValue: ObjectNotFoundFailure(),
              );
              verifyNoMoreInteractions(mockClothesLocalDataSource);
              verifyNoMoreInteractions(mockImagesLocalDataSource);
            },
          );
        },
      );

      group(
        'deleteCloth',
        () {
          test(
            'should return null when cloth was deleted successfully',
            () async {
              // arrange
              when(() => mockClothesLocalDataSource.deleteCloth(clothId))
                  .thenAnswer((_) => Future.value(null));
              // act
              final result = await repository.deleteCloth(clothId);
              // assert
              expect(result, equals(null));
              verify(() => mockClothesLocalDataSource.deleteCloth(clothId))
                  .called(1);
              verifyNoMoreInteractions(mockClothesLocalDataSource);
              verifyNoMoreInteractions(mockImagesLocalDataSource);
            },
          );
          test(
            'should return DatabaseFailure when '
            'the data source throws DatabaseException',
            () async {
              await shouldReturnFailure(
                mockFunction: () =>
                    mockClothesLocalDataSource.deleteCloth(clothId),
                actFunction: () => repository.deleteCloth(clothId),
                exception: DatabaseException(),
                expectValue: DatabaseFailure(),
              );
              verifyNoMoreInteractions(mockClothesLocalDataSource);
              verifyNoMoreInteractions(mockImagesLocalDataSource);
            },
          );
          test(
            'should returnObjectNotFoundFailure when '
            'the data source throws ObjectNotFoundException',
            () async {
              await shouldReturnFailure(
                mockFunction: () =>
                    mockClothesLocalDataSource.deleteCloth(clothId),
                actFunction: () => repository.deleteCloth(clothId),
                exception: ObjectNotFoundException(),
                expectValue: ObjectNotFoundFailure(),
              );
              verifyNoMoreInteractions(mockClothesLocalDataSource);
              verifyNoMoreInteractions(mockImagesLocalDataSource);
            },
          );
        },
      );

      group(
        'addClothImage',
        () {
          const tempClothImageModel =
              ClothImageModel(id: 0, path: clothImagePath);

          test(
            'should return saved image',
            () async {
              // arrange
              final newClothModel = clothModel.copyWith(
                  imagesIds: clothModel.imagesIds + [clothImageId]);

              when(() => mockImagesLocalDataSource.saveImage(clothImageData))
                  .thenAnswer((_) => Future.value(clothImagePath));
              when(() => mockClothesLocalDataSource
                      .createClothImage(tempClothImageModel))
                  .thenAnswer((_) => Future.value(clothImageId));
              when(() => mockClothesLocalDataSource.getCloth(clothId))
                  .thenAnswer((_) => Future.value(clothModel));
              when(() => mockClothesLocalDataSource.updateCloth(newClothModel))
                  .thenAnswer((_) => Future.value(null));
              // act
              final result =
                  await repository.addClothImage(clothId, clothImageData);
              // assert
              expect(result, equals(Right(clothImage)));
              verify(() => mockImagesLocalDataSource.saveImage(clothImageData))
                  .called(1);
              verify(() => mockClothesLocalDataSource
                  .createClothImage(tempClothImageModel)).called(1);
              verify(() => mockClothesLocalDataSource.getCloth(clothId))
                  .called(1);
              verify(() =>
                      mockClothesLocalDataSource.updateCloth(newClothModel))
                  .called(1);
              verifyNoMoreInteractions(mockClothesLocalDataSource);
              verifyNoMoreInteractions(mockImagesLocalDataSource);
            },
          );
          test(
            'should return LocalStorageFailure when '
            'the data source throws LocalStorageException',
            () async {
              await shouldReturnFailure(
                mockFunction: () =>
                    mockImagesLocalDataSource.saveImage(clothImageData),
                actFunction: () =>
                    repository.addClothImage(clothId, clothImageData),
                exception: LocalStorageException(),
                expectValue: Left(LocalStorageFailure()),
              );
              verifyNoMoreInteractions(mockClothesLocalDataSource);
              verifyNoMoreInteractions(mockImagesLocalDataSource);
            },
          );
          test(
            'should return DatabaseFailure when '
            'the data source throws DatabaseException',
            () async {
              when(() => mockImagesLocalDataSource.saveImage(clothImageData))
                  .thenAnswer((_) => Future.value(clothImagePath));

              await shouldReturnFailure(
                mockFunction: () => mockClothesLocalDataSource
                    .createClothImage(tempClothImageModel),
                actFunction: () =>
                    repository.addClothImage(clothId, clothImageData),
                exception: DatabaseException(),
                expectValue: Left(DatabaseFailure()),
              );
              verify(() => mockImagesLocalDataSource.saveImage(clothImageData))
                  .called(1);
              verifyNoMoreInteractions(mockClothesLocalDataSource);
              verifyNoMoreInteractions(mockImagesLocalDataSource);
            },
          );
          test(
            'should return ObjectNotFoundFailure when '
            'the data source throws ObjectNotFoundException',
            () async {
              when(() => mockImagesLocalDataSource.saveImage(clothImageData))
                  .thenAnswer((_) => Future.value(clothImagePath));

              await shouldReturnFailure(
                mockFunction: () => mockClothesLocalDataSource
                    .createClothImage(tempClothImageModel),
                actFunction: () =>
                    repository.addClothImage(clothId, clothImageData),
                exception: ObjectNotFoundException(),
                expectValue: Left(ObjectNotFoundFailure()),
              );
              verify(() => mockImagesLocalDataSource.saveImage(clothImageData))
                  .called(1);
              verifyNoMoreInteractions(mockClothesLocalDataSource);
              verifyNoMoreInteractions(mockImagesLocalDataSource);
            },
          );
        },
      );

      group(
        'deleteClothImage',
        () {
          test(
            'should return null when image was deleted successfully',
            () async {
              // arrange
              final imagesIds = List.of(clothModel.imagesIds);
              imagesIds.remove(clothImageId);
              final newClothModel = clothModel.copyWith(
                imagesIds: imagesIds,
              );

              when(() => mockClothesLocalDataSource.getClothImage(clothImageId))
                  .thenAnswer((_) => Future.value(clothImageModel));
              when(() =>
                      mockClothesLocalDataSource.deleteClothImage(clothImageId))
                  .thenAnswer((_) => Future.value(null));
              when(() => mockImagesLocalDataSource.deleteImage(clothImagePath))
                  .thenAnswer((_) => Future.value(null));

              when(() => mockClothesLocalDataSource.getClothes())
                  .thenAnswer((_) => Stream.value(List.filled(5, clothModel)));
              when(() => mockClothesLocalDataSource.updateCloth(newClothModel))
                  .thenAnswer((_) => Future.value(null));
              // act
              final result = await repository.deleteClothImage(clothImageId);
              // assert
              expect(result, equals(null));
              verify(() =>
                      mockClothesLocalDataSource.getClothImage(clothImageId))
                  .called(1);
              verify(() =>
                      mockClothesLocalDataSource.deleteClothImage(clothImageId))
                  .called(1);
              verify(() =>
                      mockImagesLocalDataSource.deleteImage(clothImagePath))
                  .called(1);

              verify(() => mockClothesLocalDataSource.getClothes()).called(1);
              verify(() =>
                      mockClothesLocalDataSource.updateCloth(newClothModel))
                  .called(1);
              verifyNoMoreInteractions(mockClothesLocalDataSource);
              verifyNoMoreInteractions(mockImagesLocalDataSource);
            },
          );
          test(
            'should return LocalStorageFailure when '
            'the data source throws LocalStorageException',
            () async {
              when(() => mockClothesLocalDataSource.getClothImage(clothImageId))
                  .thenAnswer((_) => Future.value(clothImageModel));
              when(() =>
                      mockClothesLocalDataSource.deleteClothImage(clothImageId))
                  .thenAnswer((_) => Future.value(null));

              await shouldReturnFailure(
                mockFunction: () =>
                    mockImagesLocalDataSource.deleteImage(clothImagePath),
                actFunction: () => repository.deleteClothImage(clothImageId),
                exception: LocalStorageException(),
                expectValue: LocalStorageFailure(),
              );

              verify(() =>
                      mockClothesLocalDataSource.getClothImage(clothImageId))
                  .called(1);
              verify(() =>
                      mockClothesLocalDataSource.deleteClothImage(clothImageId))
                  .called(1);
              verifyNoMoreInteractions(mockClothesLocalDataSource);
              verifyNoMoreInteractions(mockImagesLocalDataSource);
            },
          );
          test(
            'should return DatabaseFailure when '
            'the data source throws DatabaseException',
            () async {
              await shouldReturnFailure(
                mockFunction: () =>
                    mockClothesLocalDataSource.getClothImage(clothImageId),
                actFunction: () => repository.deleteClothImage(clothImageId),
                exception: DatabaseException(),
                expectValue: DatabaseFailure(),
              );
              verifyNoMoreInteractions(mockClothesLocalDataSource);
              verifyNoMoreInteractions(mockImagesLocalDataSource);
            },
          );
          test(
            'should return ObjectNotFoundFailure when '
            'the data source throws ObjectNotFoundException',
            () async {
              await shouldReturnFailure(
                mockFunction: () =>
                    mockClothesLocalDataSource.getClothImage(clothImageId),
                actFunction: () => repository.deleteClothImage(clothImageId),
                exception: ObjectNotFoundException(),
                expectValue: ObjectNotFoundFailure(),
              );
              verifyNoMoreInteractions(mockClothesLocalDataSource);
              verifyNoMoreInteractions(mockImagesLocalDataSource);
            },
          );
        },
      );

      group(
        'createClothTag',
        () {
          test(
            'should return id of the created tag',
            () async {
              // arrange
              const newId = 45;
              when(() =>
                      mockClothesLocalDataSource.createClothTag(clothTagModel))
                  .thenAnswer((_) => Future.value(newId));
              // act
              final result = await repository.createClothTag(clothTag);
              // assert
              expect(result, equals(const Right(newId)));
              verify(() =>
                      mockClothesLocalDataSource.createClothTag(clothTagModel))
                  .called(1);
              verifyNoMoreInteractions(mockClothesLocalDataSource);
              verifyNoMoreInteractions(mockImagesLocalDataSource);
            },
          );
          test(
            'should return DatabaseFailure when '
            'the data source throws DatabaseException',
            () async {
              await shouldReturnFailure(
                mockFunction: () =>
                    mockClothesLocalDataSource.createClothTag(clothTagModel),
                actFunction: () => repository.createClothTag(clothTag),
                exception: DatabaseException(),
                expectValue: Left(DatabaseFailure()),
              );
              verifyNoMoreInteractions(mockClothesLocalDataSource);
              verifyNoMoreInteractions(mockImagesLocalDataSource);
            },
          );
          test(
            'should return ObjectNotFoundFailure when '
            'the data source throws ObjectNotFoundException',
            () async {
              await shouldReturnFailure(
                mockFunction: () =>
                    mockClothesLocalDataSource.createClothTag(clothTagModel),
                actFunction: () => repository.createClothTag(clothTag),
                exception: ObjectNotFoundException(),
                expectValue: Left(ObjectNotFoundFailure()),
              );
              verifyNoMoreInteractions(mockClothesLocalDataSource);
              verifyNoMoreInteractions(mockImagesLocalDataSource);
            },
          );
        },
      );

      group(
        'updateClothTag',
        () {
          test(
            'should return null when tag was updated successfully',
            () async {
              // arrange
              when(() =>
                      mockClothesLocalDataSource.updateClothTag(clothTagModel))
                  .thenAnswer((_) => Future.value(null));
              // act
              final result = await repository.updateClothTag(clothTag);
              // assert
              expect(result, equals(null));
              verify(() =>
                      mockClothesLocalDataSource.updateClothTag(clothTagModel))
                  .called(1);
              verifyNoMoreInteractions(mockClothesLocalDataSource);
              verifyNoMoreInteractions(mockImagesLocalDataSource);
            },
          );
          test(
            'should return DatabaseFailure when '
            'the data source throws DatabaseException',
            () async {
              await shouldReturnFailure(
                mockFunction: () =>
                    mockClothesLocalDataSource.updateClothTag(clothTagModel),
                actFunction: () => repository.updateClothTag(clothTag),
                exception: DatabaseException(),
                expectValue: DatabaseFailure(),
              );
              verifyNoMoreInteractions(mockClothesLocalDataSource);
              verifyNoMoreInteractions(mockImagesLocalDataSource);
            },
          );
          test(
            'should return ObjectNotFoundFailure when '
            'the data source throws ObjectNotFoundException',
            () async {
              await shouldReturnFailure(
                mockFunction: () =>
                    mockClothesLocalDataSource.updateClothTag(clothTagModel),
                actFunction: () => repository.updateClothTag(clothTag),
                exception: ObjectNotFoundException(),
                expectValue: ObjectNotFoundFailure(),
              );
              verifyNoMoreInteractions(mockClothesLocalDataSource);
              verifyNoMoreInteractions(mockImagesLocalDataSource);
            },
          );
        },
      );

      group(
        'deleteClothTag',
        () {
          test(
            'should return null when tag was deleted successfully',
            () async {
              // arrange
              when(() => mockClothesLocalDataSource.deleteClothTag(clothTagId))
                  .thenAnswer((_) => Future.value(null));
              // act
              final result = await repository.deleteClothTag(clothTagId);
              // assert
              expect(result, equals(null));
              verify(() =>
                      mockClothesLocalDataSource.deleteClothTag(clothTagId))
                  .called(1);
              verifyNoMoreInteractions(mockClothesLocalDataSource);
              verifyNoMoreInteractions(mockImagesLocalDataSource);
            },
          );
          test(
            'should return DatabaseFailure when '
            'the data source throws DatabaseException',
            () async {
              await shouldReturnFailure(
                mockFunction: () =>
                    mockClothesLocalDataSource.deleteClothTag(clothTagId),
                actFunction: () => repository.deleteClothTag(clothTagId),
                exception: DatabaseException(),
                expectValue: DatabaseFailure(),
              );
              verifyNoMoreInteractions(mockClothesLocalDataSource);
              verifyNoMoreInteractions(mockImagesLocalDataSource);
            },
          );
          test(
            'should return ObjectNotFoundFailure when '
            'the data source throws ObjectNotFoundException',
            () async {
              await shouldReturnFailure(
                mockFunction: () =>
                    mockClothesLocalDataSource.deleteClothTag(clothTagId),
                actFunction: () => repository.deleteClothTag(clothTagId),
                exception: ObjectNotFoundException(),
                expectValue: ObjectNotFoundFailure(),
              );
              verifyNoMoreInteractions(mockClothesLocalDataSource);
              verifyNoMoreInteractions(mockImagesLocalDataSource);
            },
          );
        },
      );
    },
  );
}
