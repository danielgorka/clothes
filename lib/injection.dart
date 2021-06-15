import 'package:clothes/core/platform/app_platform.dart';
import 'package:clothes/core/platform/path_provider.dart';
import 'package:clothes/features/clothes/data/data_sources/images/base_images_local_data_source.dart';
import 'package:clothes/features/clothes/data/data_sources/images/images_local_data_source.dart';
import 'package:clothes/features/clothes/data/data_sources/images/images_local_data_source_web.dart';
import 'package:clothes/injection.config.dart';
import 'package:file/local.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

typedef InitGetItFunction = Future<void> Function(GetIt getIt);
late final GetIt getIt;

@InjectableInit()
Future<void> configureDependencies({
  GetIt? get,
  InitGetItFunction initGetIt = $initGetIt,
}) {
  getIt = get ?? GetIt.instance;
  return initGetIt(getIt);
}

@module
abstract class RegisterModule {
  @LazySingleton(dispose: disposeHive)
  HiveInterface hive() => Hive;

  @preResolve
  @LazySingleton()
  Future<BaseImagesLocalDataSource> imagesLocalDataSource(
    BasePathProvider pathProvider,
    BaseAppPlatform appPlatform,
  ) async {
    if (appPlatform.isWeb) {
      return ImagesLocalDataSourceWeb();
    } else {
      return ImagesLocalDataSource.init(
        fileSystem: const LocalFileSystem(),
        pathProvider: pathProvider,
      );
    }
  }
}

Future<void> disposeHive(HiveInterface hive) {
  return hive.close();
}
