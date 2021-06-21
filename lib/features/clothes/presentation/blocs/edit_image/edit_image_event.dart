part of 'edit_image_bloc.dart';

abstract class EditImageEvent extends Equatable {
  const EditImageEvent();

  @override
  List<Object?> get props => [];
}

enum ImagePickerSource {
  camera,
  gallery,
}

class PickImage extends EditImageEvent {
  final ImagePickerSource imagePickerSource;

  const PickImage({required this.imagePickerSource});

  @override
  List<Object?> get props => [imagePickerSource];
}

class CancelEditingImage extends EditImageEvent {}

class CompleteEditingImage extends EditImageEvent {}
