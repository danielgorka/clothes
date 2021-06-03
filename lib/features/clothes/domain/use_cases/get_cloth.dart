import 'package:clothes/core/error/failures.dart';
import 'package:clothes/core/use_cases/use_case.dart';
import 'package:clothes/features/clothes/domain/entities/cloth.dart';
import 'package:clothes/features/clothes/domain/repositories/clothes_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class GetCloth extends UseCase<Cloth, GetClothParams> {
  final BaseClothesRepository repository;

  GetCloth(this.repository);

  @override
  Future<Either<Failure, Cloth>> call(GetClothParams params) {
    return repository.getCloth(params.id);
  }
}

class GetClothParams extends Equatable {
  final int id;

  const GetClothParams({required this.id});

  @override
  List<Object?> get props => [id];
}
