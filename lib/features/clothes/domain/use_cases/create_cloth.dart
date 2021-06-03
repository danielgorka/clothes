import 'package:clothes/core/error/failures.dart';
import 'package:clothes/core/use_cases/no_params.dart';
import 'package:clothes/core/use_cases/use_case.dart';
import 'package:clothes/features/clothes/domain/repositories/clothes_repository.dart';
import 'package:dartz/dartz.dart';

class CreateCloth extends UseCase<int, NoParams> {
  final BaseClothesRepository repository;

  CreateCloth(this.repository);

  @override
  Future<Either<Failure, int>> call(NoParams params) {
    return repository.createCloth();
  }
}
