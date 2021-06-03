import 'package:clothes/core/error/failures.dart';
import 'package:clothes/core/use_cases/use_case.dart';
import 'package:clothes/features/clothes/domain/entities/cloth_tag.dart';
import 'package:clothes/features/clothes/domain/repositories/clothes_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class CreateClothTag extends UseCase<ClothTag, CreateClothTagParams> {
  final BaseClothesRepository repository;

  CreateClothTag(this.repository);

  @override
  Future<Either<Failure, ClothTag>> call(CreateClothTagParams params) {
    return repository.createClothTag(params.type, params.name);
  }
}

class CreateClothTagParams extends Equatable {
  final ClothTagType type;
  final String name;

  const CreateClothTagParams({
    required this.type,
    required this.name,
  });

  @override
  List<Object?> get props => [type, name];
}
