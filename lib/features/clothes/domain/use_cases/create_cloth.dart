import 'package:clothes/core/error/failures.dart';
import 'package:clothes/core/use_cases/use_case.dart';
import 'package:clothes/features/clothes/domain/entities/cloth.dart';
import 'package:clothes/features/clothes/domain/repositories/base_clothes_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class CreateCloth extends UseCase<int, CreateClothParams> {
  final BaseClothesRepository repository;

  CreateCloth(this.repository);

  @override
  Future<Either<Failure, int>> call(CreateClothParams params) {
    return repository.createCloth(params.cloth);
  }
}

class CreateClothParams extends Equatable {
  final Cloth cloth;

  const CreateClothParams({required this.cloth});

  @override
  List<Object?> get props => [cloth];
}
