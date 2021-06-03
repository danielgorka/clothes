import 'package:clothes/core/use_cases/no_params.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'NoParams',
    () {
      test('should return correct props', () {
        expect(NoParams().props, []);
      });
    },
  );
}
