import 'package:clothes/app/display_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension DisplaySizeWidgetTester on WidgetTester {
  void setDisplaySize(Size size) {
    binding.window.physicalSizeTestValue = size;
    binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      binding.window.clearPhysicalSizeTestValue();
      binding.window.clearDevicePixelRatioTestValue();
    });
  }

  void setLargeDisplaySize() {
    setDisplaySize(const Size(DisplaySizes.large, 1000));
  }

  void setMediumDisplaySize() {
    setDisplaySize(const Size(DisplaySizes.medium, 1000));
  }

  void setSmallDisplaySize() {
    setDisplaySize(const Size(DisplaySizes.small - 1, 1000));
  }
}
