import 'package:auto_route/auto_route.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:clothes/app/utils/keys.dart';
import 'package:clothes/features/clothes/presentation/blocs/edit_cloth/edit_cloth_bloc.dart';
import 'package:clothes/features/clothes/presentation/pages/edit_cloth_page.dart';
import 'package:clothes/features/clothes/presentation/widgets/app_shimmer.dart';
import 'package:clothes/features/clothes/presentation/widgets/cloth_image_view.dart';
import 'package:clothes/features/clothes/presentation/widgets/error_view.dart';
import 'package:clothes/features/clothes/presentation/widgets/image_shadow.dart';
import 'package:clothes/features/clothes/presentation/widgets/rounded_container.dart';
import 'package:clothes/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
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
            'should show ErrorView when state has error and no cloth',
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
              expect(find.byType(ErrorView), findsOneWidget);
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
        },
      );
    },
  );

  group(
    'MainClothView',
    () {
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
            'should show Stack with ImagesView, ImageShadow and NameView',
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
                  matching: find.byType(NameView),
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
            'Show ImageShadows',
            () {
              testWidgets(
                'should show top and bottom shadow when cloth is null',
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
                  final finder = find.byType(ImageShadow);
                  final imageShadows = tester.widgetList<ImageShadow>(finder);
                  expect(imageShadows.length, equals(2));
                  expect(imageShadows.first.side, equals(ShadowSide.top));
                  expect(imageShadows.last.side, equals(ShadowSide.bottom));
                },
              );
              testWidgets(
                'should show top and bottom shadow when cloth name is not empty',
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
                  final finder = find.byType(ImageShadow);
                  final imageShadows = tester.widgetList<ImageShadow>(finder);
                  expect(imageShadows.length, equals(2));
                  expect(imageShadows.first.side, equals(ShadowSide.top));
                  expect(imageShadows.last.side, equals(ShadowSide.bottom));
                },
              );
              testWidgets(
                'should show only top shadow when cloth name is empty',
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
                  final finder = find.byType(ImageShadow);
                  final imageShadow = tester.widget<ImageShadow>(finder);
                  expect(imageShadow.side, ShadowSide.top);
                },
              );
            },
          );

          group(
            'Show NameView',
            () {
              testWidgets(
                'should show NameView with name from cloth',
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
                  final finder = find.byType(NameView);
                  final nameView = tester.widget<NameView>(finder);
                  expect(nameView.name, equals(cloth1.name));
                },
              );
              testWidgets(
                'should show NameView with null name when cloth is null',
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
                  final finder = find.byType(NameView);
                  final nameView = tester.widget<NameView>(finder);
                  expect(nameView.name, isNull);
                },
              );
            },
          );
        },
      );

      //TODO

      group(
        'Show AppBarView',
        () {
          testWidgets(
            'should show AppBarView with editable set to true '
            'when cloth is not null',
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
              final finder = find.byType(AppBarView);
              final appBarView = tester.widget<AppBarView>(finder);
              expect(appBarView.editable, isTrue);
            },
          );
          testWidgets(
            'should show AppBarView with editable set to false '
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
              final finder = find.byType(AppBarView);
              final appBarView = tester.widget<AppBarView>(finder);
              expect(appBarView.editable, isFalse);
            },
          );
        },
      );
    },
  );

  group(
    'AppBarView',
    () {
      group(
        'Back button',
        () {
          testWidgets(
            'should show BackButton',
            (tester) async {
              // arrange
              await tester.pumpWidget(
                wrapWithApp(
                  const Material(
                    child: AppBarView(editable: false),
                  ),
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
                  const Material(
                    child: AppBarView(editable: false),
                  ),
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
        'Edit button',
        () {
          testWidgets(
            'should show edit button when editable is true',
            (tester) async {
              // arrange
              await tester.pumpWidget(
                wrapWithApp(
                  const Material(
                    child: AppBarView(editable: true),
                  ),
                ),
              );
              // assert
              expect(find.byKey(Keys.editClothButton), findsOneWidget);
            },
          );
          testWidgets(
            'should not show edit button when editable is false',
            (tester) async {
              // arrange
              await tester.pumpWidget(
                wrapWithApp(
                  const Material(
                    child: AppBarView(editable: false),
                  ),
                ),
              );
              // assert
              expect(find.byKey(Keys.editClothButton), findsNothing);
            },
          );
        },
      );
    },
  );

  group(
    'ImagesView',
    () {
      testWidgets(
        'should show CarouselSlider with all images when images is not null',
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
          final finder = find.byType(CarouselSlider);
          final carouselSlider = tester.widget<CarouselSlider>(finder);
          expect(carouselSlider.itemCount, equals(clothImages1.length));
        },
      );
      testWidgets(
        'should show ClothImageView with first image when images is not null',
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
          final finder = find.byType(ClothImageView);
          final clothImageView = tester.widget<ClothImageView>(finder);
          expect(clothImageView.image, equals(clothImages1.first));
        },
      );

      testWidgets(
        'should show image icon when images is null',
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
    },
  );

  group(
    'NameView',
    () {
      testWidgets(
        'should show Text with name when name is not null',
        (tester) async {
          // arrange
          const name = 'Cloth name';
          await tester.pumpWidget(
            wrapWithApp(
              const NameView(name: name),
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
              const NameView(),
            ),
          );
          // assert
          expect(find.byType(RoundedContainer), findsOneWidget);
        },
      );
    },
  );
}
