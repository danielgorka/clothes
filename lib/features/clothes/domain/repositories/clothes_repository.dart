import 'dart:typed_data';

import 'package:clothes/core/error/failures.dart';
import 'package:clothes/features/clothes/domain/entities/cloth.dart';
import 'package:clothes/features/clothes/domain/entities/cloth_image.dart';
import 'package:clothes/features/clothes/domain/entities/cloth_tag.dart';
import 'package:dartz/dartz.dart';

abstract class BaseClothesRepository {
  Stream<Either<Failure, List<Cloth>>> getClothes();

  Future<Either<Failure, Cloth>> getCloth(int id);

  Future<Either<Failure, int>> createCloth();

  Future<Failure?> updateCloth(Cloth cloth);

  Future<Failure?> deleteCloth(int id);

  Future<Either<Failure, ClothImage>> addClothImage(
      int clothId, Uint8List image);

  Future<Failure?> removeClothImage(int id);

  Future<Either<Failure, ClothTag>> createClothTag(
      ClothTagType type, String name);

  Future<Failure?> updateClothTag(ClothTag tag);

  Future<Failure?> removeClothTag(int id);
}
