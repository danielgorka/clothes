import 'dart:typed_data';

import 'package:clothes/core/error/failures.dart';
import 'package:clothes/core/use_cases/use_case.dart';
import 'package:clothes/features/clothes/domain/entities/cloth_image.dart';
import 'package:clothes/features/clothes/domain/repositories/clothes_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class AddClothImage extends UseCase<ClothImage, AddClothImageParams> {
  final BaseClothesRepository repository;

  AddClothImage(this.repository);

  @override
  Future<Either<Failure, ClothImage>> call(AddClothImageParams params) {
    return repository.addClothImage(params.clothId, params.image);
  }
}

class AddClothImageParams extends Equatable {
  final int clothId;
  final Uint8List image;

  const AddClothImageParams({
    required this.clothId,
    required this.image,
  });

  @override
  List<Object?> get props => [clothId, image];
}
