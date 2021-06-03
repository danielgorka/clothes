import 'package:clothes/core/error/failures.dart';

abstract class VoidUseCase<Params> {
  Future<Failure?> call(Params params);
}
