import 'package:clothes/core/error/exceptions.dart';
import 'package:clothes/core/platform/app_platform.dart';
import 'package:clothes/core/platform/path_provider.dart';
import 'package:clothes/features/clothes/data/data_sources/clothes_local_data_source.dart';
import 'package:clothes/features/clothes/data/models/cloth_image_model.dart';
import 'package:clothes/features/clothes/data/models/cloth_model.dart';
import 'package:clothes/features/clothes/data/models/cloth_tag_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';

class MockHive extends Mock implements HiveInterface {}

class MockBox extends Mock implements Box {}

class MockPathProvider extends Mock implements BasePathProvider {}

class MockAppPlatform extends Mock implements BaseAppPlatform {}

void main() {
  group(
    'ClothesLocalDataSource',
    () {
      late MockBox mockClothesBox;
      late MockBox mockClothTagsBox;
      late MockBox mockClothImagesBox;
      late ClothesLocalDataSource clothesLocalDataSource;

      setUp(() async {
        mockClothesBox = MockBox();
        mockClothTagsBox = MockBox();
        mockClothImagesBox = MockBox();
        clothesLocalDataSource = ClothesLocalDataSource(
          clothesBox: mockClothesBox,
          clothTagsBox: mockClothTagsBox,
          clothImagesBox: mockClothImagesBox,
        );
      });

      const clothModelId = 1;
      const tagModelId = 2;
      const imageModelId = 3;

      final clothModel = ClothModel(
        id: clothModelId,
        name: 'T-shirt',
        description: '',
        imagesIds: const [imageModelId, 7],
        tagsIds: const [tagModelId, 6],
        favourite: true,
        order: 2,
        creationDate: DateTime.now(),
      );
      final clothJsonWithoutId = clothModel.toJson();
      clothJsonWithoutId.remove('id');

      const tagModel = ClothTagModel(
        id: tagModelId,
        type: 'color',
        name: 'Brown',
      );
      final tagJsonWithoutId = tagModel.toJson();
      tagJsonWithoutId.remove('id');

      const imageModel = ClothImageModel(
        id: imageModelId,
        path: 'path/path',
      );
      final imageJsonWithoutId = imageModel.toJson();
      imageJsonWithoutId.remove('id');

      const secondClothModelId = clothModelId + 1;
      const secondTagModelId = tagModelId + 1;
      const secondImageModelId = imageModelId + 1;

      final secondClothModel = ClothModel(
        id: secondClothModelId,
        name: 'Hat',
        description: '',
        imagesIds: const [secondImageModelId, 8],
        tagsIds: const [secondTagModelId, 9],
        favourite: false,
        order: 3,
        creationDate: DateTime.now(),
      );
      final secondClothJsonWithoutId = secondClothModel.toJson();
      secondClothJsonWithoutId.remove('id');

      const secondTagModel = ClothTagModel(
        id: secondTagModelId,
        type: 'other',
        name: 'Winter',
      );
      final secondTagJsonWithoutId = secondTagModel.toJson();
      secondTagJsonWithoutId.remove('id');

      const secondImageModel = ClothImageModel(
        id: secondImageModelId,
        path: 'path/2',
      );
      final secondImageJsonWithoutId = secondImageModel.toJson();
      secondImageJsonWithoutId.remove('id');

      Future<void> testStream<T>({
        required MockBox mockBox,
        required int modelId,
        required T model,
        required Map<String, dynamic> jsonWithoutId,
        required int secondModelId,
        required T secondModel,
        required Map<String, dynamic> secondJsonWithoutId,
        required Stream<List<T>> Function() actFunc,
      }) async {
        assert(modelId != secondModelId);
        // arrange
        final list1 = [model, secondModel];
        final list2 = [secondModel]; // remove first model
        final list3 = []; // remove second model
        final list4 = [model]; // add first model
        final list5 = [model]; // update first model
        final listsOrder = [list1, list2, list3, list4, list5];

        final events = [
          BoxEvent(modelId, jsonWithoutId, true), // remove first model
          BoxEvent(
            secondModelId,
            secondJsonWithoutId,
            true,
          ), // remove second model
          BoxEvent(modelId, jsonWithoutId, false), // add first model
          BoxEvent(modelId, jsonWithoutId, false), // update first model
        ];

        when(() => mockBox.watch())
            .thenAnswer((_) => Stream.fromIterable(events));
        when(() => mockBox.getAt(0)).thenAnswer((_) => jsonWithoutId);
        when(() => mockBox.getAt(1)).thenAnswer((_) => secondJsonWithoutId);
        when(() => mockBox.keyAt(0)).thenAnswer((_) => modelId);
        when(() => mockBox.keyAt(1)).thenAnswer((_) => secondModelId);
        when(() => mockBox.length).thenAnswer((_) => list1.length);
        // act
        final stream = actFunc();
        // assert
        await expectLater(stream, emitsInOrder(listsOrder));
        verify(() => mockBox.length).called(1);
        verify(() => mockBox.getAt(any())).called(list1.length);
        verify(() => mockBox.keyAt(any())).called(list1.length);
        verify(() => mockBox.watch()).called(1);
        verifyNoMoreInteractions(mockBox);
      }

      Future<void> testGettingModel<T>({
        required MockBox mockBox,
        required int modelId,
        required T model,
        required Map<String, dynamic> jsonWithoutId,
        required Future<T> Function() actFunc,
      }) async {
        // arrange
        when(() => mockBox.get(modelId)).thenAnswer((_) => jsonWithoutId);
        // act
        final result = await actFunc();
        // assert
        expect(result, equals(model));
        verify(() => mockBox.get(modelId)).called(1);
        verifyNoMoreInteractions(mockBox);
      }

      Future<void> testGettingUnknownModel<T>({
        required MockBox mockBox,
        required int modelId,
        required Future<T> Function() actFunc,
      }) async {
        // arrange
        when(() => mockBox.get(modelId)).thenAnswer((_) => null);
        // assert
        await expectLater(
          actFunc(),
          throwsA(const TypeMatcher<ObjectNotFoundException>()),
        );
        verify(() => mockBox.get(any())).called(1);
        verifyNoMoreInteractions(mockBox);
      }

      Future<void> testCreatingModel({
        required MockBox mockBox,
        required int modelId,
        required Map<String, dynamic> jsonWithoutId,
        required Future<int> Function() actFunc,
      }) async {
        // arrange
        final newId = modelId + 1;
        when(() => mockBox.add(jsonWithoutId))
            .thenAnswer((_) => Future.value(newId));
        // act
        final result = await actFunc();
        // assert
        expect(result, newId);
        verify(() => mockBox.add(jsonWithoutId)).called(1);
        verifyNoMoreInteractions(mockBox);
      }

      Future<void> testUpdatingModel({
        required MockBox mockBox,
        required int modelId,
        required Map<String, dynamic> jsonWithoutId,
        required Future<void> Function() actFunc,
      }) async {
        // arrange
        when(() => mockBox.put(modelId, jsonWithoutId))
            .thenAnswer((_) => Future.value(null));
        // act
        await actFunc();
        // assert
        verify(() => mockBox.put(modelId, jsonWithoutId)).called(1);
        verifyNoMoreInteractions(mockBox);
      }

      Future<void> testDeletingModel({
        required MockBox mockBox,
        required int modelId,
        required Future<void> Function() actFunc,
      }) async {
        // arrange
        when(() => mockBox.delete(modelId))
            .thenAnswer((_) => Future.value(null));
        // act
        await actFunc();
        // assert
        verify(() => mockBox.delete(modelId)).called(1);
        verifyNoMoreInteractions(mockBox);
      }

      group(
        'init',
        () {
          test(
            'should call Hive.init when initiating data source '
            'in the native environment and return data source instance',
            () async {
              // arrange
              final mockHive = MockHive();
              final mockPathProvider = MockPathProvider();
              final mockAppPlatform = MockAppPlatform();
              const path = 'path';
              when(() => mockPathProvider.getAppPath())
                  .thenAnswer((_) => Future.value(path));
              when(() => mockHive.init(path))
                  .thenAnswer((_) => Future.value(null));
              when(() => mockHive.openBox(any()))
                  .thenAnswer((_) => Future.value(MockBox()));
              when(() => mockAppPlatform.isWeb)
                  .thenAnswer((_) => false);
              // act
              final result = await ClothesLocalDataSource.init(
                hive: mockHive,
                pathProvider: mockPathProvider,
                appPlatform: mockAppPlatform,
              );
              // assert
              expect(result, isA<ClothesLocalDataSource>());
              verify(() => mockPathProvider.getAppPath()).called(1);
              verify(() => mockHive.init(path)).called(1);
              verify(
                () => mockHive.openBox(ClothesLocalDataSource.clothesBoxName),
              ).called(1);
              verify(
                () => mockHive.openBox(ClothesLocalDataSource.clothTagsBoxName),
              ).called(1);
              verify(
                () =>
                    mockHive.openBox(ClothesLocalDataSource.clothImagesBoxName),
              ).called(1);
              verifyNoMoreInteractions(mockPathProvider);
              verifyNoMoreInteractions(mockHive);
            },
          );
        },
      );

      group(
        'getClothes',
        () {
          test(
            'should return stream of list of clothes from clothes box',
            () async {
              testStream(
                mockBox: mockClothesBox,
                modelId: clothModelId,
                model: clothModel,
                jsonWithoutId: clothJsonWithoutId,
                secondModelId: secondClothModelId,
                secondModel: secondClothModel,
                secondJsonWithoutId: secondClothJsonWithoutId,
                actFunc: () => clothesLocalDataSource.getClothes(),
              );
            },
          );
        },
      );

      group(
        'getCloth',
        () {
          test(
            'should return ClothModel with given id',
            () async {
              testGettingModel(
                mockBox: mockClothesBox,
                modelId: clothModelId,
                model: clothModel,
                jsonWithoutId: clothJsonWithoutId,
                actFunc: () => clothesLocalDataSource.getCloth(clothModelId),
              );
            },
          );
          test(
            'should throw ObjectNotFoundException when '
            'id not exists in the box',
            () async {
              testGettingUnknownModel(
                mockBox: mockClothesBox,
                modelId: clothModelId,
                actFunc: () => clothesLocalDataSource.getCloth(clothModelId),
              );
            },
          );
        },
      );

      group(
        'createCloth',
        () {
          test(
            'should create new cloth in clothes box and return id',
            () async {
              testCreatingModel(
                mockBox: mockClothesBox,
                modelId: clothModelId,
                jsonWithoutId: clothJsonWithoutId,
                actFunc: () => clothesLocalDataSource.createCloth(clothModel),
              );
            },
          );
        },
      );

      group(
        'updateCloth',
        () {
          test(
            'should update cloth in clothes box',
            () async {
              testUpdatingModel(
                mockBox: mockClothesBox,
                modelId: clothModelId,
                jsonWithoutId: clothJsonWithoutId,
                actFunc: () => clothesLocalDataSource.updateCloth(clothModel),
              );
            },
          );
        },
      );

      group(
        'deleteCloth',
        () {
          test(
            'should delete cloth in clothes box',
            () async {
              testDeletingModel(
                mockBox: mockClothesBox,
                modelId: clothModelId,
                actFunc: () => clothesLocalDataSource.deleteCloth(clothModelId),
              );
            },
          );
        },
      );

      group(
        'getClothTags',
        () {
          test(
            'should return stream of list of cloth tags from cloth_tags box',
            () async {
              testStream(
                mockBox: mockClothTagsBox,
                modelId: tagModelId,
                model: tagModel,
                jsonWithoutId: tagJsonWithoutId,
                secondModelId: secondTagModelId,
                secondModel: secondTagModel,
                secondJsonWithoutId: secondTagJsonWithoutId,
                actFunc: () => clothesLocalDataSource.getClothTags(),
              );
            },
          );
        },
      );

      group(
        'getClothTag',
        () {
          test(
            'should return ClothTagModel with given id',
            () async {
              testGettingModel(
                mockBox: mockClothTagsBox,
                modelId: tagModelId,
                model: tagModel,
                jsonWithoutId: tagJsonWithoutId,
                actFunc: () => clothesLocalDataSource.getClothTag(tagModelId),
              );
            },
          );
          test(
            'should throw ObjectNotFoundException when '
            'id not exists in the box',
            () async {
              testGettingUnknownModel(
                mockBox: mockClothTagsBox,
                modelId: tagModelId,
                actFunc: () => clothesLocalDataSource.getClothTag(tagModelId),
              );
            },
          );
        },
      );

      group(
        'createClothTag',
        () {
          test(
            'should create new tag in cloth_tags box and return id',
            () async {
              testCreatingModel(
                mockBox: mockClothTagsBox,
                modelId: tagModelId,
                jsonWithoutId: tagJsonWithoutId,
                actFunc: () => clothesLocalDataSource.createClothTag(tagModel),
              );
            },
          );
        },
      );

      group(
        'updateClothTag',
        () {
          test(
            'should update tag in cloth_tags box',
            () async {
              testUpdatingModel(
                mockBox: mockClothTagsBox,
                modelId: tagModelId,
                jsonWithoutId: tagJsonWithoutId,
                actFunc: () => clothesLocalDataSource.updateClothTag(tagModel),
              );
            },
          );
        },
      );

      group(
        'deleteClothTag',
        () {
          test(
            'should delete tag in cloth_tags box and '
            'delete tag id from clothes in clothes box',
            () async {
              final clothesList = [
                clothJsonWithoutId,
                secondClothJsonWithoutId,
              ];
              final modifiedJsonWithoutId = Map.of(clothJsonWithoutId);
              final tags = List.of(modifiedJsonWithoutId['tagsIds'] as List);
              tags.remove(tagModelId);
              modifiedJsonWithoutId['tagsIds'] = tags;

              when(() => mockClothesBox.length)
                  .thenAnswer((_) => clothesList.length);
              when(() => mockClothesBox.getAt(0))
                  .thenAnswer((_) => clothJsonWithoutId);
              when(() => mockClothesBox.getAt(1))
                  .thenAnswer((_) => secondClothJsonWithoutId);
              when(() => mockClothesBox.keyAt(0))
                  .thenAnswer((_) => clothModelId);
              when(() => mockClothesBox.keyAt(1))
                  .thenAnswer((_) => secondClothModelId);
              when(() => mockClothesBox.putAt(0, modifiedJsonWithoutId))
                  .thenAnswer((_) => Future.value(null));

              testDeletingModel(
                mockBox: mockClothTagsBox,
                modelId: tagModelId,
                actFunc: () =>
                    clothesLocalDataSource.deleteClothTag(tagModelId),
              );
              verify(() => mockClothesBox.length).called(1);
              verify(() => mockClothesBox.getAt(0)).called(1);
              verify(() => mockClothesBox.getAt(1)).called(1);
              verify(() => mockClothesBox.keyAt(0)).called(1);
              verify(() => mockClothesBox.keyAt(1)).called(1);
              verify(() => mockClothesBox.putAt(0, modifiedJsonWithoutId))
                  .called(1);
              verifyNoMoreInteractions(mockClothesBox);
            },
          );
        },
      );

      group(
        'getClothImages',
        () {
          test(
            'should return stream of list of images from cloth_images box',
            () async {
              testStream(
                mockBox: mockClothImagesBox,
                modelId: imageModelId,
                model: imageModel,
                jsonWithoutId: imageJsonWithoutId,
                secondModelId: secondImageModelId,
                secondModel: secondImageModel,
                secondJsonWithoutId: secondImageJsonWithoutId,
                actFunc: () => clothesLocalDataSource.getClothImages(),
              );
            },
          );
        },
      );

      group(
        'getClothImage',
        () {
          test(
            'should return ClothImageModel with given id',
            () async {
              testGettingModel(
                mockBox: mockClothImagesBox,
                modelId: imageModelId,
                model: imageModel,
                jsonWithoutId: imageJsonWithoutId,
                actFunc: () =>
                    clothesLocalDataSource.getClothImage(imageModelId),
              );
            },
          );
          test(
            'should throw ObjectNotFoundException when '
            'id not exists in the box',
            () async {
              testGettingUnknownModel(
                mockBox: mockClothImagesBox,
                modelId: imageModelId,
                actFunc: () =>
                    clothesLocalDataSource.getClothImage(imageModelId),
              );
            },
          );
        },
      );

      group(
        'createClothImage',
        () {
          test(
            'should create new image in cloth_images box and return id',
            () async {
              testCreatingModel(
                mockBox: mockClothImagesBox,
                modelId: imageModelId,
                jsonWithoutId: imageJsonWithoutId,
                actFunc: () =>
                    clothesLocalDataSource.createClothImage(imageModel),
              );
            },
          );
        },
      );

      group(
        'updateClothImage',
        () {
          test(
            'should update image in cloth_images box',
            () async {
              testUpdatingModel(
                mockBox: mockClothImagesBox,
                modelId: imageModelId,
                jsonWithoutId: imageJsonWithoutId,
                actFunc: () =>
                    clothesLocalDataSource.updateClothImage(imageModel),
              );
            },
          );
        },
      );

      group(
        'deleteClothImage',
        () {
          test(
            'should delete image in cloth_images box and '
            'delete image id from clothes in clothes box',
            () async {
              final clothesList = [
                clothJsonWithoutId,
                secondClothJsonWithoutId,
              ];
              final modifiedJsonWithoutId = Map.of(clothJsonWithoutId);
              final images =
                  List.of(modifiedJsonWithoutId['imagesIds'] as List);
              images.remove(imageModelId);
              modifiedJsonWithoutId['imagesIds'] = images;

              when(() => mockClothesBox.length)
                  .thenAnswer((_) => clothesList.length);
              when(() => mockClothesBox.getAt(0))
                  .thenAnswer((_) => clothJsonWithoutId);
              when(() => mockClothesBox.getAt(1))
                  .thenAnswer((_) => secondClothJsonWithoutId);
              when(() => mockClothesBox.keyAt(0))
                  .thenAnswer((_) => clothModelId);
              when(() => mockClothesBox.keyAt(1))
                  .thenAnswer((_) => secondClothModelId);
              when(() => mockClothesBox.putAt(0, modifiedJsonWithoutId))
                  .thenAnswer((_) => Future.value(null));

              testDeletingModel(
                mockBox: mockClothImagesBox,
                modelId: imageModelId,
                actFunc: () =>
                    clothesLocalDataSource.deleteClothImage(imageModelId),
              );
              verify(() => mockClothesBox.length).called(1);
              verify(() => mockClothesBox.getAt(0)).called(1);
              verify(() => mockClothesBox.getAt(1)).called(1);
              verify(() => mockClothesBox.keyAt(0)).called(1);
              verify(() => mockClothesBox.keyAt(1)).called(1);
              verify(() => mockClothesBox.putAt(0, modifiedJsonWithoutId))
                  .called(1);
              verifyNoMoreInteractions(mockClothesBox);
            },
          );
        },
      );

      group(
        'close',
        () {
          test(
            'should close all 3 boxes',
            () async {
              // arrange
              when(() => mockClothesBox.close())
                  .thenAnswer((_) => Future.value(null));
              when(() => mockClothTagsBox.close())
                  .thenAnswer((_) => Future.value(null));
              when(() => mockClothImagesBox.close())
                  .thenAnswer((_) => Future.value(null));
              // act
              await clothesLocalDataSource.close();
              // assert
              verify(() => mockClothesBox.close()).called(1);
              verify(() => mockClothTagsBox.close()).called(1);
              verify(() => mockClothImagesBox.close()).called(1);
              verifyNoMoreInteractions(mockClothesBox);
              verifyNoMoreInteractions(mockClothTagsBox);
              verifyNoMoreInteractions(mockClothImagesBox);
            },
          );
        },
      );
    },
  );
}
