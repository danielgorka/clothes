import 'dart:async';
import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:clothes/app/routes/router.gr.dart';
import 'package:clothes/app/utils/keys.dart';
import 'package:clothes/features/clothes/domain/entities/cloth.dart';
import 'package:clothes/features/clothes/domain/use_cases/add_cloth_image.dart';
import 'package:clothes/features/clothes/domain/use_cases/create_cloth.dart';
import 'package:clothes/features/clothes/domain/use_cases/get_clothes.dart';
import 'package:clothes/features/clothes/presentation/blocs/clothes/clothes_bloc.dart';
import 'package:clothes/features/clothes/presentation/blocs/edit_image/edit_image_bloc.dart'
    hide PickImage;
import 'package:clothes/features/clothes/presentation/pages/clothes_page.dart';
import 'package:clothes/features/clothes/presentation/widgets/app_shimmer.dart';
import 'package:clothes/features/clothes/presentation/widgets/cloth_item.dart';
import 'package:clothes/features/clothes/presentation/widgets/empty_view.dart';
import 'package:clothes/features/clothes/presentation/widgets/error_view.dart';
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

class MockGetClothes extends Mock implements GetClothes {}

class MockCreateCloth extends Mock implements CreateCloth {}

class MockAddClothImage extends Mock implements AddClothImage {}

class MockStackRouter extends Mock implements StackRouter {}

class MockClothesBloc extends MockBloc<ClothesEvent, ClothesState>
    implements ClothesBloc {}

class UnknownClothesState extends ClothesState {}

class MockClothesEvent extends ClothesEvent {}

class MockClothesState extends ClothesState {}

void main() {
  setUpAll(() {
    registerFallbackValue<ClothesEvent>(MockClothesEvent());
    registerFallbackValue<ClothesState>(MockClothesState());
  });

  group(
    'ClothesPage',
    () {
      late MockClothesBloc mockClothesBloc;
      late MockGetIt mockGetIt;

      setUp(() async {
        mockClothesBloc = MockClothesBloc();
        mockGetIt = MockGetIt();
        await configureDependencies(
          get: mockGetIt,
          initGetIt: (getIt) async {},
        );
        when(() => mockGetIt<ClothesBloc>()).thenAnswer((_) => mockClothesBloc);
        when(() => mockClothesBloc.state)
            .thenAnswer((_) => const ClothesState());
      });

      testWidgets(
        'should show ClothesView',
        (tester) async {
          // arrange
          await tester.pumpWidget(wrapWithApp(const ClothesPage()));
          // assert
          expect(find.byType(ClothesView), findsOneWidget);
        },
      );
      testWidgets(
        'should add LoadClothes event to bloc after create',
        (tester) async {
          // arrange
          await tester.pumpWidget(wrapWithApp(const ClothesPage()));
          // assert
          final BuildContext context = tester.element(find.byType(ClothesView));
          expect(
            BlocProvider.of<ClothesBloc>(context),
            equals(mockClothesBloc),
          );
          verify(() => mockGetIt<ClothesBloc>()).called(1);
          verify(() => mockClothesBloc.add(LoadClothes())).called(1);
        },
      );
    },
  );

  group(
    'ClothesView',
    () {
      late MockClothesBloc mockClothesBloc;

      setUp(() async {
        mockClothesBloc = MockClothesBloc();
      });

      const source = ImagePickerSource.gallery;

      Widget wrapWithBloc(Widget widget, {ClothesBloc? bloc}) {
        return wrapWithApp(
          BlocProvider<ClothesBloc>.value(
            value: bloc ?? mockClothesBloc,
            child: Builder(
              builder: (context) {
                return widget;
              },
            ),
          ),
        );
      }

      group(
        'State statuses',
        () {
          testWidgets(
            'should show LoadingView when state status is loading',
            (tester) async {
              // arrange
              when(() => mockClothesBloc.state)
                  .thenAnswer((_) => const ClothesState());
              await tester.pumpWidget(wrapWithBloc(const ClothesView()));
              // assert
              expect(find.byType(ClothesLoadingView), findsOneWidget);
            },
          );
          testWidgets(
            'should show ErrorView when state status is error',
            (tester) async {
              // arrange
              when(() => mockClothesBloc.state).thenAnswer(
                (_) => const ClothesState(status: ClothesStatus.error),
              );
              await tester.pumpWidget(wrapWithBloc(const ClothesView()));

              // assert
              expect(find.byType(ErrorView), findsOneWidget);
            },
          );
          testWidgets(
            'should show EmptyView when state status is Loaded '
            'and clothes is empty',
            (tester) async {
              // arrange
              when(() => mockClothesBloc.state).thenAnswer(
                (_) => const ClothesState(status: ClothesStatus.loaded),
              );
              await tester.pumpWidget(wrapWithBloc(const ClothesView()));
              // assert
              expect(find.byType(EmptyView), findsOneWidget);
            },
          );
          testWidgets(
            'should show ClothesView when state status is loaded '
            'and clothes is not empty',
            (tester) async {
              // arrange
              when(() => mockClothesBloc.state).thenAnswer(
                (_) => ClothesState(
                  status: ClothesStatus.loaded,
                  clothes: clothes1,
                ),
              );
              await tester.pumpWidget(wrapWithBloc(const ClothesView()));
              // assert
              final finder = find.byType(ClothesGridView);
              final clothesView = tester.widget<ClothesGridView>(finder);
              expect(clothesView.clothes, clothes1);
            },
          );
        },
      );

      group(
        'Create cloth actions',
        () {
          testWidgets(
            'should add CreateEmptyCloth event when tap without image action',
            (tester) async {
              // arrange
              when(() => mockClothesBloc.state).thenAnswer(
                (_) => ClothesState(
                  status: ClothesStatus.loaded,
                  clothes: clothes1,
                ),
              );
              await tester.pumpWidget(wrapWithBloc(const ClothesView()));
              // act
              await tester.tap(find.byType(FloatingActionButton));
              await tester.pump();
              await tester.tap(find.byKey(Keys.createClothWithoutImageAction));
              // assert
              verify(() => mockClothesBloc.add(CreateEmptyCloth())).called(1);
            },
          );
          testWidgets(
            'should add PickImage event with camera source when tap '
            'take image action',
            (tester) async {
              // arrange
              when(() => mockClothesBloc.state).thenAnswer(
                (_) => ClothesState(
                  status: ClothesStatus.loaded,
                  clothes: clothes1,
                ),
              );
              await tester.pumpWidget(wrapWithBloc(const ClothesView()));
              // act
              await tester.tap(find.byType(FloatingActionButton));
              await tester.pump();
              await tester.tap(find.byKey(Keys.createClothTakeImageAction));
              // assert
              verify(
                () => mockClothesBloc.add(
                  const PickImage(source: ImagePickerSource.camera),
                ),
              ).called(1);
            },
          );
          testWidgets(
            'should add PickImage event with gallery source when tap '
            'pick from gallery action',
            (tester) async {
              // arrange
              when(() => mockClothesBloc.state).thenAnswer(
                (_) => ClothesState(
                  status: ClothesStatus.loaded,
                  clothes: clothes1,
                ),
              );
              await tester.pumpWidget(wrapWithBloc(const ClothesView()));
              // act
              await tester.tap(find.byType(FloatingActionButton));
              await tester.pump();
              await tester
                  .tap(find.byKey(Keys.createClothPickFromGalleryAction));
              // assert
              verify(
                () => mockClothesBloc.add(
                  const PickImage(source: ImagePickerSource.gallery),
                ),
              ).called(1);
            },
          );
        },
      );

      group(
        'Open cloth action',
        () {
          testWidgets(
            'should add ShowCloth event with cloth id when tap cloth item',
            (tester) async {
              // arrange
              when(() => mockClothesBloc.state).thenAnswer(
                (_) => ClothesState(
                  status: ClothesStatus.loaded,
                  clothes: [cloth1],
                ),
              );
              await tester.pumpWidget(wrapWithBloc(const ClothesView()));
              // act
              await tester.tap(find.byType(ClothItem));
              // assert
              verify(
                () => mockClothesBloc.add(ShowCloth(clothId: cloth1.id)),
              ).called(1);
            },
          );
        },
      );

      group(
        'Listener',
        () {
          Future<void> shouldPushAndAddEvent({
            required WidgetTester tester,
            required ClothesEvent event,
            required PageRouteInfo route,
            dynamic pushResult,
            required List<ClothesState> states,
          }) async {
            final mockStackRouter = MockStackRouter();
            when(() => mockStackRouter.push(route))
                .thenAnswer((_) => Future.value(pushResult));

            await testListener(
              tester: tester,
              mockBloc: mockClothesBloc,
              pumpWidget: () async {
                await tester.pumpWidget(
                  StackRouterScope(
                    segmentsHash: 0,
                    controller: mockStackRouter,
                    child: wrapWithBloc(
                      const ClothesView(),
                    ),
                  ),
                );
              },
              verifyAction: () {
                mockClothesBloc.add(event);
              },
              states: states,
            );
            verify(() => mockStackRouter.push(route)).called(1);
          }

          group(
            'PickImageAction',
            () {
              const pickImageState = ClothesState(
                action: PickImageAction(source: source),
              );

              testWidgets(
                'should push EditImageRoute when state action changes to '
                'PickImageAction and add ImagePicked event when '
                'returned data is not null ',
                (tester) async {
                  final image = Uint8List.fromList([1, 2, 3, 4]);
                  await shouldPushAndAddEvent(
                    tester: tester,
                    event: ImagePicked(image: image),
                    route: EditImageRoute(source: source),
                    pushResult: image,
                    states: [const ClothesState(), pickImageState],
                  );
                },
              );
              testWidgets(
                'should push EditImageRoute when state action changes to '
                'PickImageAction and add ClearAction event when '
                'returned data is null ',
                (tester) async {
                  await shouldPushAndAddEvent(
                    tester: tester,
                    event: ClearAction(),
                    route: EditImageRoute(source: source),
                    states: [const ClothesState(), pickImageState],
                  );
                },
              );
              testWidgets(
                'should push EditImageRoute ones when state action changes to '
                'PickImageAction two in a row',
                (tester) async {
                  final state2 = pickImageState.copyWith(
                    status: ClothesStatus.loaded,
                  );

                  await shouldPushAndAddEvent(
                    tester: tester,
                    event: ClearAction(),
                    route: EditImageRoute(source: source),
                    states: [const ClothesState(), pickImageState, state2],
                  );
                },
              );
            },
          );

          group(
            'EditClothAction',
            () {
              const clothId = 2;
              const editClothState = ClothesState(
                action: EditClothAction(clothId: clothId),
              );

              testWidgets(
                'should push EditClothRoute with cloth id '
                'when state action changes to EditClothAction',
                (tester) async {
                  await shouldPushAndAddEvent(
                    tester: tester,
                    event: ClearAction(),
                    route: EditClothRoute(clothId: clothId),
                    states: [
                      const ClothesState(),
                      editClothState,
                    ],
                  );
                },
              );
              testWidgets(
                'should push EditClothRoute ones when state action changes to '
                'EditClothAction two in a row',
                (tester) async {
                  final state2 = editClothState.copyWith(
                    status: ClothesStatus.loaded,
                  );
                  await shouldPushAndAddEvent(
                    tester: tester,
                    event: ClearAction(),
                    route: EditClothRoute(clothId: clothId),
                    states: [
                      const ClothesState(),
                      editClothState,
                      state2,
                    ],
                  );
                },
              );
            },
          );
        },
      );
    },
  );

  group(
    'ClothesGridView',
    () {
      testWidgets(
        'should show GridView.builder with itemCount '
        'equal to clothes.length',
        (tester) async {
          // arrange
          await tester.pumpWidget(wrapWithApp(
            ClothesGridView(
              clothes: clothes1,
              onItemTap: (_) {},
            ),
          ));
          // assert
          final finder = find.byType(GridView);
          final gridView = tester.widget<GridView>(finder);
          final childrenDelegate =
              gridView.childrenDelegate as SliverChildBuilderDelegate;
          expect(childrenDelegate.childCount, equals(clothes1.length));
        },
      );
      testWidgets(
        'should show ClothItem with first cloth',
        (tester) async {
          // arrange
          final clothes = [Cloth(id: 0, creationDate: DateTime.now())];
          await tester.pumpWidget(wrapWithApp(
            ClothesGridView(
              clothes: clothes,
              onItemTap: (_) {},
            ),
          ));
          // assert
          final finder = find.byType(ClothItem);
          final clothItem = tester.widget<ClothItem>(finder);
          expect(clothItem.cloth, equals(clothes.first));
        },
      );
      testWidgets(
        'should call onItemTap with cloth id when item clicked',
        (tester) async {
          // arrange
          int? tapClothId;
          final clothes = [cloth1];
          await tester.pumpWidget(wrapWithApp(
            ClothesGridView(
              clothes: clothes,
              onItemTap: (clothId) {
                tapClothId = clothId;
              },
            ),
          ));
          // act
          await tester.tap(find.byType(ClothItem));
          // assert
          expect(tapClothId, equals(cloth1.id));
        },
      );
    },
  );

  group(
    'ClothesLoadingView',
    () {
      testWidgets(
        'should wrap widget with Shimmer',
        (tester) async {
          // arrange
          await tester.pumpWidget(wrapWithApp(
            const ClothesLoadingView(),
          ));
          // assert
          expect(find.byType(AppShimmer), findsOneWidget);
        },
      );
      testWidgets(
        'should show GridView.builder with unlimited itemCount',
        (tester) async {
          // arrange
          await tester.pumpWidget(wrapWithApp(
            const ClothesLoadingView(),
          ));
          // assert
          final finder = find.byType(GridView);
          final gridView = tester.widget<GridView>(finder);
          final childrenDelegate =
              gridView.childrenDelegate as SliverChildBuilderDelegate;
          expect(childrenDelegate.childCount, isNull);
        },
      );
      testWidgets(
        'should show ClothItems with empty clothes',
        (tester) async {
          // arrange
          final emptyId = Cloth.empty().id;
          await tester.pumpWidget(wrapWithApp(
            const ClothesLoadingView(),
          ));
          // assert
          final finder = find.byType(ClothItem);
          final clothItems = tester.widgetList<ClothItem>(finder);
          for (final clothItem in clothItems) {
            expect(clothItem.cloth.id, equals(emptyId));
          }
        },
      );
    },
  );
}
