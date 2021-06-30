import 'dart:async';
import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:clothes/core/error/failures.dart';
import 'package:clothes/core/use_cases/no_params.dart';
import 'package:clothes/features/clothes/domain/entities/cloth.dart';
import 'package:clothes/features/clothes/domain/use_cases/add_cloth_image.dart';
import 'package:clothes/features/clothes/domain/use_cases/create_cloth.dart';
import 'package:clothes/features/clothes/domain/use_cases/get_clothes.dart';
import 'package:clothes/features/clothes/presentation/blocs/clothes/clothes_bloc.dart';
import 'package:clothes/features/clothes/presentation/blocs/edit_image/edit_image_bloc.dart'
    hide PickImage;
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/entities.dart';

class MockGetClothes extends Mock implements GetClothes {}

class MockCreateCloth extends Mock implements CreateCloth {}

class MockAddClothImage extends Mock implements AddClothImage {}

void main() {
  group(
    'ClothesBloc',
    () {
      late ClothesBloc clothesBloc;
      late MockGetClothes mockGetClothes;
      late MockCreateCloth mockCreateCloth;
      late MockAddClothImage mockAddClothImage;

      setUp(() {
        mockGetClothes = MockGetClothes();
        mockCreateCloth = MockCreateCloth();
        mockAddClothImage = MockAddClothImage();
        clothesBloc = ClothesBloc(
          getClothes: mockGetClothes,
          createCloth: mockCreateCloth,
          addClothImage: mockAddClothImage,
        );
      });

      tearDown(() {
        clothesBloc.close();
      });

      test(
        'initial state status should be loading',
        () {
          // assert
          expect(clothesBloc.state.status, equals(ClothesStatus.loading));
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
            'should emit state with status loaded and clothes list '
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
              ClothesState(status: ClothesStatus.loaded, clothes: clothes1),
              ClothesState(status: ClothesStatus.loaded, clothes: clothes2),
            ],
          );
          blocTest<ClothesBloc, ClothesState>(
            'should emit state with status error when stream emits Failure',
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
              ClothesState(status: ClothesStatus.loaded, clothes: clothes1),
              ClothesState(status: ClothesStatus.error, clothes: clothes1),
            ],
          );
        },
      );
      group(
        'ShowCloth',
        () {
          const clothId = 4;
          blocTest<ClothesBloc, ClothesState>(
            'should emit state with EditClothAction with correct cloth id',
            build: () {
              return clothesBloc;
            },
            act: (bloc) {
              bloc.add(const ShowCloth(clothId: clothId));
            },
            expect: () => <ClothesState>[
              const ClothesState(action: EditClothAction(clothId: clothId)),
            ],
          );
        },
      );

      group(
        'PickImage',
        () {
          const source = ImagePickerSource.gallery;
          blocTest<ClothesBloc, ClothesState>(
            'should emit state with PickImageAction with correct source',
            build: () {
              return clothesBloc;
            },
            act: (bloc) {
              bloc.add(const PickImage(source: source));
            },
            expect: () => <ClothesState>[
              const ClothesState(action: PickImageAction(source: source)),
            ],
          );
        },
      );

      group(
        'ImagePicked',
        () {
          const clothId = 1;
          final imageData = Uint8List.fromList([1, 2, 3, 4]);

          setUpAll(() {
            registerFallbackValue<CreateClothParams>(
              CreateClothParams(cloth: Cloth.empty()),
            );
            registerFallbackValue<AddClothImageParams>(
              AddClothImageParams(
                clothId: clothId,
                image: imageData,
              ),
            );
          });

          blocTest<ClothesBloc, ClothesState>(
            'should call CreateCloth use case and AddImage use case and '
            'emit state with EditClothAction with cloth id '
            'when use cases do not return Failures',
            build: () {
              when(() => mockCreateCloth(any()))
                  .thenAnswer((_) => Future.value(const Right(clothId)));
              when(() => mockAddClothImage(any()))
                  .thenAnswer((_) => Future.value(const Right(clothImage1)));

              return clothesBloc;
            },
            act: (bloc) {
              bloc.add(ImagePicked(image: imageData));
            },
            expect: () => <ClothesState>[
              const ClothesState(action: EditClothAction(clothId: clothId)),
            ],
            verify: (bloc) {
              verify(() => mockCreateCloth(any())).called(1);
              verify(() => mockAddClothImage(any())).called(1);
              verifyNoMoreInteractions(mockCreateCloth);
              verifyNoMoreInteractions(mockAddClothImage);
            },
          );
          blocTest<ClothesBloc, ClothesState>(
            'should emit state with status error when '
            'CreateCloth use case returns Failure',
            build: () {
              when(() => mockCreateCloth(any()))
                  .thenAnswer((_) => Future.value(Left(DatabaseFailure())));
              return clothesBloc;
            },
            act: (bloc) {
              bloc.add(ImagePicked(image: imageData));
            },
            expect: () => <ClothesState>[
              const ClothesState(status: ClothesStatus.error),
            ],
          );
          blocTest<ClothesBloc, ClothesState>(
            'should emit state with status error when '
            'AddImage use case returns Failure',
            build: () {
              when(() => mockCreateCloth(any()))
                  .thenAnswer((_) => Future.value(const Right(clothId)));
              when(() => mockAddClothImage(any())).thenAnswer(
                (_) => Future.value(Left(LocalStorageFailure())),
              );
              return clothesBloc;
            },
            act: (bloc) {
              bloc.add(ImagePicked(image: imageData));
            },
            expect: () => <ClothesState>[
              const ClothesState(status: ClothesStatus.error),
            ],
          );
        },
      );

      group(
        'CreateEmptyCloth',
        () {
          const clothId = 1;

          setUpAll(() {
            registerFallbackValue<CreateClothParams>(
              CreateClothParams(cloth: Cloth.empty()),
            );
          });

          blocTest<ClothesBloc, ClothesState>(
            'should call CreateCloth use case and '
            'emit state with EditClothAction with cloth id',
            build: () {
              when(() => mockCreateCloth(any()))
                  .thenAnswer((_) => Future.value(const Right(clothId)));
              return clothesBloc;
            },
            act: (bloc) {
              bloc.add(CreateEmptyCloth());
            },
            expect: () => <ClothesState>[
              const ClothesState(action: EditClothAction(clothId: clothId)),
            ],
            verify: (bloc) {
              verify(() => mockCreateCloth(any())).called(1);
              verifyNoMoreInteractions(mockCreateCloth);
            },
          );
          blocTest<ClothesBloc, ClothesState>(
            'should emit state with status error when '
            'CreateCloth use case returns Failure',
            build: () {
              when(() => mockCreateCloth(any()))
                  .thenAnswer((_) => Future.value(Left(DatabaseFailure())));
              return clothesBloc;
            },
            act: (bloc) {
              bloc.add(CreateEmptyCloth());
            },
            expect: () => <ClothesState>[
              const ClothesState(status: ClothesStatus.error),
            ],
          );
        },
      );

      group(
        'CancelAction',
        () {
          blocTest<ClothesBloc, ClothesState>(
            'should emit state with NoAction',
            build: () {
              return clothesBloc;
            },
            act: (bloc) {
              bloc.add(CancelAction());
            },
            expect: () => <ClothesState>[
              const ClothesState(),
            ],
          );
        },
      );
    },
  );
}
