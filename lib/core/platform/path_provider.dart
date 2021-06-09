import 'dart:io';

import 'package:path_provider/path_provider.dart';

abstract class BasePathProvider {
  Future<Directory> getAppPath();
}

class PathProvider extends BasePathProvider {
  @override
  Future<Directory> getAppPath() => getApplicationDocumentsDirectory();
}
