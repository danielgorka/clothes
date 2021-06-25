import 'package:clothes/core/error/exceptions.dart';
import 'package:clothes/core/platform/app_platform.dart';
import 'package:clothes/core/platform/path_provider.dart';
import 'package:clothes/features/clothes/data/models/cloth_image_model.dart';
import 'package:clothes/features/clothes/data/models/cloth_model.dart';
import 'package:clothes/features/clothes/data/models/cloth_tag_model.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

abstract class BaseClothesLocalDataSource {
  Stream<List<ClothModel>> getClothes();

  Future<ClothModel> getCloth(int id);

  Future<int> createCloth(ClothModel cloth);

  Future<void> updateCloth(ClothModel cloth);

  Future<void> deleteCloth(int id);

  Stream<List<ClothTagModel>> getClothTags();

  Future<ClothTagModel> getClothTag(int id);

  Future<int> createClothTag(ClothTagModel tag);

  Future<void> updateClothTag(ClothTagModel tag);

  Future<void> deleteClothTag(int id);

  Stream<List<ClothImageModel>> getClothImages();

  Future<ClothImageModel> getClothImage(int id);

  Future<int> createClothImage(ClothImageModel image);

  Future<void> updateClothImage(ClothImageModel image);

  Future<void> deleteClothImage(int id);

  Future<void> close();
}

typedef _JsonMapper<T> = T Function(Map<String, dynamic> json);

typedef _IdMatcher<T> = bool Function(T model, int id);

@preResolve
@LazySingleton(as: BaseClothesLocalDataSource)
class ClothesLocalDataSource extends BaseClothesLocalDataSource {
  static const clothesBoxName = 'clothes';
  static const clothTagsBoxName = 'cloth_tags';
  static const clothImagesBoxName = 'cloth_images';

  final Box clothesBox;
  final Box clothTagsBox;
  final Box clothImagesBox;

  @visibleForTesting
  ClothesLocalDataSource({
    required this.clothesBox,
    required this.clothTagsBox,
    required this.clothImagesBox,
  });

  @factoryMethod
  static Future<ClothesLocalDataSource> init({
    required HiveInterface hive,
    required BasePathProvider pathProvider,
    required BaseAppPlatform appPlatform,
  }) async {
    if (!appPlatform.isWeb) {
      final appPath = await pathProvider.getAppPath();
      hive.init(appPath);
    }

    final clothesBox = await hive.openBox(clothesBoxName);
    final clothTagsBox = await hive.openBox(clothTagsBoxName);
    final clothImagesBox = await hive.openBox(clothImagesBoxName);

    return ClothesLocalDataSource(
      clothesBox: clothesBox,
      clothTagsBox: clothTagsBox,
      clothImagesBox: clothImagesBox,
    );
  }

  @override
  Stream<List<ClothModel>> getClothes() async* {
    yield* _getStream(
      box: clothesBox,
      fromJson: (json) => ClothModel.fromJson(json),
      idMatcher: (clothModel, id) => clothModel.id == id,
    );
  }

  @override
  Future<ClothModel> getCloth(int id) async {
    return _getModel(
      id: id,
      box: clothesBox,
      fromJson: (json) => ClothModel.fromJson(json),
    );
  }

  @override
  Future<int> createCloth(ClothModel cloth) async {
    return _createModel(box: clothesBox, json: cloth.toJson());
  }

  @override
  Future<void> updateCloth(ClothModel cloth) async {
    await _updateModel(
      box: clothesBox,
      json: cloth.toJson(),
    );
  }

  @override
  Future<void> deleteCloth(int id) async {
    await clothesBox.delete(id);
  }

  @override
  Stream<List<ClothTagModel>> getClothTags() async* {
    yield* _getStream(
      box: clothTagsBox,
      fromJson: (json) => ClothTagModel.fromJson(json),
      idMatcher: (tagModel, id) => tagModel.id == id,
    );
  }

  @override
  Future<ClothTagModel> getClothTag(int id) async {
    return _getModel(
      id: id,
      box: clothTagsBox,
      fromJson: (json) => ClothTagModel.fromJson(json),
    );
  }

  @override
  Future<int> createClothTag(ClothTagModel tag) async {
    return _createModel(box: clothTagsBox, json: tag.toJson());
  }

  @override
  Future<void> updateClothTag(ClothTagModel tag) async {
    await _updateModel(
      box: clothTagsBox,
      json: tag.toJson(),
    );
  }

  @override
  Future<void> deleteClothTag(int id) async {
    final length = clothesBox.length;
    for (int i = 0; i < length; i++) {
      final json = _getAt(clothesBox, i);
      final cloth = ClothModel.fromJson(json);

      if (cloth.tagsIds.contains(id)) {
        final tagsIds = List.of(cloth.tagsIds);
        tagsIds.remove(id);
        final newCloth = cloth.copyWith(tagsIds: tagsIds);
        _putAt(clothesBox, i, newCloth.toJson());
      }
    }
    await clothTagsBox.delete(id);
  }

  @override
  Stream<List<ClothImageModel>> getClothImages() async* {
    yield* _getStream(
      box: clothImagesBox,
      fromJson: (json) => ClothImageModel.fromJson(json),
      idMatcher: (imageModel, id) => imageModel.id == id,
    );
  }

  @override
  Future<ClothImageModel> getClothImage(int id) async {
    return _getModel(
      box: clothImagesBox,
      id: id,
      fromJson: (json) => ClothImageModel.fromJson(json),
    );
  }

  @override
  Future<int> createClothImage(ClothImageModel image) async {
    return _createModel(box: clothImagesBox, json: image.toJson());
  }

  @override
  Future<void> updateClothImage(ClothImageModel image) async {
    await _updateModel(
      box: clothImagesBox,
      json: image.toJson(),
    );
  }

  @override
  Future<void> deleteClothImage(int id) async {
    final length = clothesBox.length;
    for (int i = 0; i < length; i++) {
      final json = _getAt(clothesBox, i);
      final cloth = ClothModel.fromJson(json);
      if (cloth.imagesIds.contains(id)) {
        final imagesIds = List.of(cloth.imagesIds);
        imagesIds.remove(id);
        final newCloth = cloth.copyWith(imagesIds: imagesIds);
        _putAt(clothesBox, i, newCloth.toJson());
      }
    }
    await clothImagesBox.delete(id);
  }

  @disposeMethod
  @override
  Future<void> close() async {
    await clothesBox.close();
    await clothTagsBox.close();
    await clothImagesBox.close();
  }

  Stream<List<T>> _getStream<T>({
    required Box box,
    required _JsonMapper<T> fromJson,
    required _IdMatcher<T> idMatcher,
  }) async* {
    final length = box.length;
    final list = <T>[];
    for (int i = 0; i < length; i++) {
      final json = _getAt(box, i);
      list.add(fromJson(json));
    }
    yield List.of(list);

    yield* box.watch().map((event) {
      if (event.deleted) {
        list.removeWhere((model) => idMatcher(model, event.key as int));
      } else {
        final json = _jsonWithId(
          event.value as Map<String, dynamic>,
          event.key as int,
        );

        final index =
            list.indexWhere((model) => idMatcher(model, event.key as int));
        if (index == -1) {
          list.add(fromJson(json));
        } else {
          list[index] = fromJson(json);
        }
      }
      return List.of(list);
    });
  }

  T _getModel<T>({
    required Box box,
    required int id,
    required _JsonMapper<T> fromJson,
  }) {
    final element = box.get(id);
    if (element == null) {
      throw ObjectNotFoundException();
    }

    final json = _jsonWithId(element as Map<String, dynamic>, id);
    return fromJson(json);
  }

  Future<int> _createModel({
    required Box box,
    required Map<String, dynamic> json,
  }) {
    return box.add(_jsonWithoutId(json));
  }

  Future<void> _updateModel({
    required Box box,
    required Map<String, dynamic> json,
  }) {
    final id = json['id'] as int;
    return box.put(id, _jsonWithoutId(json));
  }

  Map<String, dynamic> _getAt(Box box, int index) {
    return _jsonWithId(
      Map<String, dynamic>.from(box.getAt(index) as Map),
      box.keyAt(index) as int,
    );
  }

  Future<void> _putAt(Box box, int index, Map<String, dynamic> json) {
    return box.putAt(index, _jsonWithoutId(json));
  }

  Map<String, dynamic> _jsonWithId(Map<String, dynamic> json, int id) {
    final newJson = Map.of(json);
    newJson['id'] = id;
    return newJson;
  }

  Map<String, dynamic> _jsonWithoutId(Map<String, dynamic> json) {
    final newJson = Map.of(json);
    newJson.remove('id');
    return newJson;
  }
}
