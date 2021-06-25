import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

abstract class BaseAppPlatform {
  bool get isWeb;
}

@LazySingleton(as: BaseAppPlatform)
class AppPlatform extends BaseAppPlatform {
  @override
  bool get isWeb => kIsWeb;
}
