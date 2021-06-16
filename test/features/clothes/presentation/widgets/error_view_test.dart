import 'package:clothes/features/clothes/presentation/widgets/error_view.dart';
import 'package:clothes/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/app_wrapper.dart';

void main() {
  group(
    'ErrorView',
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
                const ErrorView(image: image),
              ));
              // assert
              expect(find.byWidget(image), findsOneWidget);
            },
          );
        },
      );

      group(
        'Error message',
        () {
          testWidgets(
            'should show default error message when none is specified',
            (tester) async {
              // arrange
              await tester.pumpWidget(wrapWithApp(const ErrorView()));
              // assert
              final BuildContext context =
                  tester.element(find.byType(ErrorView));
              expect(
                  find.text(context.l10n.somethingWentWrong), findsOneWidget);
            },
          );

          testWidgets(
            'should show specified error message',
            (tester) async {
              // arrange
              const msg = 'Error message';
              await tester.pumpWidget(wrapWithApp(
                const ErrorView(message: msg),
              ));
              // assert
              expect(find.text(msg), findsOneWidget);
            },
          );
        },
      );

      group(
        'Try again button',
        () {
          testWidgets(
            'should not show any button when onTryAgain is not specified',
            (tester) async {
              // arrange
              await tester.pumpWidget(wrapWithApp(const ErrorView()));
              // assert
              expect(find.byType(ButtonStyleButton), findsNothing);
            },
          );

          testWidgets(
            'should call onTryAgain after pressing the button',
            (tester) async {
              // arrange
              bool pressed = false;
              await tester.pumpWidget(wrapWithApp(
                ErrorView(onTryAgain: () => pressed = true),
              ));
              // act
              await tester.tap(find.byType(TextButton));
              // assert
              expect(pressed, isTrue);
            },
          );
        },
      );
    },
  );
}
