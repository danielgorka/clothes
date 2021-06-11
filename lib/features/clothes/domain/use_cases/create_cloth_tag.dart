import 'package:clothes/core/error/failures.dart';
import 'package:clothes/core/use_cases/use_case.dart';
import 'package:clothes/features/clothes/domain/entities/cloth_tag.dart';
import 'package:clothes/features/clothes/domain/repositories/base_clothes_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class CreateClothTag extends UseCase<int, CreateClothTagParams> {
  final BaseClothesRepository repository;

  CreateClothTag(this.repository);

  @override
  Future<Either<Failure, int>> call(CreateClothTagParams params) {
    return repository.createClothTag(params.tag);
  }
}

class CreateClothTagParams extends Equatable {
  final ClothTag tag;

  const CreateClothTagParams({
    required this.tag,
  });

  @override
  List<Object?> get props => [tag];
}
