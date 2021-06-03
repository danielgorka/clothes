import 'package:clothes/core/error/failures.dart';
import 'package:dartz/dartz.dart';

abstract class StreamUseCase<Type, Params> {
  Stream<Either<Failure, Type>> call(Params params);
}
