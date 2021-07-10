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

class UpdateClothName extends EditClothEvent {
  final String name;

  const UpdateClothName({required this.name});

  @override
  List<Object?> get props => [name];
}

class UpdateClothDescription extends EditClothEvent {
  final String description;

  const UpdateClothDescription({required this.description});

  @override
  List<Object?> get props => [description];
}

class AddTagToCloth extends EditClothEvent {
  final ClothTag tag;

  const AddTagToCloth({required this.tag});

  @override
  List<Object?> get props => [tag];
}

class RemoveTagFromCloth extends EditClothEvent {
  final int tagId;

  const RemoveTagFromCloth({required this.tagId});

  @override
  List<Object?> get props => [tagId];
}

class EditCloth extends EditClothEvent {}

class SaveCloth extends EditClothEvent {}

class ClearError extends EditClothEvent {}

class ClearAction extends EditClothEvent {}

class CloseCloth extends EditClothEvent {}
