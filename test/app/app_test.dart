import 'package:clothes/app/app.dart';
import 'package:clothes/presentation/pages/home_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App', () {
    testWidgets('should show HomePage when app starts', (tester) async {
      await tester.pumpWidget(App());
      await tester.pump();
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
