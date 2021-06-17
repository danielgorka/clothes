import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:clothes/core/platform/app_image_picker.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

part 'edit_image_event.dart';
part 'edit_image_state.dart';

@injectable
class EditImageBloc extends Bloc<EditImageEvent, EditImageState> {
  final BaseAppImagePicker appImagePicker;

  EditImageBloc({
    required this.appImagePicker,
  }) : super(const EditImageState());

  @override
  Stream<EditImageState> mapEventToState(EditImageEvent event) async* {
    if (event is PickImage) {
      yield* _mapPickImageToState(event);
    } else if (event is CompleteEditingImage) {
      yield* _mapCompleteEditingImageToState(event);
    }
  }

  Stream<EditImageState> _mapPickImageToState(PickImage event) async* {
    yield state.copyWith(status: EditImageStatus.picking);
    final image = await appImagePicker.pickImage(
      _mapImageSource(event.imagePickerSource),
    );
    if (image == null) {
      yield state.copyWith(status: EditImageStatus.canceled);
    } else {
      yield state.copyWith(
        status: EditImageStatus.editing,
        image: image,
      );
    }
  }

  Stream<EditImageState> _mapCompleteEditingImageToState(
    CompleteEditingImage event,
  ) async* {
    yield state.copyWith(status: EditImageStatus.completed);
  }

  ImageSource _mapImageSource(ImagePickerSource imagePickerSource) {
    switch (imagePickerSource) {
      case ImagePickerSource.camera:
        return ImageSource.camera;
      case ImagePickerSource.gallery:
        return ImageSource.gallery;
    }
  }
}
