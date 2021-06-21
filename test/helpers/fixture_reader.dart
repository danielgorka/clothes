import 'dart:io';
import 'dart:typed_data';

Uint8List readAsBytes(String name) =>
    File('test/fixtures/$name').readAsBytesSync();
