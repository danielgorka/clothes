import 'package:clothes/core/error/failures.dart';
import 'package:clothes/core/use_cases/void_use_case.dart';
import 'package:clothes/features/clothes/domain/repositories/base_clothes_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class DeleteCloth extends VoidUseCase<DeleteClothParams> {
  final BaseClothesRepository repository;

  DeleteCloth(this.repository);

  @override
  Future<Failure?> call(DeleteClothParams params) {
    return repository.deleteCloth(params.id);
  }
}

class DeleteClothParams extends Equatable {
  final int id;

  const DeleteClothParams({required this.id});

  @override
  List<Object?> get props => [id];
}
