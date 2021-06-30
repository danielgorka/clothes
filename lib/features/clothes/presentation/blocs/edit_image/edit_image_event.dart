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

class CompleteCroppingImage extends EditImageEvent {
  final Uint8List croppedImage;

  const CompleteCroppingImage({required this.croppedImage});

  @override
  List<Object?> get props => [croppedImage];
}
