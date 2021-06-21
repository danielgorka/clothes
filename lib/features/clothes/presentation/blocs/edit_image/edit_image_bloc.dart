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
    } else if (event is CancelEditingImage) {
      yield* _mapCancelEditingImageToState(event);
    } else if (event is CompleteEditingImage) {
      yield* _mapCompleteEditingImageToState(event);
    }
  }

  Stream<EditImageState> _mapPickImageToState(PickImage event) async* {
    yield state.copyWith(status: EditImageStatus.picking);
    // When picking image is canceled in the browser
    // the future will not complete.
    // By omitting await, we do not freeze the bloc stream.
    final pickFuture = appImagePicker.pickImage(
      _mapImageSource(event.imagePickerSource),
    );
    pickFuture.then((image) {
      if (image == null) {
        emit(state.copyWith(status: EditImageStatus.canceled));
      } else {
        emit(state.copyWith(
          status: EditImageStatus.editing,
          image: image,
        ));
      }
    });
  }

  Stream<EditImageState> _mapCancelEditingImageToState(
    CancelEditingImage event,
  ) async* {
    yield state.copyWith(status: EditImageStatus.canceled);
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
