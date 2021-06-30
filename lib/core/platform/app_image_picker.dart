import 'dart:typed_data';

import 'package:clothes/core/error/exceptions.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

abstract class BaseAppImagePicker {
  Future<Uint8List?> pickImage(ImageSource imageSource);

  Future<Uint8List?> retrieveLostData();
}

@LazySingleton(as: BaseAppImagePicker)
class AppImagePicker extends BaseAppImagePicker {
  final ImagePicker imagePicker;

  AppImagePicker({required this.imagePicker});

  @override
  Future<Uint8List?> pickImage(ImageSource imageSource) async {
    try {
      final pickedFile = await imagePicker.getImage(source: imageSource);
      return pickedFile?.readAsBytes();
    } on PlatformException {
      throw ImagePickerException();
    }
  }

  @override
  Future<Uint8List?> retrieveLostData() async {
    try {
      final lostData = await imagePicker.getLostData();
      return lostData.file?.readAsBytes();
    } on PlatformException {
      throw ImagePickerException();
    }
  }
}
