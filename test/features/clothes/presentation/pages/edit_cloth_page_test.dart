import 'package:auto_route/auto_route.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:clothes/app/utils/keys.dart';
import 'package:clothes/features/clothes/domain/entities/cloth_tag.dart';
import 'package:clothes/features/clothes/presentation/blocs/edit_cloth/edit_cloth_bloc.dart';
import 'package:clothes/features/clothes/presentation/pages/edit_cloth_page.dart';
import 'package:clothes/features/clothes/presentation/widgets/animated_visibility.dart';
import 'package:clothes/features/clothes/presentation/widgets/app_bar_floating_action_button.dart';
import 'package:clothes/features/clothes/presentation/widgets/app_shimmer.dart';
import 'package:clothes/features/clothes/presentation/widgets/cloth_image_view.dart';
import 'package:clothes/features/clothes/presentation/widgets/error_view.dart';
import 'package:clothes/features/clothes/presentation/widgets/image_shadow.dart';
import 'package:clothes/features/clothes/presentation/widgets/rounded_container.dart';
import 'package:clothes/features/clothes/presentation/widgets/tag_view.dart';
import 'package:clothes/injection.dart';
import 'package:clothes/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/app_wrapper.dart';
import '../../../../helpers/entities.dart';
import '../../../../helpers/tests.dart';

class MockGetIt extends Mock implements GetIt {}

class MockStackRouter extends Mock implements StackRouter {}

class MockEditClothBloc extends MockBloc<EditClothEvent, EditClothState>
    implements EditClothBloc {}

class MockEditClothEvent extends EditClothEvent {}

class MockEditClothState extends EditClothState {}

void main() {
  late MockEditClothBloc mockEditClothBloc;

  setUpAll(() {
    registerFallbackValue<EditClothEvent>(MockEditClothEvent());
    registerFallbackValue<EditClothState>(MockEditClothState());
  });

  setUp(() {
    mockEditClothBloc = MockEditClothBloc();
    when(() => mockEditClothBloc.state)
        .thenAnswer((_) => const EditClothState(loading: true));
  });

  Widget wrapWithBloc(Widget widget, {EditClothBloc? bloc}) {
    return wrapWithApp(
      BlocProvider<EditClothBloc>.value(
        value: bloc ?? mockEditClothBloc,
        child: Builder(
          builder: (context) {
            return widget;
          },
        ),
      ),
    );
  }

  group(
    'EditClothPage',
    () {
      late MockGetIt mockGetIt;

      setUp(() async {
        mockGetIt = MockGetIt();
        await configureDependencies(
          get: mockGetIt,
          initGetIt: (_) async {},
        );
        when(() => mockGetIt<EditClothBloc>())
            .thenAnswer((_) => mockEditClothBloc);
      });

      testWidgets(
        'should show EditClothView',
        (tester) async {
          // arrange
          await tester.pumpWidget(
            wrapWithApp(
              EditClothPage(clothId: cloth1.id),
            ),
          );
          // assert
          expect(find.byType(EditClothView), findsOneWidget);
        },
      );

      testWidgets(
        'should add SetCloth event to bloc after create',
        (tester) async {
          // arrange
          await tester.pumpWidget(
            wrapWithApp(
              EditClothPage(clothId: cloth1.id),
            ),
          );
          // assert
          final BuildContext context =
              tester.element(find.byType(EditClothView));
          expect(
            BlocProvider.of<EditClothBloc>(context),
            equals(mockEditClothBloc),
          );
          verify(() => mockGetIt<EditClothBloc>()).called(1);
          verify(() => mockEditClothBloc.add(SetCloth(clothId: cloth1.id)))
              .called(1);
        },
      );
    },
  );

  group(
    'EditClothView',
    () {
      group(
        'Views based on state',
        () {
          testWidgets(
            'should show ErrorView with somethingWentWrong message '
            'when state has other error and no cloth',
            (tester) async {
              // arrange
              when(() => mockEditClothBloc.state).thenAnswer(
                (_) => const EditClothState(error: EditClothError.other),
              );
              await tester.pumpWidget(
                wrapWithBloc(
                  const EditClothView(),
                ),
              );
              // assert
              final finder = find.byType(ErrorView);
              final errorView = tester.widget<ErrorView>(finder);
              final BuildContext context = tester.element(finder);
              expect(
                errorView.message,
                equals(context.l10n.somethingWentWrong),
              );
            },
          );
          testWidgets(
            'should show ErrorView with clothNotFound message '
            'when state has cloth not found error and no cloth',
            (tester) async {
              // arrange
              when(() => mockEditClothBloc.state).thenAnswer(
                (_) => const EditClothState(
                  error: EditClothError.clothNotFound,
                ),
              );
              await tester.pumpWidget(
                wrapWithBloc(
                  const EditClothView(),
                ),
              );
              // assert
              final finder = find.byType(ErrorView);
              final errorView = tester.widget<ErrorView>(finder);
              final BuildContext context = tester.element(finder);
              expect(errorView.message, equals(context.l10n.clothNotFound));
            },
          );
          testWidgets(
            'should show MainClothView when state has cloth',
            (tester) async {
              // arrange
              when(() => mockEditClothBloc.state).thenAnswer(
                (_) => EditClothState(cloth: cloth1),
              );
              await tester.pumpWidget(
                wrapWithBloc(
                  const EditClothView(),
                ),
              );
              // assert
              expect(find.byType(MainClothView), findsOneWidget);
            },
          );
          testWidgets(
            'should show MainClothView when state has error and has cloth',
            (tester) async {
              // arrange
              when(() => mockEditClothBloc.state).thenAnswer(
                (_) => EditClothState(
                  cloth: cloth1,
                  error: EditClothError.other,
                ),
              );
              await tester.pumpWidget(
                wrapWithBloc(
                  const EditClothView(),
                ),
              );
              // assert
              expect(find.byType(MainClothView), findsOneWidget);
            },
          );
          testWidgets(
            'should show MainClothView when state is loading and has no cloth',
            (tester) async {
              // arrange
              when(() => mockEditClothBloc.state).thenAnswer(
                (_) => const EditClothState(loading: true),
              );
              await tester.pumpWidget(
                wrapWithBloc(
                  const EditClothView(),
                ),
              );
              // assert
              expect(find.byType(MainClothView), findsOneWidget);
            },
          );
        },
      );

      group(
        'Listener',
        () {
          testWidgets(
            'should pop page when state action changes to CloseClothAction '
            'and add ClearAction event',
            (tester) async {
              final mockStackRouter = MockStackRouter();
              when(() => mockStackRouter.pop())
                  .thenAnswer((_) => Future.value(true));

              await testListener(
                tester: tester,
                mockBloc: mockEditClothBloc,
                pumpWidget: () async {
                  await tester.pumpWidget(
                    StackRouterScope(
                      segmentsHash: 0,
                      controller: mockStackRouter,
                      child: wrapWithBloc(
                        const EditClothView(),
                      ),
                    ),
                  );
                },
                verifyAction: () => mockEditClothBloc.add(ClearAction()),
                states: [
                  const EditClothState(),
                  const EditClothState(
                    action: CloseClothAction(),
                  ),
                ],
              );
              verify(() => mockStackRouter.pop()).called(1);
            },
          );
          testWidgets(
            'should pop page ones when state action changes to '
            'CloseClothAction two in a row',
            (tester) async {
              final mockStackRouter = MockStackRouter();
              when(() => mockStackRouter.pop())
                  .thenAnswer((_) => Future.value(true));

              await testListener(
                tester: tester,
                mockBloc: mockEditClothBloc,
                pumpWidget: () async {
                  await tester.pumpWidget(
                    StackRouterScope(
                      segmentsHash: 0,
                      controller: mockStackRouter,
                      child: wrapWithBloc(
                        const EditClothView(),
                      ),
                    ),
                  );
                },
                verifyAction: () => mockEditClothBloc.add(ClearAction()),
                states: [
                  const EditClothState(),
                  const EditClothState(
                    action: CloseClothAction(),
                  ),
                  const EditClothState(
                    loading: true,
                    action: CloseClothAction(),
                  ),
                ],
              );
              verify(() => mockStackRouter.pop()).called(1);
            },
          );

          testWidgets(
            'should show SnackBar with somethingWentWrong message '
            'when state contains other error and cloth is not null '
            'and later should add ClearError event',
            (tester) async {
              await testListener(
                tester: tester,
                mockBloc: mockEditClothBloc,
                pumpWidget: () async {
                  await tester.pumpWidget(
                    wrapWithBloc(
                      const EditClothView(),
                    ),
                  );
                },
                verifyAction: () => mockEditClothBloc.add(ClearError()),
                states: [
                  EditClothState(
                    cloth: cloth1,
                  ),
                  EditClothState(
                    cloth: cloth1,
                    error: EditClothError.other,
                  ),
                ],
              );
              final finder = find.byType(SnackBar);
              final BuildContext context = tester.element(finder);
              expect(
                find.text(context.l10n.somethingWentWrong),
                findsOneWidget,
              );
            },
          );
          testWidgets(
            'should show SnackBar with errorSavingChanges message '
            'when state contains saving error and cloth is not null '
            'and later should add ClearError event',
            (tester) async {
              await testListener(
                tester: tester,
                mockBloc: mockEditClothBloc,
                pumpWidget: () async {
                  await tester.pumpWidget(
                    wrapWithBloc(
                      const EditClothView(),
                    ),
                  );
                },
                verifyAction: () => mockEditClothBloc.add(ClearError()),
                states: [
                  EditClothState(
                    cloth: cloth1,
                  ),
                  EditClothState(
                    cloth: cloth1,
                    error: EditClothError.savingError,
                  ),
                ],
              );
              final finder = find.byType(SnackBar);
              final BuildContext context = tester.element(finder);
              expect(
                find.text(context.l10n.errorSavingChanges),
                findsOneWidget,
              );
            },
          );
          testWidgets(
            'should show SnackBar ones when bloc emits states '
            'containing the same error two in a row',
            (tester) async {
              await testListener(
                tester: tester,
                mockBloc: mockEditClothBloc,
                pumpWidget: () async {
                  await tester.pumpWidget(
                    wrapWithBloc(
                      const EditClothView(),
                    ),
                  );
                },
                verifyAction: () => mockEditClothBloc.add(ClearError()),
                states: [
                  EditClothState(
                    cloth: cloth1,
                  ),
                  EditClothState(
                    cloth: cloth1,
                    error: EditClothError.other,
                  ),
                  EditClothState(
                    loading: true,
                    cloth: cloth1,
                    error: EditClothError.other,
                  ),
                ],
              );
              expect(find.byType(SnackBar), findsOneWidget);
            },
          );
        },
      );
    },
  );

  group(
    'MainClothView',
    () {
      void setLongScreen(WidgetTester tester) {
        tester.binding.window.physicalSizeTestValue = const Size(500, 5000);
        addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      }

      group(
        'Show AppShimmer',
        () {
          testWidgets(
            'should show AppShimmer when cloth is null',
            (tester) async {
              // arrange
              await tester.pumpWidget(
                wrapWithApp(
                  const Material(
                    child: MainClothView(),
                  ),
                ),
              );
              // assert
              expect(find.byType(AppShimmer), findsOneWidget);
            },
          );
          testWidgets(
            'should not show AppShimmer when cloth is not null',
            (tester) async {
              // arrange
              await tester.pumpWidget(
                wrapWithApp(
                  Material(
                    child: MainClothView(
                      cloth: cloth1,
                    ),
                  ),
                ),
              );
              // assert
              expect(find.byType(AppShimmer), findsNothing);
            },
          );
        },
      );

      group(
        'Show Stack for image and cloth name',
        () {
          testWidgets(
            'should show Stack with ImagesView, ImageShadow and NameMainView',
            (tester) async {
              // arrange
              await tester.pumpWidget(
                wrapWithApp(
                  Material(
                    child: MainClothView(
                      cloth: cloth1,
                    ),
                  ),
                ),
              );
              // assert
              expect(
                find.descendant(
                  of: find.byType(Stack),
                  matching: find.byType(ImagesView),
                ),
                findsOneWidget,
              );
              expect(
                find.descendant(
                  of: find.byType(Stack),
                  matching: find.byType(ImageShadow),
                ),
                findsWidgets,
              );
              expect(
                find.descendant(
                  of: find.byType(Stack),
                  matching: find.byType(NameMainView),
                ),
                findsOneWidget,
              );
            },
          );

          group(
            'Show ImagesView',
            () {
              testWidgets(
                'should show ImagesView with images from cloth',
                (tester) async {
                  // arrange
                  await tester.pumpWidget(
                    wrapWithApp(
                      Material(
                        child: MainClothView(
                          cloth: cloth1,
                        ),
                      ),
                    ),
                  );
                  // assert
                  final finder = find.byType(ImagesView);
                  final imagesView = tester.widget<ImagesView>(finder);
                  expect(imagesView.images, equals(cloth1.images));
                },
              );
              testWidgets(
                'should show ImagesView with null images when cloth is null',
                (tester) async {
                  // arrange
                  await tester.pumpWidget(
                    wrapWithApp(
                      const Material(
                        child: MainClothView(),
                      ),
                    ),
                  );
                  // assert
                  final finder = find.byType(ImagesView);
                  final imagesView = tester.widget<ImagesView>(finder);
                  expect(imagesView.images, isNull);
                },
              );
            },
          );

          group(
            'Show bottom ImageShadow',
            () {
              testWidgets(
                'should show bottom shadow when cloth is null',
                (tester) async {
                  // arrange
                  await tester.pumpWidget(
                    wrapWithApp(
                      const Material(
                        child: MainClothView(),
                      ),
                    ),
                  );
                  // assert
                  final finder = find.byKey(Keys.editClothBottomShadow);
                  final imageShadow = tester.widget<ImageShadow>(finder);
                  expect(imageShadow.side, equals(ShadowSide.bottom));
                },
              );
              testWidgets(
                'should show bottom shadow when cloth name is not empty',
                (tester) async {
                  // arrange
                  await tester.pumpWidget(
                    wrapWithApp(
                      Material(
                        child: MainClothView(
                          cloth: cloth1,
                        ),
                      ),
                    ),
                  );
                  // assert
                  final finder = find.byKey(Keys.editClothBottomShadow);
                  final imageShadow = tester.widget<ImageShadow>(finder);
                  expect(imageShadow.side, equals(ShadowSide.bottom));
                },
              );
              testWidgets(
                'should show no shadow when cloth name is empty',
                (tester) async {
                  // arrange
                  await tester.pumpWidget(
                    wrapWithApp(
                      Material(
                        child: MainClothView(
                          cloth: clothWithoutName,
                        ),
                      ),
                    ),
                  );
                  // assert
                  expect(find.byKey(Keys.editClothBottomShadow), findsNothing);
                },
              );
              testWidgets(
                'should show no shadow when editing is true',
                (tester) async {
                  // arrange
                  await tester.pumpWidget(
                    wrapWithApp(
                      Material(
                        child: MainClothView(
                          cloth: cloth1,
                          editing: true,
                        ),
                      ),
                    ),
                  );
                  // assert
                  expect(find.byKey(Keys.editClothBottomShadow), findsNothing);
                },
              );
            },
          );

          group(
            'Show NameMainView',
            () {
              testWidgets(
                'should show NameMainView with name from cloth',
                (tester) async {
                  // arrange
                  await tester.pumpWidget(
                    wrapWithApp(
                      Material(
                        child: MainClothView(
                          cloth: cloth1,
                        ),
                      ),
                    ),
                  );
                  // assert
                  final finder = find.byType(NameMainView);
                  final nameView = tester.widget<NameMainView>(finder);
                  expect(nameView.name, equals(cloth1.name));
                },
              );
              testWidgets(
                'should show NameMainView with null name when cloth is null',
                (tester) async {
                  // arrange
                  await tester.pumpWidget(
                    wrapWithApp(
                      const Material(
                        child: MainClothView(),
                      ),
                    ),
                  );
                  // assert
                  final finder = find.byType(NameMainView);
                  final nameView = tester.widget<NameMainView>(finder);
                  expect(nameView.name, isNull);
                },
              );
              testWidgets(
                'should not show NameMainView when editing is true',
                (tester) async {
                  // arrange
                  await tester.pumpWidget(
                    wrapWithApp(
                      const Material(
                        child: MainClothView(editing: true),
                      ),
                    ),
                  );
                  // assert
                  expect(find.byType(NameMainView), findsNothing);
                },
              );
            },
          );
        },
      );

      group(
        'Show NameEditableView',
        () {
          testWidgets(
            'should show NameEditableView with name when cloth is not null',
            (tester) async {
              // arrange
              setLongScreen(tester);
              await tester.pumpWidget(
                wrapWithApp(
                  Material(
                    child: MainClothView(
                      cloth: cloth1,
                    ),
                  ),
                ),
              );
              // assert
              final finder = find.byType(NameEditableView);
              final nameEditableView = tester.widget<NameEditableView>(finder);
              expect(nameEditableView.name, equals(cloth1.name));
            },
          );
          testWidgets(
            'should not show NameEditableView when cloth is null',
            (tester) async {
              // arrange
              setLongScreen(tester);
              await tester.pumpWidget(
                wrapWithApp(
                  Material(
                    child: MainClothView(),
                  ),
                ),
              );
              // assert
              expect(find.byType(NameEditableView), findsNothing);
            },
          );
          testWidgets(
            'should wrap with AnimatedVisibility with visible set to true '
            'when editing is true',
            (tester) async {
              // arrange
              setLongScreen(tester);
              await tester.pumpWidget(
                wrapWithApp(
                  Material(
                    child: MainClothView(
                      cloth: cloth1,
                      editing: true,
                    ),
                  ),
                ),
              );
              // assert
              final finder = find.ancestor(
                of: find.byType(NameEditableView),
                matching: find.byType(AnimatedVisibility),
              );
              final animatedVisibility =
                  tester.widget<AnimatedVisibility>(finder);
              expect(animatedVisibility.visible, isTrue);
            },
          );
          testWidgets(
            'should wrap with AnimatedVisibility with visible set to false '
            'when editing is false',
            (tester) async {
              // arrange
              setLongScreen(tester);
              await tester.pumpWidget(
                wrapWithApp(
                  Material(
                    child: MainClothView(
                      cloth: cloth1,
                      editing: false,
                    ),
                  ),
                ),
              );
              // assert
              final finder = find.ancestor(
                of: find.byType(NameEditableView),
                matching: find.byType(AnimatedVisibility),
              );
              final animatedVisibility =
                  tester.widget<AnimatedVisibility>(finder);
              expect(animatedVisibility.visible, isFalse);
            },
          );
        },
      );

      group(
        'Show DescriptionView',
        () {
          testWidgets(
            'should show DescriptionView with description from cloth',
            (tester) async {
              // arrange
              setLongScreen(tester);
              await tester.pumpWidget(
                wrapWithApp(
                  Material(
                    child: MainClothView(
                      cloth: cloth1,
                    ),
                  ),
                ),
              );
              // assert
              final finder = find.byType(DescriptionView);
              final descriptionView = tester.widget<DescriptionView>(finder);
              expect(descriptionView.description, equals(cloth1.description));
            },
          );
          testWidgets(
            'should show DescriptionView with null description '
            'when cloth is null',
            (tester) async {
              // arrange
              setLongScreen(tester);
              await tester.pumpWidget(
                wrapWithApp(
                  const Material(
                    child: MainClothView(),
                  ),
                ),
              );
              // assert
              final finder = find.byType(DescriptionView);
              final descriptionView = tester.widget<DescriptionView>(finder);
              expect(descriptionView.description, isNull);
            },
          );
        },
      );

      group(
        'Show TagsViews',
        () {
          testWidgets(
            'should show three TagsViews with tags from cloth',
            (tester) async {
              // arrange
              setLongScreen(tester);
              await tester.pumpWidget(
                wrapWithApp(
                  Material(
                    child: MainClothView(
                      cloth: cloth1,
                    ),
                  ),
                ),
              );
              // assert
              final finder = find.byType(TagsView);
              expect(finder, findsNWidgets(3));
              final tagsViews = tester.widgetList<TagsView>(finder).toList();
              for (final tagsView in tagsViews) {
                expect(tagsView.tags, equals(cloth1.tags));
              }
              expect(tagsViews[0].tagType, equals(ClothTagType.clothKind));
              expect(tagsViews[1].tagType, equals(ClothTagType.color));
              expect(tagsViews[2].tagType, equals(ClothTagType.other));
            },
          );
          testWidgets(
            'should show three TagsViews with null tags when cloth is null',
            (tester) async {
              // arrange
              setLongScreen(tester);
              await tester.pumpWidget(
                wrapWithApp(
                  const Material(
                    child: MainClothView(),
                  ),
                ),
              );
              // assert
              final finder = find.byType(TagsView);
              expect(finder, findsNWidgets(3));
              final tagsViews = tester.widgetList<TagsView>(finder).toList();
              for (final tagsView in tagsViews) {
                expect(tagsView.tags, isNull);
              }
            },
          );
        },
      );

      group(
        'Show CreationDateView',
        () {
          testWidgets(
            'should show CreationDateView with cloth creation date',
            (tester) async {
              // arrange
              setLongScreen(tester);
              await tester.pumpWidget(
                wrapWithApp(
                  Material(
                    child: MainClothView(
                      cloth: cloth1,
                    ),
                  ),
                ),
              );
              // assert
              final finder = find.byType(CreationDateView);
              final creationDateView = tester.widget<CreationDateView>(finder);
              expect(
                creationDateView.creationDate,
                equals(cloth1.creationDate),
              );
            },
          );
          testWidgets(
            'should show CreationDateView with null creation date '
            'when cloth is null',
            (tester) async {
              // arrange
              setLongScreen(tester);
              await tester.pumpWidget(
                wrapWithApp(
                  const Material(
                    child: MainClothView(),
                  ),
                ),
              );
              // assert
              final finder = find.byType(CreationDateView);
              final creationDateView = tester.widget<CreationDateView>(finder);
              expect(creationDateView.creationDate, isNull);
            },
          );
        },
      );

      group(
        'Show AppBarFloatingActionButton',
        () {
          testWidgets(
            'should show AppBarFloatingActionButton with filled heart icon '
            'when cloth is not null and favourite is true',
            (tester) async {
              // arrange
              setLongScreen(tester);
              await tester.pumpWidget(
                wrapWithApp(
                  Material(
                    child: MainClothView(
                      cloth: cloth1, // favourite is true
                    ),
                  ),
                ),
              );
              // assert
              final finder = find.byType(AppBarFloatingActionButton);
              final fab = tester.widget<AppBarFloatingActionButton>(finder);
              final icon = fab.child as Icon;
              expect(icon.icon, equals(Icons.favorite_outlined));
            },
          );
          testWidgets(
            'should show AppBarFloatingActionButton with outlined heart icon '
            'when cloth is not null and favourite is false',
            (tester) async {
              // arrange
              setLongScreen(tester);
              await tester.pumpWidget(
                wrapWithApp(
                  Material(
                    child: MainClothView(
                      cloth: cloth2, // favourite is false
                    ),
                  ),
                ),
              );
              // assert
              final finder = find.byType(AppBarFloatingActionButton);
              final fab = tester.widget<AppBarFloatingActionButton>(finder);
              final icon = fab.child as Icon;
              expect(icon.icon, equals(Icons.favorite_border_outlined));
            },
          );

          testWidgets(
            'should not show AppBarFloatingActionButton when cloth is null',
            (tester) async {
              // arrange
              setLongScreen(tester);
              await tester.pumpWidget(
                wrapWithApp(
                  const Material(
                    child: MainClothView(),
                  ),
                ),
              );
              // assert
              expect(find.byType(AppBarFloatingActionButton), findsNothing);
            },
          );
          testWidgets(
            'should not show FloatingActionButton when cloth is editing',
            (tester) async {
              // arrange
              setLongScreen(tester);
              await tester.pumpWidget(
                wrapWithApp(
                  Material(
                    child: MainClothView(
                      cloth: cloth1,
                      editing: true,
                    ),
                  ),
                ),
              );
              // assert
              expect(find.byType(FloatingActionButton), findsNothing);
            },
          );
          testWidgets(
            'should add ChangeFavourite event '
            'on AppBarFloatingActionButton pressed',
            (tester) async {
              // arrange
              setLongScreen(tester);
              await tester.pumpWidget(
                wrapWithBloc(
                  Material(
                    child: MainClothView(
                      cloth: cloth1,
                    ),
                  ),
                ),
              );
              // act
              await tester.tap(find.byType(AppBarFloatingActionButton));
              // assert
              verify(
                () => mockEditClothBloc.add(
                  ChangeFavourite(favourite: !cloth1.favourite),
                ),
              ).called(1);
            },
          );
        },
      );

      group(
        'Show top ImageShadow',
        () {
          testWidgets(
            'should show top shadow with overrideSystemUiOverlayStyle '
            'when cloth is null',
            (tester) async {
              // arrange
              await tester.pumpWidget(
                wrapWithApp(
                  const Material(
                    child: MainClothView(),
                  ),
                ),
              );
              // assert
              final finder = find.byKey(Keys.editClothTopShadow);
              final imageShadow = tester.widget<ImageShadow>(finder);
              expect(imageShadow.side, equals(ShadowSide.top));
              expect(imageShadow.overrideSystemUiOverlayStyle, isTrue);
            },
          );
          testWidgets(
            'should show top shadow with overrideSystemUiOverlayStyle '
            'when cloth is not null',
            (tester) async {
              // arrange
              await tester.pumpWidget(
                wrapWithApp(
                  Material(
                    child: MainClothView(
                      cloth: clothWithoutName,
                    ),
                  ),
                ),
              );
              // assert
              final finder = find.byKey(Keys.editClothTopShadow);
              final imageShadow = tester.widget<ImageShadow>(finder);
              expect(imageShadow.side, equals(ShadowSide.top));
              expect(imageShadow.overrideSystemUiOverlayStyle, isTrue);
            },
          );
          testWidgets(
            'should not show top shadow when editing is true',
            (tester) async {
              // arrange
              await tester.pumpWidget(
                wrapWithApp(
                  Material(
                    child: MainClothView(
                      cloth: clothWithoutName,
                      editing: true,
                    ),
                  ),
                ),
              );
              // assert
              expect(find.byKey(Keys.editClothTopShadow), findsNothing);
            },
          );
        },
      );

      group(
        'Show AppBarBackButton',
        () {
          testWidgets(
            'should show AppBarBackButton when editing is false',
            (tester) async {
              // arrange
              await tester.pumpWidget(
                wrapWithApp(
                  MainClothView(
                    cloth: cloth1,
                  ),
                ),
              );
              // assert
              expect(find.byType(AppBarBackButton), findsOneWidget);
            },
          );
          testWidgets(
            'should not show AppBarBackButton when editing is true',
            (tester) async {
              // arrange
              await tester.pumpWidget(
                wrapWithApp(
                  const MainClothView(
                    editing: true,
                  ),
                ),
              );
              // assert
              expect(find.byType(AppBarBackButton), findsNothing);
            },
          );
        },
      );

      group(
        'Show AppBarEditButton',
        () {
          testWidgets(
            'should show AppBarEditButton when editing is false '
            'and cloth is not null',
            (tester) async {
              // arrange
              await tester.pumpWidget(
                wrapWithApp(
                  MainClothView(
                    cloth: cloth1,
                  ),
                ),
              );
              // assert
              expect(find.byType(AppBarEditButton), findsOneWidget);
            },
          );
          testWidgets(
            'should not show AppBarEditButton when editing is false '
            'and cloth is null',
            (tester) async {
              // arrange
              await tester.pumpWidget(
                wrapWithApp(
                  const MainClothView(),
                ),
              );
              // assert
              expect(find.byType(AppBarEditButton), findsNothing);
            },
          );
          testWidgets(
            'should not show AppBarEditButton when editing is true',
            (tester) async {
              // arrange
              await tester.pumpWidget(
                wrapWithApp(
                  const MainClothView(
                    editing: true,
                  ),
                ),
              );
              // assert
              expect(find.byType(AppBarEditButton), findsNothing);
            },
          );
        },
      );

      group(
        'Show AppBarSaveButton',
        () {
          testWidgets(
            'should show AppBarSaveButton when editing is true',
            (tester) async {
              // arrange
              await tester.pumpWidget(
                wrapWithApp(
                  Material(
                    child: MainClothView(
                      cloth: cloth1,
                      editing: true,
                    ),
                  ),
                ),
              );
              // assert
              expect(find.byType(AppBarSaveButton), findsOneWidget);
            },
          );
          testWidgets(
            'should not show AppBarSaveButton when editing is false',
            (tester) async {
              // arrange
              await tester.pumpWidget(
                wrapWithApp(
                  const MainClothView(),
                ),
              );
              // assert
              expect(find.byType(AppBarSaveButton), findsNothing);
            },
          );
        },
      );
    },
  );

  group(
    'AppBarBackButton',
    () {
      testWidgets(
        'should show BackButton',
        (tester) async {
          // arrange
          await tester.pumpWidget(
            wrapWithApp(
              const AppBarBackButton(),
            ),
          );
          // assert
          expect(find.byType(BackButton), findsOneWidget);
        },
      );
      testWidgets(
        'should add CloseCloth event on BackButton pressed',
        (tester) async {
          // arrange
          await tester.pumpWidget(
            wrapWithBloc(
              const AppBarBackButton(),
            ),
          );
          // act
          await tester.tap(find.byType(BackButton));
          // assert
          verify(() => mockEditClothBloc.add(CloseCloth())).called(1);
        },
      );
    },
  );

  group(
    'AppBarEditButton',
    () {
      testWidgets(
        'should show edit button',
        (tester) async {
          // arrange
          await tester.pumpWidget(
            wrapWithApp(
              const AppBarEditButton(),
            ),
          );
          // assert
          expect(find.byKey(Keys.editClothButton), findsOneWidget);
        },
      );
      testWidgets(
        'should add EditCloth event on IconButton pressed',
        (tester) async {
          // arrange
          await tester.pumpWidget(
            wrapWithBloc(
              const AppBarEditButton(),
            ),
          );
          // act
          await tester.tap(find.byType(IconButton));
          // assert
          verify(() => mockEditClothBloc.add(EditCloth())).called(1);
        },
      );
    },
  );

  group(
    'AppBarSaveButton',
    () {
      testWidgets(
        'should show save button',
        (tester) async {
          // arrange
          await tester.pumpWidget(
            wrapWithApp(
              const AppBarSaveButton(),
            ),
          );
          // assert
          expect(find.byKey(Keys.saveClothButton), findsOneWidget);
        },
      );
      testWidgets(
        'should add SaveCloth event on IconButton pressed',
        (tester) async {
          // arrange
          await tester.pumpWidget(
            wrapWithBloc(
              const AppBarSaveButton(),
            ),
          );
          // act
          await tester.tap(find.byType(IconButton));
          // assert
          verify(() => mockEditClothBloc.add(SaveCloth())).called(1);
        },
      );
    },
  );

  group(
    'ImagesView',
    () {
      testWidgets(
        'should show image icon when images is null and editing is false',
        (tester) async {
          // arrange
          await tester.pumpWidget(
            wrapWithApp(
              const ImagesView(),
            ),
          );
          // assert
          final finder = find.byType(Icon);
          final icon = tester.widget<Icon>(finder);
          expect(icon.icon, equals(Icons.image));
        },
      );
      testWidgets(
        'should show ImagesMainView with images '
        'when images is not null and editing is false',
        (tester) async {
          // arrange
          await tester.pumpWidget(
            wrapWithApp(
              const ImagesView(
                images: clothImages1,
              ),
            ),
          );
          // assert
          final finder = find.byType(ImagesMainView);
          final imagesMainView = tester.widget<ImagesMainView>(finder);
          expect(imagesMainView.images, equals(clothImages1));
        },
      );
      testWidgets(
        'should show ImagesEditableView with images '
        'when images is not null and editing is true',
        (tester) async {
          // arrange
          await tester.pumpWidget(
            wrapWithApp(
              const ImagesView(
                images: clothImages1,
                editing: true,
              ),
            ),
          );
          // assert
          final finder = find.byType(ImagesEditableView);
          final imagesEditableView = tester.widget<ImagesEditableView>(finder);
          expect(imagesEditableView.images, equals(clothImages1));
        },
      );
    },
  );

  group(
    'ImagesMainView',
    () {
      testWidgets(
        'should show CarouselSlider with all images',
        (tester) async {
          // arrange
          await tester.pumpWidget(
            wrapWithApp(
              const ImagesMainView(
                images: clothImages1,
              ),
            ),
          );
          // assert
          final finder = find.byType(CarouselSlider);
          final carouselSlider = tester.widget<CarouselSlider>(finder);
          expect(carouselSlider.itemCount, equals(clothImages1.length));
        },
      );
      testWidgets(
        'should show ClothImageView with first image',
        (tester) async {
          // arrange
          await tester.pumpWidget(
            wrapWithApp(
              const ImagesMainView(
                images: clothImages1,
              ),
            ),
          );
          // assert
          final finder = find.byType(ClothImageView);
          final clothImageView = tester.widget<ClothImageView>(finder);
          expect(clothImageView.image, equals(clothImages1.first));
        },
      );
    },
  );

  group(
    'ImagesEditableView',
    () {
      testWidgets(
        'should show ClothImageViews for each image',
        (tester) async {
          // arrange
          await tester.pumpWidget(
            wrapWithApp(
              const ImagesEditableView(
                images: clothImages1,
              ),
            ),
          );
          // assert
          final finder = find.byType(ClothImageView);
          final clothImageViews =
              tester.widgetList<ClothImageView>(finder).toList();
          for (int i = 0; i < clothImageViews.length; i++) {
            expect(clothImageViews[i].image, equals(clothImages1[i]));
          }
        },
      );

      testWidgets(
        'should show AddImageView',
        (tester) async {
          // arrange
          await tester.pumpWidget(
            wrapWithApp(
              const ImagesEditableView(
                images: clothImages1,
              ),
            ),
          );
          // assert
          expect(find.byType(AddImageView), findsOneWidget);
        },
      );
    },
  );

  group(
    'EditableImageView',
    () {
      testWidgets(
        'should show ClothImageView wrapped with ClipRRect',
        (tester) async {
          // arrange
          await tester.pumpWidget(
            wrapWithApp(
              const EditableImageView(
                image: clothImage1,
              ),
            ),
          );
          // assert
          expect(
            find.descendant(
              of: find.byType(ClipRRect),
              matching: find.byType(ClothImageView),
            ),
            findsOneWidget,
          );
        },
      );
      testWidgets(
        'should show RawMaterialButton wrapped with Positioned',
        (tester) async {
          // arrange
          await tester.pumpWidget(
            wrapWithApp(
              const EditableImageView(
                image: clothImage1,
              ),
            ),
          );
          // assert
          expect(
            find.descendant(
              of: find.byType(Positioned),
              matching: find.byType(RawMaterialButton),
            ),
            findsOneWidget,
          );
        },
      );
    },
  );

  group(
    'AddImageView',
    () {
      testWidgets(
        'should show center Icon',
        (tester) async {
          // arrange
          await tester.pumpWidget(
            wrapWithApp(
              const AddImageView(),
            ),
          );
          // assert
          expect(
            find.descendant(
              of: find.byType(Center),
              matching: find.byType(Icon),
            ),
            findsOneWidget,
          );
        },
      );
    },
  );

  group(
    'NameMainView',
    () {
      testWidgets(
        'should wrap with IgnorePointer when name is not null',
        (tester) async {
          // arrange
          const name = 'Cloth name';
          await tester.pumpWidget(
            wrapWithApp(
              const NameMainView(name: name),
            ),
          );
          // assert
          expect(
            find.descendant(
              of: find.byType(NameMainView),
              matching: find.byType(IgnorePointer),
            ),
            findsOneWidget,
          );
        },
      );
      testWidgets(
        'should show Text with name when it is not null',
        (tester) async {
          // arrange
          const name = 'Cloth name';
          await tester.pumpWidget(
            wrapWithApp(
              const NameMainView(name: name),
            ),
          );
          // assert
          expect(find.text(name), findsOneWidget);
        },
      );
      testWidgets(
        'should show RoundedContainer with fixed width and height '
        'when name is null',
        (tester) async {
          // arrange
          await tester.pumpWidget(
            wrapWithApp(
              const NameMainView(),
            ),
          );
          // assert
          final finder = find.byType(RoundedContainer);
          final roundedContainer = tester.widget<RoundedContainer>(finder);
          expect(roundedContainer.width, isNotNull);
          expect(roundedContainer.height, isNotNull);
        },
      );
    },
  );

  group(
    'NameEditableView',
    () {
      testWidgets(
        'should show enabled TextFormField when enabled is true',
        (tester) async {
          // arrange
          const name = 'Cloth name';
          await tester.pumpWidget(
            wrapWithApp(
              const Material(
                child: NameEditableView(name: name),
              ),
            ),
          );
          // assert
          final finder = find.byType(TextFormField);
          final textFormField = tester.widget<TextFormField>(finder);
          expect(textFormField.enabled, isTrue);
        },
      );
      testWidgets(
        'should show disabled TextFormField when enabled is false',
        (tester) async {
          // arrange
          const name = 'Cloth name';
          await tester.pumpWidget(
            wrapWithApp(
              const Material(
                child: NameEditableView(
                  enabled: false,
                  name: name,
                ),
              ),
            ),
          );
          // assert
          final finder = find.byType(TextFormField);
          final textFormField = tester.widget<TextFormField>(finder);
          expect(textFormField.enabled, isFalse);
        },
      );

      testWidgets(
        'should add UpdateClothName event with new name when text changed',
        (tester) async {
          // arrange
          const name = 'Cloth name';
          const newName = 'New cloth name';
          await tester.pumpWidget(
            wrapWithBloc(
              const Material(
                child: NameEditableView(
                  name: name,
                ),
              ),
            ),
          );
          // act
          await tester.enterText(find.byType(TextFormField), newName);
          // assert
          verify(
            () => mockEditClothBloc.add(
              const UpdateClothName(name: newName),
            ),
          ).called(1);
        },
      );
    },
  );

  group(
    'DescriptionView',
    () {
      testWidgets(
        'should show Text with description when it is not null',
        (tester) async {
          // arrange
          const description = 'Cloth description';
          await tester.pumpWidget(
            wrapWithApp(
              const DescriptionView(description: description),
            ),
          );
          // assert
          expect(find.text(description), findsOneWidget);
        },
      );
      testWidgets(
        'should show 2 RoundedContainers with fixed width and height '
        'when description is null',
        (tester) async {
          // arrange
          await tester.pumpWidget(
            wrapWithApp(
              const DescriptionView(),
            ),
          );
          // assert
          final finder = find.byType(RoundedContainer);
          final roundedContainers = tester.widgetList<RoundedContainer>(finder);
          expect(roundedContainers.length, equals(2));
          expect(roundedContainers.first.width, isNotNull);
          expect(roundedContainers.first.height, isNotNull);
          expect(roundedContainers.last.width, isNotNull);
          expect(roundedContainers.last.height, isNotNull);
        },
      );
      testWidgets(
        'should show empty Container when description is empty',
        (tester) async {
          // arrange
          await tester.pumpWidget(
            wrapWithApp(
              const DescriptionView(description: ''),
            ),
          );
          // assert
          final finder = find.descendant(
            of: find.byType(DescriptionView),
            matching: find.byType(Container),
          );
          final container = tester.widget<Container>(finder);
          expect(container.child, isNull);
        },
      );
    },
  );

  group(
    'TagsView',
    () {
      const title = 'Tags title';
      const tags = [
        ClothTag(
          id: 0,
          name: 'Tag 1',
          type: ClothTagType.clothKind,
        ),
        ClothTag(
          id: 0,
          name: 'Tag 2',
          type: ClothTagType.clothKind,
        ),
        ClothTag(
          id: 0,
          name: 'Tag 3',
          type: ClothTagType.color,
        ),
        ClothTag(
          id: 0,
          name: 'Tag 4',
          type: ClothTagType.color,
        ),
        ClothTag(
          id: 0,
          name: 'Tag 5',
          type: ClothTagType.other,
        ),
        ClothTag(
          id: 0,
          name: 'Tag 6',
          type: ClothTagType.other,
        ),
      ];

      testWidgets(
        'should show title and tags filtered by type '
        'when tags variable is not null',
        (tester) async {
          // arrange
          await tester.pumpWidget(
            wrapWithApp(
              const Material(
                child: TagsView(
                  title: title,
                  tagType: ClothTagType.clothKind,
                  tags: tags,
                ),
              ),
            ),
          );
          // assert
          expect(find.text(title), findsOneWidget);
          expect(find.byType(TagView), findsNWidgets(2));
          expect(find.text('Tag 1'), findsOneWidget);
          expect(find.text('Tag 2'), findsOneWidget);
        },
      );
      testWidgets(
        'should show 2 RoundedContainers with fixed width and height '
        'when tags variable is null',
        (tester) async {
          // arrange
          await tester.pumpWidget(
            wrapWithApp(
              const Material(
                child: TagsView(
                  title: title,
                  tagType: ClothTagType.clothKind,
                  tags: null,
                ),
              ),
            ),
          );
          // assert
          final finder = find.byType(RoundedContainer);
          final roundedContainers = tester.widgetList<RoundedContainer>(finder);
          expect(roundedContainers.length, equals(2));
          expect(roundedContainers.first.width, isNotNull);
          expect(roundedContainers.first.height, isNotNull);
          expect(roundedContainers.last.width, isNotNull);
          expect(roundedContainers.last.height, isNotNull);
        },
      );

      testWidgets(
        'should show empty Container when tags list is empty',
        (tester) async {
          // arrange
          await tester.pumpWidget(
            wrapWithApp(
              const Material(
                child: TagsView(
                  title: title,
                  tagType: ClothTagType.clothKind,
                  tags: [],
                ),
              ),
            ),
          );
          // assert
          final finder = find.descendant(
            of: find.byType(TagsView),
            matching: find.byType(Container),
          );
          final container = tester.widget<Container>(finder);
          expect(container.child, isNull);
        },
      );
    },
  );

  group(
    'CreationDateView',
    () {
      testWidgets(
        'should show text with specified date and time '
        'when creation date is not null',
        (tester) async {
          // arrange
          final creationDate = cloth1.creationDate;
          await tester.pumpWidget(
            wrapWithApp(
              CreationDateView(
                creationDate: creationDate,
              ),
            ),
          );
          // assert
          final dateFormat = DateFormat.yMd();
          final timeFormat = DateFormat.Hms();
          expect(
            find.textContaining(dateFormat.format(creationDate)),
            findsOneWidget,
          );
          expect(
            find.textContaining(timeFormat.format(creationDate)),
            findsOneWidget,
          );
        },
      );
      testWidgets(
        'should show empty Container when creation date is null',
        (tester) async {
          // arrange
          await tester.pumpWidget(
            wrapWithApp(
              const CreationDateView(),
            ),
          );
          // assert
          final finder = find.descendant(
            of: find.byType(CreationDateView),
            matching: find.byType(Container),
          );
          final container = tester.widget<Container>(finder);
          expect(container.child, isNull);
        },
      );
    },
  );
}
