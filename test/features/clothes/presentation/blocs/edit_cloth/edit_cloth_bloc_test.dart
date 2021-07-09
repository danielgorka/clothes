import 'package:bloc_test/bloc_test.dart';
import 'package:clothes/app/utils/clothes_utils.dart';
import 'package:clothes/core/error/failures.dart';
import 'package:clothes/features/clothes/domain/use_cases/get_cloth.dart';
import 'package:clothes/features/clothes/domain/use_cases/update_cloth.dart';
import 'package:clothes/features/clothes/presentation/blocs/edit_cloth/edit_cloth_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/entities.dart';

class MockGetCloth extends Mock implements GetCloth {}

class MockUpdateCloth extends Mock implements UpdateCloth {}

void main() {
  group(
    'EditClothBloc',
    () {
      late EditClothBloc editClothBloc;
      late MockGetCloth mockGetCloth;
      late MockUpdateCloth mockUpdateCloth;

      setUp(() {
        mockGetCloth = MockGetCloth();
        mockUpdateCloth = MockUpdateCloth();
        editClothBloc = EditClothBloc(
          getCloth: mockGetCloth,
          updateCloth: mockUpdateCloth,
        );
      });

      tearDown(() {
        editClothBloc.close();
      });

      test(
        'initial state should be loading state',
        () {
          // assert
          expect(
            editClothBloc.state,
            equals(const EditClothState(loading: true)),
          );
        },
      );

      group(
        'SetCloth',
        () {
          final params = GetClothParams(id: cloth1.id);

          test(
            'should call GetCloth use case',
            () async {
              // arrange
              when(() => mockGetCloth(params))
                  .thenAnswer((_) => Future.value(Right(cloth1)));
              // act
              editClothBloc.add(SetCloth(clothId: cloth1.id));
              await untilCalled(() => mockGetCloth(params));
              // assert
              verify(() => mockGetCloth(params)).called(1);
              verifyNoMoreInteractions(mockGetCloth);
            },
          );
          blocTest<EditClothBloc, EditClothState>(
            'should emit loading state and state with given cloth '
            'when GetCloth returns Right',
            build: () {
              when(() => mockGetCloth(params))
                  .thenAnswer((_) => Future.value(Right(cloth1)));
              return editClothBloc;
            },
            act: (bloc) {
              bloc.add(SetCloth(clothId: cloth1.id));
            },
            expect: () => <EditClothState>[
              const EditClothState(loading: true),
              EditClothState(cloth: cloth1),
            ],
          );
          blocTest<EditClothBloc, EditClothState>(
            'should emit loading state and state with not found error '
            'when GetCloth returns ObjectNotFoundFailure',
            build: () {
              when(() => mockGetCloth(params)).thenAnswer(
                  (_) => Future.value(Left(ObjectNotFoundFailure())));
              return editClothBloc;
            },
            act: (bloc) {
              bloc.add(SetCloth(clothId: cloth1.id));
            },
            expect: () => <EditClothState>[
              const EditClothState(loading: true),
              const EditClothState(error: EditClothError.clothNotFound),
            ],
          );
          blocTest<EditClothBloc, EditClothState>(
            'should emit loading state and state with other error '
            'when getCloth returns Failure',
            build: () {
              when(() => mockGetCloth(params))
                  .thenAnswer((_) => Future.value(Left(DatabaseFailure())));
              return editClothBloc;
            },
            act: (bloc) {
              bloc.add(SetCloth(clothId: cloth1.id));
            },
            expect: () => <EditClothState>[
              const EditClothState(loading: true),
              const EditClothState(error: EditClothError.other),
            ],
          );
        },
      );

      group(
        'ChangeFavourite',
        () {
          const favourite = false;
          final cloth = cloth1;
          final changedCloth = cloth.copyWith(favourite: favourite);
          final params = UpdateClothParams(cloth: changedCloth);

          test(
            'should call UpdateCloth use case',
            () async {
              // arrange
              when(() => mockGetCloth(GetClothParams(id: cloth.id)))
                  .thenAnswer((_) => Future.value(Right(cloth)));
              when(() => mockUpdateCloth(params))
                  .thenAnswer((_) => Future.value(null));
              // act
              editClothBloc.add(SetCloth(clothId: cloth.id));
              editClothBloc.add(const ChangeFavourite(favourite: favourite));
              await untilCalled(() => mockUpdateCloth(params));
              // assert
              verify(() => mockUpdateCloth(params)).called(1);
              verifyNoMoreInteractions(mockUpdateCloth);
            },
          );
          blocTest<EditClothBloc, EditClothState>(
            'should emit state with loading and updated cloth and '
            'later state without loading when UpdateCloth returns null',
            build: () {
              when(() => mockGetCloth(GetClothParams(id: cloth.id)))
                  .thenAnswer((_) => Future.value(Right(cloth)));
              when(() => mockUpdateCloth(params))
                  .thenAnswer((_) => Future.value(null));
              return editClothBloc;
            },
            act: (bloc) {
              bloc.add(SetCloth(clothId: cloth.id));
              bloc.add(const ChangeFavourite(favourite: favourite));
            },
            expect: () => <EditClothState>[
              const EditClothState(loading: true),
              EditClothState(cloth: cloth),
              EditClothState(loading: true, cloth: changedCloth),
              EditClothState(cloth: changedCloth),
            ],
          );
          blocTest<EditClothBloc, EditClothState>(
            'should emit state with loading and updated cloth and '
            'later state with other error, reversed cloth and without loading '
            'when UpdateCloth returns Failure',
            build: () {
              when(() => mockGetCloth(GetClothParams(id: cloth.id)))
                  .thenAnswer((_) => Future.value(Right(cloth)));
              when(() => mockUpdateCloth(params))
                  .thenAnswer((_) => Future.value(DatabaseFailure()));
              return editClothBloc;
            },
            act: (bloc) {
              bloc.add(SetCloth(clothId: cloth.id));
              bloc.add(const ChangeFavourite(favourite: favourite));
            },
            expect: () => <EditClothState>[
              const EditClothState(loading: true),
              EditClothState(cloth: cloth),
              EditClothState(loading: true, cloth: changedCloth),
              EditClothState(cloth: cloth, error: EditClothError.other),
            ],
          );
        },
      );

      group(
        'UpdateClothName',
        () {
          const name = 'Cloth name';
          final updatedCloth = cloth1.copyWith(name: name);
          blocTest<EditClothBloc, EditClothState>(
            'should emit state with updated cloth name',
            build: () {
              when(() => mockGetCloth(GetClothParams(id: cloth1.id)))
                  .thenAnswer((_) => Future.value(Right(cloth1)));
              return editClothBloc;
            },
            act: (bloc) {
              bloc.add(SetCloth(clothId: cloth1.id));
              bloc.add(EditCloth());
              bloc.add(const UpdateClothName(name: name));
            },
            expect: () => <EditClothState>[
              const EditClothState(loading: true),
              EditClothState(cloth: cloth1),
              EditClothState(cloth: cloth1, editing: true),
              EditClothState(cloth: updatedCloth, editing: true),
            ],
          );

          final longName =
              List.generate(ClothesUtils.maxClothNameLength + 1, (_) => 'a')
                  .join();
          final longUpdatedCloth = cloth1.copyWith(name: longName);
          blocTest<EditClothBloc, EditClothState>(
            'should emit state with updated cloth name and '
            'nameValid set to false when cloth name is too long',
            build: () {
              when(() => mockGetCloth(GetClothParams(id: cloth1.id)))
                  .thenAnswer((_) => Future.value(Right(cloth1)));
              return editClothBloc;
            },
            act: (bloc) {
              bloc.add(SetCloth(clothId: cloth1.id));
              bloc.add(EditCloth());
              bloc.add(UpdateClothName(name: longName));
            },
            expect: () => <EditClothState>[
              const EditClothState(loading: true),
              EditClothState(cloth: cloth1),
              EditClothState(cloth: cloth1, editing: true),
              EditClothState(
                cloth: longUpdatedCloth,
                editing: true,
                validation: const ClothValidation(nameValid: false),
              ),
            ],
          );
        },
      );

      group(
        'UpdateClothDescription',
        () {
          const description = 'Cloth description';
          final updatedCloth = cloth1.copyWith(description: description);
          blocTest<EditClothBloc, EditClothState>(
            'should emit state with updated cloth description',
            build: () {
              when(() => mockGetCloth(GetClothParams(id: cloth1.id)))
                  .thenAnswer((_) => Future.value(Right(cloth1)));
              return editClothBloc;
            },
            act: (bloc) {
              bloc.add(SetCloth(clothId: cloth1.id));
              bloc.add(EditCloth());
              bloc.add(const UpdateClothDescription(description: description));
            },
            expect: () => <EditClothState>[
              const EditClothState(loading: true),
              EditClothState(cloth: cloth1),
              EditClothState(cloth: cloth1, editing: true),
              EditClothState(cloth: updatedCloth, editing: true),
            ],
          );

          final longDescription = List.generate(
              ClothesUtils.maxClothDescriptionLength + 1, (_) => 'a').join();
          final longUpdatedCloth =
              cloth1.copyWith(description: longDescription);
          blocTest<EditClothBloc, EditClothState>(
            'should emit state with updated cloth description and '
            'descriptionValid set to false when cloth description is too long',
            build: () {
              when(() => mockGetCloth(GetClothParams(id: cloth1.id)))
                  .thenAnswer((_) => Future.value(Right(cloth1)));
              return editClothBloc;
            },
            act: (bloc) {
              bloc.add(SetCloth(clothId: cloth1.id));
              bloc.add(EditCloth());
              bloc.add(UpdateClothDescription(description: longDescription));
            },
            expect: () => <EditClothState>[
              const EditClothState(loading: true),
              EditClothState(cloth: cloth1),
              EditClothState(cloth: cloth1, editing: true),
              EditClothState(
                cloth: longUpdatedCloth,
                editing: true,
                validation: const ClothValidation(descriptionValid: false),
              ),
            ],
          );
        },
      );

      group(
        'AddTagToCloth',
        () {
          final updatedCloth = cloth1.copyWith(
            tags: clothTags1 + [clothTag2],
          );
          blocTest<EditClothBloc, EditClothState>(
            'should emit state with new tag added to cloth',
            build: () {
              when(() => mockGetCloth(GetClothParams(id: cloth1.id)))
                  .thenAnswer((_) => Future.value(Right(cloth1)));
              return editClothBloc;
            },
            act: (bloc) {
              bloc.add(SetCloth(clothId: cloth1.id));
              bloc.add(EditCloth());
              bloc.add(const AddTagToCloth(tag: clothTag2));
            },
            expect: () => <EditClothState>[
              const EditClothState(loading: true),
              EditClothState(cloth: cloth1),
              EditClothState(cloth: cloth1, editing: true),
              EditClothState(cloth: updatedCloth, editing: true),
            ],
          );

          blocTest<EditClothBloc, EditClothState>(
            'should do nothing when cloth contains new tag',
            build: () {
              when(() => mockGetCloth(GetClothParams(id: cloth1.id)))
                  .thenAnswer((_) => Future.value(Right(cloth1)));
              return editClothBloc;
            },
            act: (bloc) {
              bloc.add(SetCloth(clothId: cloth1.id));
              bloc.add(EditCloth());
              bloc.add(const AddTagToCloth(tag: clothTag1));
            },
            expect: () => <EditClothState>[
              const EditClothState(loading: true),
              EditClothState(cloth: cloth1),
              EditClothState(cloth: cloth1, editing: true),
            ],
          );
        },
      );

      group(
        'RemoveTagFromCloth',
        () {
          final updatedCloth = cloth1.copyWith(
            tags: [clothTag3],
          );
          blocTest<EditClothBloc, EditClothState>(
            'should emit state with cloth without tag',
            build: () {
              when(() => mockGetCloth(GetClothParams(id: cloth1.id)))
                  .thenAnswer((_) => Future.value(Right(cloth1)));
              return editClothBloc;
            },
            act: (bloc) {
              bloc.add(SetCloth(clothId: cloth1.id));
              bloc.add(EditCloth());
              bloc.add(RemoveTagFromCloth(tagId: clothTag1.id));
            },
            expect: () => <EditClothState>[
              const EditClothState(loading: true),
              EditClothState(cloth: cloth1),
              EditClothState(cloth: cloth1, editing: true),
              EditClothState(cloth: updatedCloth, editing: true),
            ],
          );

          blocTest<EditClothBloc, EditClothState>(
            'should do nothing when cloth does not contain tag',
            build: () {
              when(() => mockGetCloth(GetClothParams(id: cloth1.id)))
                  .thenAnswer((_) => Future.value(Right(cloth1)));
              return editClothBloc;
            },
            act: (bloc) {
              bloc.add(SetCloth(clothId: cloth1.id));
              bloc.add(EditCloth());
              bloc.add(RemoveTagFromCloth(tagId: clothTag2.id));
            },
            expect: () => <EditClothState>[
              const EditClothState(loading: true),
              EditClothState(cloth: cloth1),
              EditClothState(cloth: cloth1, editing: true),
            ],
          );
        },
      );

      group(
        'EditCloth',
        () {
          blocTest<EditClothBloc, EditClothState>(
            'should emit state with editing set to true',
            build: () {
              when(() => mockGetCloth(GetClothParams(id: cloth1.id)))
                  .thenAnswer((_) => Future.value(Right(cloth1)));
              return editClothBloc;
            },
            act: (bloc) {
              bloc.add(SetCloth(clothId: cloth1.id));
              bloc.add(EditCloth());
            },
            expect: () => <EditClothState>[
              const EditClothState(loading: true),
              EditClothState(cloth: cloth1),
              EditClothState(cloth: cloth1, editing: true),
            ],
          );
        },
      );

      group(
        'SaveCloth',
        () {
          final params = UpdateClothParams(cloth: cloth1);

          test(
            'should call UpdateCloth use case',
            () async {
              // arrange
              when(() => mockGetCloth(GetClothParams(id: cloth1.id)))
                  .thenAnswer((_) => Future.value(Right(cloth1)));
              when(() => mockUpdateCloth(params))
                  .thenAnswer((_) => Future.value(null));
              // act
              editClothBloc.add(SetCloth(clothId: cloth1.id));
              editClothBloc.add(EditCloth());
              editClothBloc.add(SaveCloth());
              await untilCalled(() => mockUpdateCloth(params));
              // assert
              verify(() => mockUpdateCloth(params)).called(1);
              verifyNoMoreInteractions(mockUpdateCloth);
            },
          );
          blocTest<EditClothBloc, EditClothState>(
            'should emit state with loading and later without loading '
            'and without editing when cloth is validated '
            'and updated successfully',
            build: () {
              when(() => mockGetCloth(GetClothParams(id: cloth1.id)))
                  .thenAnswer((_) => Future.value(Right(cloth1)));
              when(() => mockUpdateCloth(params))
                  .thenAnswer((_) => Future.value(null));
              return editClothBloc;
            },
            act: (bloc) {
              bloc.add(SetCloth(clothId: cloth1.id));
              bloc.add(EditCloth());
              bloc.add(SaveCloth());
            },
            expect: () => <EditClothState>[
              const EditClothState(loading: true),
              EditClothState(cloth: cloth1),
              EditClothState(cloth: cloth1, editing: true),
              EditClothState(cloth: cloth1, editing: true, loading: true),
              EditClothState(cloth: cloth1),
            ],
          );

          final longName =
              List.generate(ClothesUtils.maxClothNameLength + 1, (_) => 'a')
                  .join();
          final clothWithLongName = cloth1.copyWith(name: longName);
          blocTest<EditClothBloc, EditClothState>(
            'should emit state with loading and later without loading '
            'and with validation when cloth validation failed',
            build: () {
              when(() => mockGetCloth(GetClothParams(id: clothWithLongName.id)))
                  .thenAnswer((_) => Future.value(Right(clothWithLongName)));
              return editClothBloc;
            },
            act: (bloc) {
              bloc.add(SetCloth(clothId: clothWithLongName.id));
              bloc.add(EditCloth());
              bloc.add(SaveCloth());
            },
            expect: () => <EditClothState>[
              const EditClothState(loading: true),
              EditClothState(cloth: clothWithLongName),
              EditClothState(cloth: clothWithLongName, editing: true),
              EditClothState(
                cloth: clothWithLongName,
                editing: true,
                loading: true,
              ),
              EditClothState(
                cloth: clothWithLongName,
                editing: true,
                validation: const ClothValidation(nameValid: false),
              ),
            ],
          );

          blocTest<EditClothBloc, EditClothState>(
            'should emit state with loading and later without loading and '
            'with saving error when UpdateCloth use case returns failure',
            build: () {
              when(() => mockGetCloth(GetClothParams(id: cloth1.id)))
                  .thenAnswer((_) => Future.value(Right(cloth1)));
              when(() => mockUpdateCloth(params))
                  .thenAnswer((_) => Future.value(DatabaseFailure()));
              return editClothBloc;
            },
            act: (bloc) {
              bloc.add(SetCloth(clothId: cloth1.id));
              bloc.add(EditCloth());
              bloc.add(SaveCloth());
            },
            expect: () => <EditClothState>[
              const EditClothState(loading: true),
              EditClothState(cloth: cloth1),
              EditClothState(cloth: cloth1, editing: true),
              EditClothState(
                cloth: cloth1,
                editing: true,
                loading: true,
              ),
              EditClothState(
                cloth: cloth1,
                editing: true,
                error: EditClothError.savingError,
              ),
            ],
          );
        },
      );

      group(
        'ClearError',
        () {
          blocTest<EditClothBloc, EditClothState>(
            'should emit state with EditClothError.none',
            build: () {
              when(() => mockGetCloth(GetClothParams(id: cloth1.id)))
                  .thenAnswer((_) => Future.value(Left(DatabaseFailure())));
              return editClothBloc;
            },
            act: (bloc) {
              bloc.add(SetCloth(clothId: cloth1.id));
              bloc.add(ClearError());
            },
            expect: () => <EditClothState>[
              const EditClothState(loading: true),
              const EditClothState(error: EditClothError.other),
              const EditClothState(),
            ],
          );
        },
      );

      group(
        'ClearAction',
        () {
          blocTest<EditClothBloc, EditClothState>(
            'should emit state with NoAction',
            build: () {
              return editClothBloc;
            },
            act: (bloc) {
              bloc.add(CloseCloth());
              bloc.add(ClearAction());
            },
            expect: () => <EditClothState>[
              const EditClothState(
                loading: true,
                action: CloseClothAction(),
              ),
              const EditClothState(loading: true),
            ],
          );
        },
      );

      group(
        'CloseCloth',
        () {
          blocTest<EditClothBloc, EditClothState>(
            'should emit state with CloseClothAction',
            build: () {
              return editClothBloc;
            },
            act: (bloc) {
              bloc.add(CloseCloth());
            },
            expect: () => <EditClothState>[
              const EditClothState(
                loading: true,
                action: CloseClothAction(),
              ),
            ],
          );
        },
      );
    },
  );
}
