import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

Future<void> testListener<S>({
  required WidgetTester tester,
  required MockBloc mockBloc,
  required AsyncCallback pumpWidget,
  required VoidCallback verifyAction,
  required List<S> states,
}) async {
  // arrange
  final controller = StreamController<S>.broadcast();
  when(() => mockBloc.state).thenAnswer((_) => states.first);
  when(() => mockBloc.stream).thenAnswer((_) => controller.stream);

  await pumpWidget.call();

  // act
  for (int i = 1; i < states.length; i++) {
    controller.add(states[i]);
  }
  // assert
  await untilCalled(verifyAction);
  await tester.pump(const Duration(seconds: 1));
  verify(verifyAction).called(1);
  controller.close();
}
