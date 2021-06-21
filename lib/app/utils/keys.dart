import 'package:flutter/material.dart';

abstract class Keys {
  static const systemUiOverlayAnnotatedRegion =
      Key('system_ui_overlay_annotated_region');

  static const clothesNavbarIcon = Key('clothes_navbar_icon');
  static const outfitsNavbarIcon = Key('outfits_navbar_icon');
  static const calendarNavbarIcon = Key('calendar_navbar_icon');

  static const navigationScaffold = Key('navigation_scaffold');
  static const navigationScaffoldBody = Key('navigation_scaffold_body');

  static const editImageCancelButton = Key('edit_image_cancel_button');
  static const editImageSaveButton = Key('edit_image_save_button');
}
