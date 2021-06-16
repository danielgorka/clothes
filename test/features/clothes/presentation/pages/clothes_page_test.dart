import 'package:bloc_test/bloc_test.dart';
import 'package:clothes/features/clothes/domain/entities/cloth.dart';
import 'package:clothes/features/clothes/presentation/blocs/clothes/clothes_bloc.dart';
import 'package:clothes/features/clothes/presentation/pages/clothes_page.dart';
import 'package:clothes/features/clothes/presentation/widgets/cloth_item.dart';
import 'package:clothes/features/clothes/presentation/widgets/empty_view.dart';
import 'package:clothes/features/clothes/presentation/widgets/error_view.dart';
import 'package:clothes/features/clothes/presentation/widgets/shimmer.dart';
import 'package:clothes/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/app_wrapper.dart';

class MockGetIt extends Mock implements GetIt {}

class MockClothesBloc extends MockBloc<ClothesEvent, ClothesState>
    implements ClothesBloc {}

class UnknownClothesState extends ClothesState {}

void main() {
  group(
    'ClothesPage',
    () {
      late MockClothesBloc mockClothesBloc;
      late MockGetIt mockGetIt;

      setUpAll(() {
        registerFallbackValue<ClothesEvent>(LoadClothes());
        registerFallbackValue<ClothesState>(Loading());
      });

      setUp(() async {
        mockClothesBloc = MockClothesBloc();
        mockGetIt = MockGetIt();
        await configureDependencies(
          get: mockGetIt,
          initGetIt: (getIt) async {},
        );
        when(() => getIt<ClothesBloc>()).thenAnswer((_) => mockClothesBloc);
        when(() => mockClothesBloc.state).thenAnswer((_) => Loading());
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
          verify(() => getIt<ClothesBloc>()).called(1);
          verify(() => mockClothesBloc.add(LoadClothes())).called(1);
        },
      );
    },
  );

  group(
    'ClothesView',
    () {
      late MockClothesBloc mockClothesBloc;

      setUpAll(() {
        registerFallbackValue<ClothesEvent>(LoadClothes());
        registerFallbackValue<ClothesState>(Loading());
      });

      setUp(() async {
        mockClothesBloc = MockClothesBloc();
      });

      Widget wrap(Widget widget) {
        return wrapWithApp(
          BlocProvider<ClothesBloc>.value(
            value: mockClothesBloc,
            child: Builder(builder: (context) {
              return widget;
            }),
          ),
        );
      }

      testWidgets(
        'should show LoadingView when state is Loading',
        (tester) async {
          // arrange
          when(() => mockClothesBloc.state).thenAnswer((_) => Loading());
          await tester.pumpWidget(wrap(const ClothesView()));
          // assert
          expect(find.byType(ClothesLoadingView), findsOneWidget);
        },
      );
      testWidgets(
        'should show ErrorView when state is LoadError',
        (tester) async {
          // arrange
          when(() => mockClothesBloc.state).thenAnswer((_) => LoadError());
          await tester.pumpWidget(wrap(const ClothesView()));

          // assert
          expect(find.byType(ErrorView), findsOneWidget);
        },
      );
      testWidgets(
        'should show EmptyView when state is Loaded and clothes is empty',
        (tester) async {
          // arrange
          when(() => mockClothesBloc.state)
              .thenAnswer((_) => const Loaded(clothes: []));
          await tester.pumpWidget(wrap(const ClothesView()));
          // assert
          expect(find.byType(EmptyView), findsOneWidget);
        },
      );
      testWidgets(
        'should show ClothesView when state is Loaded and clothes is not empty',
        (tester) async {
          // arrange
          final clothes = [
            Cloth(id: 0, creationDate: DateTime.now()),
            Cloth(id: 1, creationDate: DateTime.now()),
            Cloth(id: 2, creationDate: DateTime.now()),
          ];
          when(() => mockClothesBloc.state)
              .thenAnswer((_) => Loaded(clothes: clothes));
          await tester.pumpWidget(wrap(const ClothesView()));
          // assert
          final finder = find.byType(ClothesGridView);
          final clothesView = tester.widget<ClothesGridView>(finder);
          expect(clothesView.clothes, clothes);
        },
      );
      testWidgets(
        'should throw StateError when state is unknown',
        (tester) async {
          when(() => mockClothesBloc.state)
              .thenAnswer((_) => UnknownClothesState());
          // arrange
          await tester.pumpWidget(wrap(const ClothesView()));
          // assert
          expect(tester.takeException(), isInstanceOf<StateError>());
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
          final clothes = [
            Cloth(id: 0, creationDate: DateTime.now()),
            Cloth(id: 1, creationDate: DateTime.now()),
            Cloth(id: 2, creationDate: DateTime.now()),
          ];
          await tester.pumpWidget(wrapWithApp(
            ClothesGridView(clothes: clothes),
          ));
          // assert
          final finder = find.byType(GridView);
          final gridView = tester.widget<GridView>(finder);
          final childrenDelegate =
              gridView.childrenDelegate as SliverChildBuilderDelegate;
          expect(childrenDelegate.childCount, equals(clothes.length));
        },
      );
      testWidgets(
        'should show ClothItem with first cloth',
        (tester) async {
          // arrange
          final clothes = [Cloth(id: 0, creationDate: DateTime.now())];
          await tester.pumpWidget(wrapWithApp(
            ClothesGridView(clothes: clothes),
          ));
          // assert
          final finder = find.byType(ClothItem);
          final clothItem = tester.widget<ClothItem>(finder);
          expect(clothItem.cloth, equals(clothes.first));
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
          expect(find.byType(Shimmer), findsOneWidget);
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
