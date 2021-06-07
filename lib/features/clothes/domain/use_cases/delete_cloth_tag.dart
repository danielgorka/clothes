import 'package:clothes/core/error/failures.dart';
import 'package:clothes/core/use_cases/void_use_case.dart';
import 'package:clothes/features/clothes/domain/repositories/base_clothes_repository.dart';
import 'package:equatable/equatable.dart';

class DeleteClothTag extends VoidUseCase<DeleteClothTagParams> {
  final BaseClothesRepository repository;

  DeleteClothTag(this.repository);

  @override
  Future<Failure?> call(DeleteClothTagParams params) {
    return repository.deleteClothTag(params.id);
  }
}

class DeleteClothTagParams extends Equatable {
  final int id;

  const DeleteClothTagParams({required this.id});

  @override
  List<Object?> get props => [id];
}
