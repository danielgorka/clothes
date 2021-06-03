import 'package:clothes/core/error/failures.dart';
import 'package:clothes/core/use_cases/void_use_case.dart';
import 'package:clothes/features/clothes/domain/entities/cloth.dart';
import 'package:clothes/features/clothes/domain/repositories/clothes_repository.dart';
import 'package:equatable/equatable.dart';

class UpdateCloth extends VoidUseCase<UpdateClothParams> {
  final BaseClothesRepository repository;

  UpdateCloth(this.repository);

  @override
  Future<Failure?> call(UpdateClothParams params) {
    return repository.updateCloth(params.cloth);
  }
}

class UpdateClothParams extends Equatable {
  final Cloth cloth;

  const UpdateClothParams({required this.cloth});

  @override
  List<Object?> get props => [cloth];
}
