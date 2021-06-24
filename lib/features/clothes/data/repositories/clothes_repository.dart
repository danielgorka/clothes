import 'dart:async';
import 'dart:typed_data';

import 'package:clothes/core/error/exceptions.dart';
import 'package:clothes/core/error/failures.dart';
import 'package:clothes/features/clothes/data/data_sources/clothes_local_data_source.dart';
import 'package:clothes/features/clothes/data/data_sources/images/base_images_local_data_source.dart';
import 'package:clothes/features/clothes/data/models/cloth_image_model.dart';
import 'package:clothes/features/clothes/data/models/cloth_model.dart';
import 'package:clothes/features/clothes/data/models/cloth_tag_model.dart';
import 'package:clothes/features/clothes/domain/entities/cloth.dart';
import 'package:clothes/features/clothes/domain/entities/cloth_image.dart';
import 'package:clothes/features/clothes/domain/entities/cloth_tag.dart';
import 'package:clothes/features/clothes/domain/repositories/base_clothes_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: BaseClothesRepository)
class ClothesRepository extends BaseClothesRepository {
  final BaseClothesLocalDataSource clothesDataSource;
  final BaseImagesLocalDataSource imagesDataSource;

  ClothesRepository({
    required this.clothesDataSource,
    required this.imagesDataSource,
  });

  @override
  Stream<Either<Failure, List<Cloth>>> getClothes() {
    late StreamController<Either<Failure, List<Cloth>>> controller;
    StreamSubscription<List<ClothTagModel>>? tagsStreamSubscription;
    StreamSubscription<List<ClothImageModel>>? imagesStreamSubscription;
    StreamSubscription<List<ClothModel>>? clothesStreamSubscription;

    List<ClothModel>? clothes;
    List<ClothTag>? tags;
    List<ClothImage>? images;

    void emit() {
      if (tags != null && images != null && clothes != null) {
        controller.add(Right<Failure, List<Cloth>>(clothes!.map((clothModel) {
          return clothModel.toEntity(images: images!, tags: tags!);
        }).toList()));
      }
    }

    void onError(Object e) {
      if (controller.isClosed) {
        return;
      }
      if (e is ObjectNotFoundException) {
        controller.add(Left(ObjectNotFoundFailure()));
      } else {
        controller.add(Left(DatabaseFailure()));
      }
      controller.close();
    }

    void start() {
      try {
        final tagsStream = clothesDataSource.getClothTags();
        tagsStreamSubscription = tagsStream.listen(
          (tagsModels) {
            tags = tagsModels.map((tagModel) => tagModel.toEntity()).toList();
            emit();
          },
          onError: onError,
        );

        final imagesStream = clothesDataSource.getClothImages();
        imagesStreamSubscription = imagesStream.listen(
          (imagesModels) {
            images = imagesModels
                .map((imageModel) => imageModel.toEntity())
                .toList();
            emit();
          },
          onError: onError,
        );

        final clothesStream = clothesDataSource.getClothes();
        clothesStreamSubscription = clothesStream.listen(
          (clothesModels) {
            clothes = clothesModels;
            emit();
          },
          onError: onError,
        );
      } on ObjectNotFoundException catch (e) {
        onError(e);
      } on DatabaseException catch (e) {
        onError(e);
      }
    }

    void stop() {
      tagsStreamSubscription?.cancel();
      imagesStreamSubscription?.cancel();
      clothesStreamSubscription?.cancel();
    }

    controller = StreamController.broadcast(
      onListen: start,
      onCancel: stop,
    );

    return controller.stream;
  }

  @override
  Future<Either<Failure, Cloth>> getCloth(int id) async {
    try {
      final clothModel = await clothesDataSource.getCloth(id);

      final tags = <ClothTagModel>[];
      for (final tagId in clothModel.tagsIds) {
        tags.add(await clothesDataSource.getClothTag(tagId));
      }

      final images = <ClothImageModel>[];
      for (final imageId in clothModel.imagesIds) {
        images.add(await clothesDataSource.getClothImage(imageId));
      }

      return Right(
        clothModel.toEntity(
          images: images.map((image) => image.toEntity()).toList(),
          tags: tags.map((tag) => tag.toEntity()).toList(),
        ),
      );
    } on ObjectNotFoundException {
      return Left(ObjectNotFoundFailure());
    } on DatabaseException {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, int>> createCloth(Cloth cloth) async {
    try {
      final newId =
          await clothesDataSource.createCloth(ClothModel.fromEntity(cloth));
      return Right(newId);
    } on ObjectNotFoundException {
      return Left(ObjectNotFoundFailure());
    } on DatabaseException {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Failure?> updateCloth(Cloth cloth) async {
    try {
      await clothesDataSource.updateCloth(ClothModel.fromEntity(cloth));
    } on ObjectNotFoundException {
      return ObjectNotFoundFailure();
    } on DatabaseException {
      return DatabaseFailure();
    }
  }

  @override
  Future<Failure?> deleteCloth(int id) async {
    try {
      await clothesDataSource.deleteCloth(id);
    } on ObjectNotFoundException {
      return ObjectNotFoundFailure();
    } on DatabaseException {
      return DatabaseFailure();
    }
  }

  @override
  Future<Either<Failure, ClothImage>> addClothImage(
    int clothId,
    Uint8List image,
  ) async {
    try {
      final path = await imagesDataSource.saveImage(image);
      final imageId = await clothesDataSource.createClothImage(
        ClothImageModel(id: 0, path: path),
      );

      final cloth = await clothesDataSource.getCloth(clothId);
      final imagesIds = List.of(cloth.imagesIds) + [imageId];
      await clothesDataSource.updateCloth(cloth.copyWith(imagesIds: imagesIds));

      final clothImage = ClothImage(id: imageId, path: path);
      return Right(clothImage);
    } on LocalStorageException {
      return Left(LocalStorageFailure());
    } on ObjectNotFoundException {
      return Left(ObjectNotFoundFailure());
    } on DatabaseException {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Failure?> deleteClothImage(int id) async {
    try {
      final imageModel = await clothesDataSource.getClothImage(id);
      await clothesDataSource.deleteClothImage(id);
      await imagesDataSource.deleteImage(imageModel.path);

      final clothes = await clothesDataSource.getClothes().first;
      final clothModel =
          clothes.firstWhere((cloth) => cloth.imagesIds.contains(id));
      final imagesIds = List.of(clothModel.imagesIds);
      imagesIds.remove(id);
      await clothesDataSource.updateCloth(
        clothModel.copyWith(imagesIds: imagesIds),
      );
    } on LocalStorageException {
      return LocalStorageFailure();
    } on ObjectNotFoundException {
      return ObjectNotFoundFailure();
    } on DatabaseException {
      return DatabaseFailure();
    }
  }

  @override
  Future<Either<Failure, int>> createClothTag(ClothTag tag) async {
    try {
      final newId =
          await clothesDataSource.createClothTag(ClothTagModel.fromEntity(tag));
      return Right(newId);
    } on ObjectNotFoundException {
      return Left(ObjectNotFoundFailure());
    } on DatabaseException {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Failure?> updateClothTag(ClothTag tag) async {
    try {
      await clothesDataSource.updateClothTag(ClothTagModel.fromEntity(tag));
    } on ObjectNotFoundException {
      return ObjectNotFoundFailure();
    } on DatabaseException {
      return DatabaseFailure();
    }
  }

  @override
  Future<Failure?> deleteClothTag(int id) async {
    try {
      await clothesDataSource.deleteClothTag(id);
    } on ObjectNotFoundException {
      return ObjectNotFoundFailure();
    } on DatabaseException {
      return DatabaseFailure();
    }
  }
}
