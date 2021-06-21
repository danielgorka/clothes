import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:clothes/core/error/failures.dart';
import 'package:clothes/core/use_cases/no_params.dart';
import 'package:clothes/features/clothes/domain/use_cases/get_clothes.dart';
import 'package:clothes/features/clothes/presentation/blocs/clothes/clothes_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/entities.dart';

class MockGetClothes extends Mock implements GetClothes {}

class TestableClothesBloc extends ClothesBloc {
  List<ClothesEvent> events = [];

  TestableClothesBloc({
    required GetClothes getClothes,
  }) : super(getClothes: getClothes);

  @override
  void onEvent(ClothesEvent event) {
    events.add(event);
    super.onEvent(event);
  }

  Future<void> waitUtilEvents({
    required int count,
    Duration timeout = const Duration(seconds: 1),
  }) async {
    await _waitUtilEvents(count: count).timeout(timeout);
  }

  Future<void> _waitUtilEvents({required int count}) async {
    while (count > events.length) {
      await Future.delayed(const Duration(milliseconds: 1));
    }
  }
}

void main() {
  group(
    'ClothesBloc',
    () {
      late TestableClothesBloc clothesBloc;
      late MockGetClothes mockGetClothes;

      setUp(() {
        mockGetClothes = MockGetClothes();
        clothesBloc = TestableClothesBloc(getClothes: mockGetClothes);
      });

      tearDown(() {
        clothesBloc.close();
      });

      test(
        'initial state should be Loading',
        () {
          // assert
          expect(clothesBloc.state, equals(Loading()));
        },
      );

      group(
        'LoadClothes',
        () {
          test(
            'should call GetClothes use case',
            () async {
              // arrange
              when(() => mockGetClothes(NoParams()))
                  .thenAnswer((_) => const Stream.empty());
              // act
              clothesBloc.add(LoadClothes());
              await untilCalled(() => mockGetClothes(NoParams()));
              // assert
              verify(() => mockGetClothes(NoParams())).called(1);
              verifyNoMoreInteractions(mockGetClothes);
            },
          );
          blocTest<ClothesBloc, ClothesState>(
            'should emit Loaded state with clothes list '
            'for each right event from stream',
            build: () {
              when(() => mockGetClothes(NoParams())).thenAnswer(
                (_) => Stream.fromIterable([
                  Right(clothes1),
                  Right(clothes2),
                ]),
              );
              return clothesBloc;
            },
            act: (bloc) {
              bloc.add(LoadClothes());
            },
            expect: () => <ClothesState>[
              Loaded(clothes: clothes1),
              Loaded(clothes: clothes2),
            ],
          );
          blocTest<ClothesBloc, ClothesState>(
            'should emit LoadError state when stream emits Failure',
            build: () {
              when(() => mockGetClothes(NoParams())).thenAnswer(
                (_) => Stream.fromIterable(
                  [Right(clothes1), Left(DatabaseFailure())],
                ),
              );
              return clothesBloc;
            },
            act: (bloc) {
              bloc.add(LoadClothes());
            },
            expect: () => <ClothesState>[
              Loaded(clothes: clothes1),
              LoadError(),
            ],
          );
        },
      );
    },
  );
}
