import 'package:clothes/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App', () {
    testWidgets('should app starts', (tester) async {
      await tester.pumpWidget(App());
      expect(find.text('Hello world!'), findsOneWidget);
    });
  });
}
