import 'package:clothes/core/platform/app_platform.dart';
import 'package:clothes/core/platform/path_provider.dart';
import 'package:clothes/features/clothes/data/data_sources/images/images_local_data_source.dart';
import 'package:clothes/features/clothes/data/data_sources/images/images_local_data_source_web.dart';
import 'package:clothes/injection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';

class MockGetIt extends Mock implements GetIt {}

class MockPathProvider extends Mock implements BasePathProvider {}

class MockAppPlatform extends Mock implements BaseAppPlatform {}

class MockHive extends Mock implements HiveInterface {}

class MockInitGetItFunction extends Mock {
  Future<GetIt> call(GetIt getIt);
}

class TestableRegisterModule extends RegisterModule {}

void main() {
  group(
    'configureDependencies',
    () {
      test(
        'should call initGetIt',
        () async {
          // arrange
          final mockGetIt = MockGetIt();
          final mockInitGetItFunction = MockInitGetItFunction();
          when(() => mockInitGetItFunction(mockGetIt))
              .thenAnswer((_) => Future.value(mockGetIt));
          // act
          await configureDependencies(
            get: mockGetIt,
            initGetIt: mockInitGetItFunction,
          );
          // assert
          verify(() => mockInitGetItFunction(mockGetIt)).called(1);
          verifyNoMoreInteractions(mockInitGetItFunction);
        },
      );
    },
  );

  group(
    'RegisterModule',
    () {
      final testableRegisterModule = TestableRegisterModule();

      group(
        'hive',
        () {
          test(
            'should return Hive instance',
            () {
              // act
              final result = testableRegisterModule.hive();
              // assert
              expect(result, equals(Hive));
            },
          );
        },
      );

      group(
        'imagesLocalDataSource',
        () {
          late MockPathProvider mockPathProvider;
          late MockAppPlatform mockAppPlatform;

          setUp(() {
            mockPathProvider = MockPathProvider();
            mockAppPlatform = MockAppPlatform();
          });

          test(
            'should return ImagesLocalDataSource instance '
            'when platform is not web',
            () async {
              // arrange
              when(() => mockAppPlatform.isWeb)
                  .thenAnswer((invocation) => false);
              when(() => mockPathProvider.getAppPath())
                  .thenAnswer((_) => Future.value('path'));
              // act
              final result = await testableRegisterModule.imagesLocalDataSource(
                mockPathProvider,
                mockAppPlatform,
              );
              // assert
              expect(result, isA<ImagesLocalDataSource>());
              verify(() => mockAppPlatform.isWeb).called(1);
              verify(() => mockPathProvider.getAppPath()).called(1);
              verifyNoMoreInteractions(mockAppPlatform);
              verifyNoMoreInteractions(mockPathProvider);
            },
          );

          test(
            'should return ImagesLocalDataSourceWeb instance '
            'when platform is web',
            () async {
              // arrange
              when(() => mockAppPlatform.isWeb)
                  .thenAnswer((invocation) => true);
              // act
              final result = await testableRegisterModule.imagesLocalDataSource(
                mockPathProvider,
                mockAppPlatform,
              );
              // assert
              expect(result, isA<ImagesLocalDataSourceWeb>());
              verify(() => mockAppPlatform.isWeb).called(1);
              verifyNoMoreInteractions(mockAppPlatform);
              verifyNoMoreInteractions(mockPathProvider);
            },
          );
        },
      );
    },
  );

  group(
    'disposeHive',
    () {
      test(
        'should call hive.close()',
        () {
          // arrange
          final mockHive = MockHive();
          when(() => mockHive.close()).thenAnswer((_) => Future.value(null));
          // act
          disposeHive(mockHive);
          // assert
          verify(() => mockHive.close()).called(1);
          verifyNoMoreInteractions(mockHive);
        },
      );
    },
  );
}
