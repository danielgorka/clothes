
import 'package:path_provider/path_provider.dart';

abstract class BasePathProvider {
  Future<String> getAppPath();
}

class PathProvider extends BasePathProvider {
  @override
  Future<String> getAppPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }
}
