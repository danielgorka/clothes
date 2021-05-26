import 'package:clothes/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App', () {
    testWidgets('should show HomePage at start', (tester) async {
      await tester.pumpWidget(App());
      await tester.pump();
      expect(find.text('Home page'), findsOneWidget);
    });
  });
}
