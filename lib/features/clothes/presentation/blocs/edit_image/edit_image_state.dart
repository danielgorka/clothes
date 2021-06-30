part of 'edit_image_bloc.dart';

enum EditImageStatus {
  picking,
  editing,
  cropping,
  completed,
  canceled,
}

class EditImageState extends Equatable {
  final EditImageStatus status;
  final Uint8List? image;

  const EditImageState({
    this.status = EditImageStatus.picking,
    this.image,
  });

  EditImageState copyWith({
    EditImageStatus? status,
    Uint8List? image,
  }) {
    return EditImageState(
      status: status ?? this.status,
      image: image ?? this.image,
    );
  }

  bool get isComputing => status == EditImageStatus.cropping;

  @override
  List<Object?> get props => [status, image];
}
