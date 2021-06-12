// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:hive/hive.dart' as _i4;
import 'package:injectable/injectable.dart' as _i2;

import 'core/platform/path_provider.dart' as _i3;
import 'features/clothes/data/data_sources/clothes_local_data_source.dart'
    as _i6;
import 'features/clothes/data/data_sources/images/base_images_local_data_source.dart'
    as _i7;
import 'features/clothes/data/repositories/clothes_repository.dart' as _i9;
import 'features/clothes/domain/repositories/base_clothes_repository.dart'
    as _i8;
import 'features/clothes/domain/use_cases/add_cloth_image.dart' as _i19;
import 'features/clothes/domain/use_cases/create_cloth.dart' as _i10;
import 'features/clothes/domain/use_cases/create_cloth_tag.dart' as _i11;
import 'features/clothes/domain/use_cases/delete_cloth.dart' as _i12;
import 'features/clothes/domain/use_cases/delete_cloth_image.dart' as _i13;
import 'features/clothes/domain/use_cases/delete_cloth_tag.dart' as _i14;
import 'features/clothes/domain/use_cases/get_cloth.dart' as _i15;
import 'features/clothes/domain/use_cases/get_clothes.dart' as _i16;
import 'features/clothes/domain/use_cases/update_cloth.dart' as _i17;
import 'features/clothes/domain/use_cases/update_cloth_tag.dart' as _i18;
import 'features/clothes/presentation/blocs/clothes/clothes_bloc.dart' as _i20;
import 'injection.dart' as _i5; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  gh.lazySingleton<_i3.BasePathProvider>(() => _i3.PathProvider());
  gh.lazySingleton<_i4.HiveInterface>(() => registerModule.hive(),
      dispose: _i5.disposeHive);
  await gh.lazySingletonAsync<_i6.BaseClothesLocalDataSource>(
      () => _i6.ClothesLocalDataSource.init(
          hive: get<_i4.HiveInterface>(),
          pathProvider: get<_i3.BasePathProvider>()),
      preResolve: true,
      dispose: (i) => i.close());
  await gh.lazySingletonAsync<_i7.BaseImagesLocalDataSource>(
      () => registerModule.imagesLocalDataSource(get<_i3.BasePathProvider>()),
      preResolve: true);
  gh.lazySingleton<_i8.BaseClothesRepository>(() => _i9.ClothesRepository(
      clothesDataSource: get<_i6.BaseClothesLocalDataSource>(),
      imagesDataSource: get<_i7.BaseImagesLocalDataSource>()));
  gh.lazySingleton<_i10.CreateCloth>(
      () => _i10.CreateCloth(get<_i8.BaseClothesRepository>()));
  gh.lazySingleton<_i11.CreateClothTag>(
      () => _i11.CreateClothTag(get<_i8.BaseClothesRepository>()));
  gh.lazySingleton<_i12.DeleteCloth>(
      () => _i12.DeleteCloth(get<_i8.BaseClothesRepository>()));
  gh.lazySingleton<_i13.DeleteClothImage>(
      () => _i13.DeleteClothImage(get<_i8.BaseClothesRepository>()));
  gh.lazySingleton<_i14.DeleteClothTag>(
      () => _i14.DeleteClothTag(get<_i8.BaseClothesRepository>()));
  gh.lazySingleton<_i15.GetCloth>(
      () => _i15.GetCloth(get<_i8.BaseClothesRepository>()));
  gh.lazySingleton<_i16.GetClothes>(
      () => _i16.GetClothes(get<_i8.BaseClothesRepository>()));
  gh.lazySingleton<_i17.UpdateCloth>(
      () => _i17.UpdateCloth(get<_i8.BaseClothesRepository>()));
  gh.lazySingleton<_i18.UpdateClothTag>(
      () => _i18.UpdateClothTag(get<_i8.BaseClothesRepository>()));
  gh.lazySingleton<_i19.AddClothImage>(
      () => _i19.AddClothImage(get<_i8.BaseClothesRepository>()));
  gh.factory<_i20.ClothesBloc>(
      () => _i20.ClothesBloc(getClothes: get<_i16.GetClothes>()));
  return get;
}

class _$RegisterModule extends _i5.RegisterModule {}
