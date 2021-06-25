import 'package:auto_route/auto_route.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:clothes/app/utils/keys.dart';
import 'package:clothes/core/platform/app_image_picker.dart';
import 'package:clothes/features/clothes/presentation/blocs/edit_image/edit_image_bloc.dart';
import 'package:clothes/features/clothes/presentation/pages/edit_image_page.dart';
import 'package:clothes/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/app_wrapper.dart';
import '../../../../helpers/fixture_reader.dart';

class MockGetIt extends Mock implements GetIt {}

class MockStackRouter extends Mock implements StackRouter {}

class MockAppImagePicker extends Mock implements BaseAppImagePicker {}

class MockEditImageBloc extends MockBloc<EditImageEvent, EditImageState>
    implements EditImageBloc {}

class MockEditImageEvent extends EditImageEvent {}

class MockEditImageState extends EditImageState {}

void main() {
  final image = readAsBytes('black.png');
  const source = ImagePickerSource.gallery;
  late MockEditImageBloc mockEditImageBloc;

  setUpAll(() {
    registerFallbackValue<EditImageEvent>(MockEditImageEvent());
    registerFallbackValue<EditImageState>(MockEditImageState());
  });

  setUp(() async {
    mockEditImageBloc = MockEditImageBloc();
  });

  Widget wrapWithBloc(Widget widget, {EditImageBloc? bloc}) {
    return wrapWithApp(
      BlocProvider<EditImageBloc>.value(
        value: bloc ?? mockEditImageBloc,
        child: Builder(
          builder: (context) {
            return widget;
          },
        ),
      ),
    );
  }

  group(
    'EditImagePage',
    () {
      late MockGetIt mockGetIt;

      setUp(() async {
        mockGetIt = MockGetIt();
        await configureDependencies(
          get: mockGetIt,
          initGetIt: (_) async {},
        );
        when(() => mockGetIt<EditImageBloc>())
            .thenAnswer((_) => mockEditImageBloc);
        when(() => mockEditImageBloc.state)
            .thenAnswer((_) => const EditImageState());
      });

      testWidgets(
        'should show EditImageView',
        (tester) async {
          // arrange
          await tester.pumpWidget(
            wrapWithApp(
              // ignore: prefer_const_constructors
              EditImagePage(source: source),
            ),
          );
          // assert
          expect(find.byType(EditImageView), findsOneWidget);
        },
      );

      testWidgets(
        'should add PickImage event to bloc after create',
        (tester) async {
          // arrange
          await tester.pumpWidget(
            wrapWithApp(
              const EditImagePage(source: source),
            ),
          );
          // assert
          final BuildContext context =
              tester.element(find.byType(EditImageView));
          expect(
            BlocProvider.of<EditImageBloc>(context),
            equals(mockEditImageBloc),
          );
          verify(() => mockGetIt<EditImageBloc>()).called(1);
          verify(() => mockEditImageBloc.add(
                const PickImage(imagePickerSource: source),
              )).called(1);
        },
      );
    },
  );

  group(
    'EditImageView',
    () {
      testWidgets(
        'should show EditingView when state status is editing',
        (tester) async {
          // arrange
          when(() => mockEditImageBloc.state).thenAnswer(
            (_) => EditImageState(
              status: EditImageStatus.editing,
              image: image,
            ),
          );
          await tester.pumpWidget(
            wrapWithBloc(const EditImageView(source: source)),
          );
          // assert
          final finder = find.byType(EditingView);
          final editingView = tester.widget<EditingView>(finder);
          expect(editingView.image, image);
        },
      );
      testWidgets(
        'should show EditingView when state status is completed',
        (tester) async {
          // arrange
          when(() => mockEditImageBloc.state).thenAnswer(
            (_) => EditImageState(
              status: EditImageStatus.completed,
              image: image,
            ),
          );
          await tester.pumpWidget(
            wrapWithBloc(const EditImageView(source: source)),
          );
          // assert
          final finder = find.byType(EditingView);
          final editingView = tester.widget<EditingView>(finder);
          expect(editingView.image, image);
        },
      );
      testWidgets(
        'should show PickingView when state status is picking',
        (tester) async {
          // arrange
          when(() => mockEditImageBloc.state)
              .thenAnswer((_) => const EditImageState());
          await tester.pumpWidget(
            wrapWithBloc(const EditImageView(source: source)),
          );
          // assert
          expect(find.byType(PickingView), findsOneWidget);
        },
      );
      testWidgets(
        'should pop page and return image when state status changes to completed',
        (tester) async {
          // arrange
          final mockStackRouter = MockStackRouter();
          final mockAppImagePicker = MockAppImagePicker();
          final editImageBloc = EditImageBloc(
            appImagePicker: mockAppImagePicker,
          );
          when(() => mockStackRouter.pop(image))
              .thenAnswer((_) => Future.value(true));
          when(() => mockAppImagePicker.pickImage(ImageSource.gallery))
              .thenAnswer((_) => Future.value(image));
          await tester.pumpWidget(
            StackRouterScope(
              segmentsHash: 0,
              controller: mockStackRouter,
              child: wrapWithBloc(
                const EditImageView(source: source),
                bloc: editImageBloc,
              ),
            ),
          );
          // act
          editImageBloc.add(
            const PickImage(
              imagePickerSource: ImagePickerSource.gallery,
            ),
          );
          editImageBloc.add(CompleteEditingImage());
          // assert
          await untilCalled(() => mockStackRouter.pop(image));
          verify(() => mockStackRouter.pop(image)).called(1);
          verifyNoMoreInteractions(mockStackRouter);
        },
      );
      testWidgets(
        'should pop page and return null when state status changes to canceled',
        (tester) async {
          // arrange
          final mockStackRouter = MockStackRouter();
          final mockAppImagePicker = MockAppImagePicker();
          final editImageBloc = EditImageBloc(
            appImagePicker: mockAppImagePicker,
          );
          when(() => mockStackRouter.pop())
              .thenAnswer((_) => Future.value(true));
          when(() => mockAppImagePicker.pickImage(ImageSource.gallery))
              .thenAnswer((_) => Future.value(image));
          await tester.pumpWidget(
            StackRouterScope(
              segmentsHash: 0,
              controller: mockStackRouter,
              child: wrapWithBloc(
                const EditImageView(source: source),
                bloc: editImageBloc,
              ),
            ),
          );
          // act
          editImageBloc.add(
            const PickImage(
              imagePickerSource: ImagePickerSource.gallery,
            ),
          );
          editImageBloc.add(CancelEditingImage());
          // assert
          await untilCalled(() => mockStackRouter.pop());
          verify(() => mockStackRouter.pop()).called(1);
          verifyNoMoreInteractions(mockStackRouter);
        },
      );
    },
  );

  group(
    'EditingView',
    () {
      testWidgets(
        'should show SaveBar',
        (tester) async {
          // arrange
          await tester.pumpWidget(wrapWithApp(EditingView(image: image)));
          // assert
          expect(find.byType(SaveBar), findsOneWidget);
        },
      );
      testWidgets(
        'should show PreviewImage in Expanded',
        (tester) async {
          // arrange
          await tester.pumpWidget(wrapWithApp(EditingView(image: image)));
          // assert
          final finder = find.descendant(
            of: find.byType(Expanded),
            matching: find.byType(PreviewImage),
          );
          expect(finder, findsOneWidget);
        },
      );
    },
  );

  group(
    'PickingView',
    () {
      testWidgets(
        'should show centered text',
        (tester) async {
          // arrange
          await tester.pumpWidget(wrapWithApp(const PickingView()));
          // assert
          final finder = find.descendant(
            of: find.byType(Center),
            matching: find.byType(Text),
          );
          expect(finder, findsOneWidget);
        },
      );
      testWidgets(
        'should render GestureDetector with translucent behavior',
        (tester) async {
          // arrange
          await tester.pumpWidget(wrapWithApp(const PickingView()));
          // assert
          final finder = find.byType(GestureDetector);
          final gestureDetector = tester.widget<GestureDetector>(finder);
          expect(gestureDetector.behavior, HitTestBehavior.translucent);
        },
      );
      testWidgets(
        'should add CancelEditingImage event on pan down',
        (tester) async {
          // arrange
          await tester.pumpWidget(wrapWithBloc(const PickingView()));
          // act
          await tester.tap(find.byType(GestureDetector));
          // assert
          verify(() => mockEditImageBloc.add(CancelEditingImage())).called(1);
        },
      );
    },
  );

  group(
    'SaveBar',
    () {
      testWidgets(
        'should show two TextButtons',
        (tester) async {
          // arrange
          await tester.pumpWidget(wrapWithApp(const SaveBar()));
          // assert
          expect(find.byType(TextButton), findsNWidgets(2));
        },
      );
      testWidgets(
        'should add CancelEditingImage event on cancel button pressed',
        (tester) async {
          // arrange
          await tester.pumpWidget(wrapWithBloc(const SaveBar()));
          // act
          await tester.tap(find.byKey(Keys.editImageCancelButton));
          // assert
          verify(() => mockEditImageBloc.add(CancelEditingImage())).called(1);
        },
      );
      testWidgets(
        'should add CompleteEditingImage event on cancel button pressed',
        (tester) async {
          // arrange
          await tester.pumpWidget(wrapWithBloc(const SaveBar()));
          // act
          await tester.tap(find.byKey(Keys.editImageSaveButton));
          // assert
          verify(() => mockEditImageBloc.add(CompleteEditingImage())).called(1);
        },
      );
    },
  );

  group(
    'PreviewImage',
    () {
      testWidgets(
        'should show Image',
        (tester) async {
          // arrange
          await tester.pumpWidget(
            wrapWithApp(PreviewImage(image: image)),
          );
          // assert
          final finder = find.byType(Image);
          final imageWidget = tester.widget<Image>(finder);
          final memoryImage = imageWidget.image as MemoryImage;
          expect(memoryImage.bytes, image);
        },
      );
    },
  );
}
