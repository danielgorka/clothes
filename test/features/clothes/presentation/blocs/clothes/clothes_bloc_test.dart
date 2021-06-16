import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:clothes/core/error/failures.dart';
import 'package:clothes/core/use_cases/no_params.dart';
import 'package:clothes/features/clothes/domain/entities/cloth.dart';
import 'package:clothes/features/clothes/domain/entities/cloth_image.dart';
import 'package:clothes/features/clothes/domain/entities/cloth_tag.dart';
import 'package:clothes/features/clothes/domain/use_cases/get_clothes.dart';
import 'package:clothes/features/clothes/presentation/blocs/clothes/clothes_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

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

      const tag = ClothTag(
        id: 1,
        type: ClothTagType.color,
        name: 'Red',
      );
      const image = ClothImage(
        id: 2,
        path: 'path/image.png',
      );
      final cloth = Cloth(
        id: 1,
        name: 'T-shirt',
        description: 'Too small',
        images: const [image],
        tags: const [tag],
        favourite: true,
        order: 2,
        creationDate: DateTime.now(),
      );

      final list1 = List.filled(4, cloth);
      final list2 = List.filled(5, cloth);

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
          test(
            'should add ClothesUpdated event with clothes list '
            'for each right event from stream',
            () async {
              // arrange
              when(() => mockGetClothes(NoParams())).thenAnswer(
                (_) => Stream.fromIterable([
                  Right(list1),
                  Right(list2),
                ]),
              );
              // act
              clothesBloc.add(LoadClothes());
              await clothesBloc.waitUtilEvents(count: 3);
              // assert
              expect(
                clothesBloc.events,
                equals([
                  LoadClothes(),
                  ClothesUpdated(clothes: list1),
                  ClothesUpdated(clothes: list2),
                ]),
              );
            },
          );
          test(
            'should add ClothesError event when stream emits Failure',
            () async {
              // arrange
              when(() => mockGetClothes(NoParams()))
                  .thenAnswer((_) => Stream.fromIterable(
                        [Right(list1), Left(DatabaseFailure())],
                      ));
              // act
              clothesBloc.add(LoadClothes());
              await clothesBloc.waitUtilEvents(count: 3);
              // assert
              expect(
                clothesBloc.events,
                equals([
                  LoadClothes(),
                  ClothesUpdated(clothes: list1),
                  ClothesError(),
                ]),
              );
            },
          );
        },
      );

      group(
        'ClothesUpdated',
        () {
          blocTest(
            'should emit Loaded state with clothes list',
            build: () => clothesBloc,
            act: (ClothesBloc bloc) =>
                bloc..add(ClothesUpdated(clothes: list1)),
            expect: () => [
              Loaded(clothes: list1),
            ],
          );
        },
      );

      group(
        'ClothesError',
        () {
          blocTest(
            'should emit LoadError state',
            build: () => clothesBloc,
            act: (ClothesBloc bloc) => bloc..add(ClothesError()),
            expect: () => [
              LoadError(),
            ],
          );
        },
      );
    },
  );
}