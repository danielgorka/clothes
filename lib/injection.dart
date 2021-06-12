import 'package:clothes/core/platform/path_provider.dart';
import 'package:clothes/features/clothes/data/data_sources/images/base_images_local_data_source.dart';
import 'package:clothes/features/clothes/data/data_sources/images/images_local_data_source.dart';
import 'package:clothes/features/clothes/data/data_sources/images/images_local_data_source_web.dart';
import 'package:clothes/injection.config.dart';
import 'package:file/local.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() => $initGetIt(getIt);

@module
abstract class RegisterModule {
  @LazySingleton(dispose: disposeHive)
  HiveInterface hive() => Hive;

  @preResolve
  @LazySingleton()
  Future<BaseImagesLocalDataSource> imagesLocalDataSource(
    BasePathProvider pathProvider,
  ) async {
    if (kIsWeb) {
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
