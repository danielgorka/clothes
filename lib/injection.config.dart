// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:hive/hive.dart' as _i8;
import 'package:image_picker/image_picker.dart' as _i4;
import 'package:injectable/injectable.dart' as _i2;

import 'core/platform/app_image_picker.dart' as _i3;
import 'core/platform/app_platform.dart' as _i5;
import 'core/platform/path_provider.dart' as _i6;
import 'features/clothes/data/data_sources/clothes_local_data_source.dart'
    as _i10;
import 'features/clothes/data/data_sources/images/base_images_local_data_source.dart'
    as _i11;
import 'features/clothes/data/repositories/clothes_repository.dart' as _i13;
import 'features/clothes/domain/repositories/base_clothes_repository.dart'
    as _i12;
import 'features/clothes/domain/use_cases/add_cloth_image.dart' as _i23;
import 'features/clothes/domain/use_cases/create_cloth.dart' as _i14;
import 'features/clothes/domain/use_cases/create_cloth_tag.dart' as _i15;
import 'features/clothes/domain/use_cases/delete_cloth.dart' as _i16;
import 'features/clothes/domain/use_cases/delete_cloth_image.dart' as _i17;
import 'features/clothes/domain/use_cases/delete_cloth_tag.dart' as _i18;
import 'features/clothes/domain/use_cases/get_cloth.dart' as _i19;
import 'features/clothes/domain/use_cases/get_clothes.dart' as _i20;
import 'features/clothes/domain/use_cases/update_cloth.dart' as _i21;
import 'features/clothes/domain/use_cases/update_cloth_tag.dart' as _i22;
import 'features/clothes/presentation/blocs/clothes/clothes_bloc.dart' as _i24;
import 'features/clothes/presentation/blocs/edit_image/edit_image_bloc.dart'
    as _i7;
import 'injection.dart' as _i9; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  gh.lazySingleton<_i3.BaseAppImagePicker>(
      () => _i3.AppImagePicker(imagePicker: get<_i4.ImagePicker>()));
  gh.lazySingleton<_i5.BaseAppPlatform>(() => _i5.AppPlatform());
  gh.lazySingleton<_i6.BasePathProvider>(() => _i6.PathProvider());
  gh.factory<_i7.EditImageBloc>(
      () => _i7.EditImageBloc(appImagePicker: get<_i3.BaseAppImagePicker>()));
  gh.lazySingleton<_i8.HiveInterface>(() => registerModule.hive(),
      dispose: _i9.disposeHive);
  await gh.lazySingletonAsync<_i10.BaseClothesLocalDataSource>(
      () => _i10.ClothesLocalDataSource.init(
          hive: get<_i8.HiveInterface>(),
          pathProvider: get<_i6.BasePathProvider>(),
          appPlatform: get<_i5.BaseAppPlatform>()),
      preResolve: true,
      dispose: (i) => i.close());
  await gh.lazySingletonAsync<_i11.BaseImagesLocalDataSource>(
      () => registerModule.imagesLocalDataSource(
          get<_i6.BasePathProvider>(), get<_i5.BaseAppPlatform>()),
      preResolve: true);
  gh.lazySingleton<_i12.BaseClothesRepository>(() => _i13.ClothesRepository(
      clothesDataSource: get<_i10.BaseClothesLocalDataSource>(),
      imagesDataSource: get<_i11.BaseImagesLocalDataSource>()));
  gh.lazySingleton<_i14.CreateCloth>(
      () => _i14.CreateCloth(get<_i12.BaseClothesRepository>()));
  gh.lazySingleton<_i15.CreateClothTag>(
      () => _i15.CreateClothTag(get<_i12.BaseClothesRepository>()));
  gh.lazySingleton<_i16.DeleteCloth>(
      () => _i16.DeleteCloth(get<_i12.BaseClothesRepository>()));
  gh.lazySingleton<_i17.DeleteClothImage>(
      () => _i17.DeleteClothImage(get<_i12.BaseClothesRepository>()));
  gh.lazySingleton<_i18.DeleteClothTag>(
      () => _i18.DeleteClothTag(get<_i12.BaseClothesRepository>()));
  gh.lazySingleton<_i19.GetCloth>(
      () => _i19.GetCloth(get<_i12.BaseClothesRepository>()));
  gh.lazySingleton<_i20.GetClothes>(
      () => _i20.GetClothes(get<_i12.BaseClothesRepository>()));
  gh.lazySingleton<_i21.UpdateCloth>(
      () => _i21.UpdateCloth(get<_i12.BaseClothesRepository>()));
  gh.lazySingleton<_i22.UpdateClothTag>(
      () => _i22.UpdateClothTag(get<_i12.BaseClothesRepository>()));
  gh.lazySingleton<_i23.AddClothImage>(
      () => _i23.AddClothImage(get<_i12.BaseClothesRepository>()));
  gh.factory<_i24.ClothesBloc>(
      () => _i24.ClothesBloc(getClothes: get<_i20.GetClothes>()));
  return get;
}

class _$RegisterModule extends _i9.RegisterModule {}
