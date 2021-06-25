import 'dart:async';
import 'dart:typed_data';

import 'package:clothes/core/error/exceptions.dart';
import 'package:clothes/core/error/failures.dart';
import 'package:clothes/features/clothes/data/data_sources/clothes_local_data_source.dart';
import 'package:clothes/features/clothes/data/data_sources/images/base_images_local_data_source.dart';
import 'package:clothes/features/clothes/data/models/cloth_image_model.dart';
import 'package:clothes/features/clothes/data/repositories/clothes_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../helpers/entities.dart';
import '../../../../helpers/models.dart';

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

      group(
        'getClothes',
        () {
          test(
            'should return stream with lists of all saved clothes '
            'last emitted in the each 200 ms',
            () async {
              // arrange
              final clothesModelsList = List.filled(5, clothModel2);
              final clothesList = List.filled(5, cloth2);

              final secondClothesModelsList = List.filled(6, clothModel2);
              final secondClothesList = List.filled(6, cloth2);

              final stream = Rx.merge([
                Stream.fromIterable(
                  [clothesModelsList, secondClothesModelsList],
                ),
                Stream.fromIterable([clothesModelsList])
                    .interval(const Duration(milliseconds: 2 * 200)),
              ]);

              when(() => mockClothesLocalDataSource.getClothes())
                  .thenAnswer((_) => stream);

              when(() => mockClothesLocalDataSource.getClothImages())
                  .thenAnswer((_) => Stream.value([clothImageModel2]));
              when(() => mockClothesLocalDataSource.getClothTags())
                  .thenAnswer((_) => Stream.value([clothTagModel2]));
              // act
              final result = repository.getClothes();
              // assert
              final eventList = await result.take(2).toList();
              expect(
                eventList[0].getOrElse(() => []),
                equals(secondClothesList),
              );
              expect(eventList[1].getOrElse(() => []), equals(clothesList));

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
                  .thenAnswer((_) => Stream.value([clothTagModel1]));
              when(() => mockClothesLocalDataSource.getClothImages())
                  .thenAnswer((_) => Stream.value([clothImageModel1]));
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
            'should return stream with DatabaseFailure '
            'when data source return DatabaseException in streams',
            () async {
              Stream<T> errorStream<T>() async* {
                throw DatabaseException();
              }

              // arrange
              when(() => mockClothesLocalDataSource.getClothes())
                  .thenAnswer((_) => errorStream());
              when(() => mockClothesLocalDataSource.getClothTags())
                  .thenAnswer((_) => errorStream());
              when(() => mockClothesLocalDataSource.getClothImages())
                  .thenAnswer((_) => errorStream());
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
                  .thenAnswer((_) => Stream.value([clothTagModel1]));
              when(() => mockClothesLocalDataSource.getClothImages())
                  .thenAnswer((_) => Stream.value([clothImageModel1]));
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
                  .thenAnswer((_) => Future.value(clothModel2));
              when(() => mockClothesLocalDataSource.getClothTag(any()))
                  .thenAnswer((_) => Future.value(clothTagModel2));
              when(() => mockClothesLocalDataSource.getClothImage(any()))
                  .thenAnswer((_) => Future.value(clothImageModel2));
              // act
              final result = await repository.getCloth(cloth2.id);
              // assert
              expect(result, equals(Right(cloth2)));
              verify(() => mockClothesLocalDataSource.getCloth(cloth2.id))
                  .called(1);
              verify(() => mockClothesLocalDataSource.getClothTag(clothTag2.id))
                  .called(1);
              verify(() =>
                      mockClothesLocalDataSource.getClothImage(clothImage2.id))
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
                    mockClothesLocalDataSource.getCloth(cloth1.id),
                actFunction: () => repository.getCloth(cloth1.id),
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
                    mockClothesLocalDataSource.getCloth(cloth1.id),
                actFunction: () => repository.getCloth(cloth1.id),
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
              when(() => mockClothesLocalDataSource.createCloth(clothModel1))
                  .thenAnswer((_) => Future.value(newId));
              // act
              final result = await repository.createCloth(cloth1);
              // assert
              expect(result, equals(const Right(newId)));
              verify(() => mockClothesLocalDataSource.createCloth(clothModel1))
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
                    mockClothesLocalDataSource.createCloth(clothModel1),
                actFunction: () => repository.createCloth(cloth1),
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
                    mockClothesLocalDataSource.createCloth(clothModel1),
                actFunction: () => repository.createCloth(cloth1),
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
              when(() => mockClothesLocalDataSource.updateCloth(clothModel1))
                  .thenAnswer((_) => Future.value(null));
              // act
              final result = await repository.updateCloth(cloth1);
              // assert
              expect(result, equals(null));
              verify(() => mockClothesLocalDataSource.updateCloth(clothModel1))
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
                    mockClothesLocalDataSource.updateCloth(clothModel1),
                actFunction: () => repository.updateCloth(cloth1),
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
                    mockClothesLocalDataSource.updateCloth(clothModel1),
                actFunction: () => repository.updateCloth(cloth1),
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
              when(() => mockClothesLocalDataSource.deleteCloth(cloth1.id))
                  .thenAnswer((_) => Future.value(null));
              // act
              final result = await repository.deleteCloth(cloth1.id);
              // assert
              expect(result, equals(null));
              verify(() => mockClothesLocalDataSource.deleteCloth(cloth1.id))
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
                    mockClothesLocalDataSource.deleteCloth(cloth1.id),
                actFunction: () => repository.deleteCloth(cloth1.id),
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
                    mockClothesLocalDataSource.deleteCloth(cloth1.id),
                actFunction: () => repository.deleteCloth(cloth1.id),
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
          final tempClothImageModel = ClothImageModel(
            id: 0,
            path: clothImage1.path,
          );

          test(
            'should return saved image',
            () async {
              // arrange
              final newClothModel = clothModel1.copyWith(
                  imagesIds: clothModel1.imagesIds + [clothImage1.id]);

              when(() => mockImagesLocalDataSource.saveImage(clothImageData))
                  .thenAnswer((_) => Future.value(clothImage1.path));
              when(() => mockClothesLocalDataSource
                      .createClothImage(tempClothImageModel))
                  .thenAnswer((_) => Future.value(clothImage1.id));
              when(() => mockClothesLocalDataSource.getCloth(cloth1.id))
                  .thenAnswer((_) => Future.value(clothModel1));
              when(() => mockClothesLocalDataSource.updateCloth(newClothModel))
                  .thenAnswer((_) => Future.value(null));
              // act
              final result =
                  await repository.addClothImage(cloth1.id, clothImageData);
              // assert
              expect(result, equals(const Right(clothImage1)));
              verify(() => mockImagesLocalDataSource.saveImage(clothImageData))
                  .called(1);
              verify(() => mockClothesLocalDataSource
                  .createClothImage(tempClothImageModel)).called(1);
              verify(() => mockClothesLocalDataSource.getCloth(cloth1.id))
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
                    repository.addClothImage(cloth1.id, clothImageData),
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
                  .thenAnswer((_) => Future.value(clothImage1.path));

              await shouldReturnFailure(
                mockFunction: () => mockClothesLocalDataSource
                    .createClothImage(tempClothImageModel),
                actFunction: () =>
                    repository.addClothImage(cloth1.id, clothImageData),
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
                  .thenAnswer((_) => Future.value(clothImage1.path));

              await shouldReturnFailure(
                mockFunction: () => mockClothesLocalDataSource
                    .createClothImage(tempClothImageModel),
                actFunction: () =>
                    repository.addClothImage(cloth1.id, clothImageData),
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
              final imagesIds = List.of(clothModel1.imagesIds);
              imagesIds.remove(clothImage1.id);
              final newClothModel = clothModel1.copyWith(
                imagesIds: imagesIds,
              );

              when(() =>
                      mockClothesLocalDataSource.getClothImage(clothImage1.id))
                  .thenAnswer((_) => Future.value(clothImageModel1));
              when(() => mockClothesLocalDataSource.deleteClothImage(
                  clothImage1.id)).thenAnswer((_) => Future.value(null));
              when(() =>
                      mockImagesLocalDataSource.deleteImage(clothImage1.path))
                  .thenAnswer((_) => Future.value(null));

              when(() => mockClothesLocalDataSource.getClothes())
                  .thenAnswer((_) => Stream.value(List.filled(5, clothModel1)));
              when(() => mockClothesLocalDataSource.updateCloth(newClothModel))
                  .thenAnswer((_) => Future.value(null));
              // act
              final result = await repository.deleteClothImage(clothImage1.id);
              // assert
              expect(result, equals(null));
              verify(() =>
                      mockClothesLocalDataSource.getClothImage(clothImage1.id))
                  .called(1);
              verify(() => mockClothesLocalDataSource
                  .deleteClothImage(clothImage1.id)).called(1);
              verify(() =>
                      mockImagesLocalDataSource.deleteImage(clothImage1.path))
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
              when(() =>
                      mockClothesLocalDataSource.getClothImage(clothImage1.id))
                  .thenAnswer((_) => Future.value(clothImageModel1));
              when(() => mockClothesLocalDataSource.deleteClothImage(
                  clothImage1.id)).thenAnswer((_) => Future.value(null));

              await shouldReturnFailure(
                mockFunction: () =>
                    mockImagesLocalDataSource.deleteImage(clothImage1.path),
                actFunction: () => repository.deleteClothImage(clothImage1.id),
                exception: LocalStorageException(),
                expectValue: LocalStorageFailure(),
              );

              verify(() =>
                      mockClothesLocalDataSource.getClothImage(clothImage1.id))
                  .called(1);
              verify(() => mockClothesLocalDataSource
                  .deleteClothImage(clothImage1.id)).called(1);
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
                    mockClothesLocalDataSource.getClothImage(clothImage1.id),
                actFunction: () => repository.deleteClothImage(clothImage1.id),
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
                    mockClothesLocalDataSource.getClothImage(clothImage1.id),
                actFunction: () => repository.deleteClothImage(clothImage1.id),
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
                      mockClothesLocalDataSource.createClothTag(clothTagModel1))
                  .thenAnswer((_) => Future.value(newId));
              // act
              final result = await repository.createClothTag(clothTag1);
              // assert
              expect(result, equals(const Right(newId)));
              verify(() =>
                      mockClothesLocalDataSource.createClothTag(clothTagModel1))
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
                    mockClothesLocalDataSource.createClothTag(clothTagModel1),
                actFunction: () => repository.createClothTag(clothTag1),
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
                    mockClothesLocalDataSource.createClothTag(clothTagModel1),
                actFunction: () => repository.createClothTag(clothTag1),
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
                      mockClothesLocalDataSource.updateClothTag(clothTagModel1))
                  .thenAnswer((_) => Future.value(null));
              // act
              final result = await repository.updateClothTag(clothTag1);
              // assert
              expect(result, equals(null));
              verify(() =>
                      mockClothesLocalDataSource.updateClothTag(clothTagModel1))
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
                    mockClothesLocalDataSource.updateClothTag(clothTagModel1),
                actFunction: () => repository.updateClothTag(clothTag1),
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
                    mockClothesLocalDataSource.updateClothTag(clothTagModel1),
                actFunction: () => repository.updateClothTag(clothTag1),
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
              when(() =>
                      mockClothesLocalDataSource.deleteClothTag(clothTag1.id))
                  .thenAnswer((_) => Future.value(null));
              // act
              final result = await repository.deleteClothTag(clothTag1.id);
              // assert
              expect(result, equals(null));
              verify(() =>
                      mockClothesLocalDataSource.deleteClothTag(clothTag1.id))
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
                    mockClothesLocalDataSource.deleteClothTag(clothTag1.id),
                actFunction: () => repository.deleteClothTag(clothTag1.id),
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
                    mockClothesLocalDataSource.deleteClothTag(clothTag1.id),
                actFunction: () => repository.deleteClothTag(clothTag1.id),
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
