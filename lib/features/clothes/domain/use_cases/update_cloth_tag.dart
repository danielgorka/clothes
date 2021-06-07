import 'package:clothes/core/error/failures.dart';
import 'package:clothes/core/use_cases/void_use_case.dart';
import 'package:clothes/features/clothes/domain/entities/cloth_tag.dart';
import 'package:clothes/features/clothes/domain/repositories/base_clothes_repository.dart';
import 'package:equatable/equatable.dart';

class UpdateClothTag extends VoidUseCase<UpdateClothTagParams> {
  final BaseClothesRepository repository;

  UpdateClothTag(this.repository);

  @override
  Future<Failure?> call(UpdateClothTagParams params) {
    return repository.updateClothTag(params.tag);
  }
}

class UpdateClothTagParams extends Equatable {
  final ClothTag tag;

  const UpdateClothTagParams({required this.tag});

  @override
  List<Object?> get props => [tag];
}
