// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:hive/hive.dart' as _i5;
import 'package:injectable/injectable.dart' as _i2;

import 'core/platform/path_provider.dart' as _i4;
import 'features/clothes/data/data_sources/clothes_local_data_source.dart'
    as _i6;
import 'features/clothes/data/data_sources/images/base_images_local_data_source.dart'
    as _i3;
import 'features/clothes/data/repositories/clothes_repository.dart' as _i8;
import 'features/clothes/domain/repositories/base_clothes_repository.dart'
    as _i7;
import 'features/clothes/domain/use_cases/add_cloth_image.dart' as _i18;
import 'features/clothes/domain/use_cases/create_cloth.dart' as _i9;
import 'features/clothes/domain/use_cases/create_cloth_tag.dart' as _i10;
import 'features/clothes/domain/use_cases/delete_cloth.dart' as _i11;
import 'features/clothes/domain/use_cases/delete_cloth_image.dart' as _i12;
import 'features/clothes/domain/use_cases/delete_cloth_tag.dart' as _i13;
import 'features/clothes/domain/use_cases/get_cloth.dart' as _i14;
import 'features/clothes/domain/use_cases/get_clothes.dart' as _i15;
import 'features/clothes/domain/use_cases/update_cloth.dart' as _i16;
import 'features/clothes/domain/use_cases/update_cloth_tag.dart' as _i17;
import 'features/clothes/presentation/blocs/clothes/clothes_bloc.dart' as _i19;
import 'injection.dart' as _i20; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) async {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final registerModule = _$RegisterModule();
  await gh.factoryAsync<_i3.BaseImagesLocalDataSource>(
      () => registerModule.imagesLocalDataSource(),
      preResolve: true);
  gh.lazySingleton<_i4.BasePathProvider>(() => _i4.PathProvider());
  gh.lazySingleton<_i5.HiveInterface>(() => registerModule.hive());
  gh.lazySingletonAsync<_i6.BaseClothesLocalDataSource>(
      () => _i6.ClothesLocalDataSource.init(
          hive: get<_i5.HiveInterface>(),
          pathProvider: get<_i4.BasePathProvider>()),
      dispose: (i) => i.close());
  gh.lazySingleton<_i7.BaseClothesRepository>(() => _i8.ClothesRepository(
      clothesDataSource: get<_i6.BaseClothesLocalDataSource>(),
      imagesDataSource: get<_i3.BaseImagesLocalDataSource>()));
  gh.lazySingleton<_i9.CreateCloth>(
      () => _i9.CreateCloth(get<_i7.BaseClothesRepository>()));
  gh.lazySingleton<_i10.CreateClothTag>(
      () => _i10.CreateClothTag(get<_i7.BaseClothesRepository>()));
  gh.lazySingleton<_i11.DeleteCloth>(
      () => _i11.DeleteCloth(get<_i7.BaseClothesRepository>()));
  gh.lazySingleton<_i12.DeleteClothImage>(
      () => _i12.DeleteClothImage(get<_i7.BaseClothesRepository>()));
  gh.lazySingleton<_i13.DeleteClothTag>(
      () => _i13.DeleteClothTag(get<_i7.BaseClothesRepository>()));
  gh.lazySingleton<_i14.GetCloth>(
      () => _i14.GetCloth(get<_i7.BaseClothesRepository>()));
  gh.lazySingleton<_i15.GetClothes>(
      () => _i15.GetClothes(get<_i7.BaseClothesRepository>()));
  gh.lazySingleton<_i16.UpdateCloth>(
      () => _i16.UpdateCloth(get<_i7.BaseClothesRepository>()));
  gh.lazySingleton<_i17.UpdateClothTag>(
      () => _i17.UpdateClothTag(get<_i7.BaseClothesRepository>()));
  gh.lazySingleton<_i18.AddClothImage>(
      () => _i18.AddClothImage(get<_i7.BaseClothesRepository>()));
  gh.factory<_i19.ClothesBloc>(
      () => _i19.ClothesBloc(getClothes: get<_i15.GetClothes>()));
  return get;
}

class _$RegisterModule extends _i20.RegisterModule {}
