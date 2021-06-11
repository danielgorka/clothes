import 'package:clothes/core/error/failures.dart';
import 'package:clothes/core/use_cases/void_use_case.dart';
import 'package:clothes/features/clothes/domain/repositories/base_clothes_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class DeleteClothImage extends VoidUseCase<DeleteClothImageParams> {
  final BaseClothesRepository repository;

  DeleteClothImage(this.repository);

  @override
  Future<Failure?> call(DeleteClothImageParams params) {
    return repository.deleteClothImage(params.id);
  }
}

class DeleteClothImageParams extends Equatable {
  final int id;

  const DeleteClothImageParams({required this.id});

  @override
  List<Object?> get props => [id];
}
