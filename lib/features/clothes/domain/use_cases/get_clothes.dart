import 'package:clothes/core/error/failures.dart';
import 'package:clothes/core/use_cases/no_params.dart';
import 'package:clothes/core/use_cases/stream_use_case.dart';
import 'package:clothes/features/clothes/domain/entities/cloth.dart';
import 'package:clothes/features/clothes/domain/repositories/clothes_repository.dart';
import 'package:dartz/dartz.dart';

class GetClothes implements StreamUseCase<List<Cloth>, NoParams> {
  final BaseClothesRepository repository;

  GetClothes(this.repository);

  @override
  Stream<Either<Failure, List<Cloth>>> call(NoParams? params) async* {
    yield* repository.getClothes();
  }
}
