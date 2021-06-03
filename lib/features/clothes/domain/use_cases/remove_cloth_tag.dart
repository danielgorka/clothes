import 'package:clothes/core/error/failures.dart';
import 'package:clothes/core/use_cases/void_use_case.dart';
import 'package:clothes/features/clothes/domain/repositories/clothes_repository.dart';
import 'package:equatable/equatable.dart';

class RemoveClothTag extends VoidUseCase<RemoveClothTagParams> {
  final BaseClothesRepository repository;

  RemoveClothTag(this.repository);

  @override
  Future<Failure?> call(RemoveClothTagParams params) {
    return repository.removeClothTag(params.id);
  }
}

class RemoveClothTagParams extends Equatable {
  final int id;

  const RemoveClothTagParams({required this.id});

  @override
  List<Object?> get props => [id];
}
