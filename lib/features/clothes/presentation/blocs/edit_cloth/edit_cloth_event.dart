part of 'edit_cloth_bloc.dart';

abstract class EditClothEvent extends Equatable {
  const EditClothEvent();

  @override
  List<Object?> get props => [];
}

class SetCloth extends EditClothEvent {
  final int clothId;

  const SetCloth({required this.clothId});

  @override
  List<Object?> get props => [clothId];
}

class ChangeFavourite extends EditClothEvent {
  final bool favourite;

  const ChangeFavourite({required this.favourite});

  @override
  List<Object?> get props => [favourite];
}

class ClearError extends EditClothEvent {}

class ClearAction extends EditClothEvent {}

class CloseCloth extends EditClothEvent {}
