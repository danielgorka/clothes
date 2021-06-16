import 'package:clothes/features/clothes/presentation/widgets/empty_view.dart';
import 'package:clothes/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/app_wrapper.dart';

void main() {
  group(
    'EmptyView',
    () {
      group(
        'Image',
        () {
          testWidgets(
            'should show specified image widget',
            (tester) async {
              // arrange
              const image = Text('Custom image');
              await tester.pumpWidget(wrapWithApp(
                // ignore: prefer_const_constructors
                EmptyView(image: image),
              ));
              // assert
              expect(find.byWidget(image), findsOneWidget);
            },
          );
        },
      );

      group(
        'Message',
        () {
          testWidgets(
            'should show default message when none is specified',
            (tester) async {
              // arrange
              await tester.pumpWidget(wrapWithApp(const EmptyView()));
              // assert
              final BuildContext context =
                  tester.element(find.byType(EmptyView));
              expect(find.text(context.l10n.nothingToShow), findsOneWidget);
            },
          );

          testWidgets(
            'should show specified error message',
            (tester) async {
              // arrange
              const msg = 'No clothes found';
              await tester.pumpWidget(wrapWithApp(
                const EmptyView(message: msg),
              ));
              // assert
              expect(find.text(msg), findsOneWidget);
            },
          );
        },
      );
    },
  );
}
