part of 'clothes_bloc.dart';

abstract class ClothesEvent extends Equatable {
  const ClothesEvent();

  @override
  List<Object?> get props => [];
}

class LoadClothes extends ClothesEvent {}

class ShowCloth extends ClothesEvent {
  final int clothId;

  const ShowCloth({required this.clothId});

  @override
  List<Object?> get props => [clothId];
}

class PickImage extends ClothesEvent {
  final ImagePickerSource source;

  const PickImage({required this.source});

  @override
  List<Object?> get props => [source];
}

class ImagePicked extends ClothesEvent {
  final Uint8List image;

  const ImagePicked({required this.image});

  @override
  List<Object?> get props => [image];
}

class CreateEmptyCloth extends ClothesEvent {}

class CancelAction extends ClothesEvent {}
