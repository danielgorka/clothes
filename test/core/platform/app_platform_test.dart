import 'package:clothes/core/platform/app_platform.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'AppPlatform.isWeb',
    () {
      test(
        'should return bool',
        () {
          // act
          final result = AppPlatform().isWeb;
          // assert
          expect(result, isA<bool>());
        },
      );
    },
  );
}
