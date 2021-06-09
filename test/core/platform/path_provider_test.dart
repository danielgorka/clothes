import 'package:clothes/core/platform/path_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:test/fake.dart';

const appDir = 'app/dir';

class FakePathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    return appDir;
  }
}

void main() {
  group(
    'PathProvider',
    () {
      final pathProvider = PathProvider();

      setUp(() async {
        PathProviderPlatform.instance = FakePathProviderPlatform();
      });

      group(
        'getAppPath',
        () {
          test(
            'should return getApplicationDocumentsDirectory()',
            () async {
              // act
              final result = await pathProvider.getAppPath();
              // assert
              expect(result.path, appDir);
            },
          );
        },
      );
    },
  );
}
