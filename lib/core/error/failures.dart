import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure();

  @override
  List<Object?> get props => [];
}

class DatabaseFailure extends Failure {}

class ObjectNotFoundFailure extends DatabaseFailure {}

class LocalStorageFailure extends Failure {}
