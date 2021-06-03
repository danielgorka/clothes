import 'package:clothes/core/error/failures.dart';
import 'package:clothes/core/use_cases/void_use_case.dart';
import 'package:clothes/features/clothes/domain/repositories/clothes_repository.dart';
import 'package:equatable/equatable.dart';

class RemoveClothImage extends VoidUseCase<RemoveClothImageParams> {
  final BaseClothesRepository repository;

  RemoveClothImage(this.repository);

  @override
  Future<Failure?> call(RemoveClothImageParams params) {
    return repository.removeClothImage(params.id);
  }
}

class RemoveClothImageParams extends Equatable {
  final int id;

  const RemoveClothImageParams({required this.id});

  @override
  List<Object?> get props => [id];
}
