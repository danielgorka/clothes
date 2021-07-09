// ignore_for_file: avoid_redundant_argument_values

import 'package:clothes/features/clothes/presentation/blocs/edit_cloth/edit_cloth_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/entities.dart';

void main() {
  group(
    'NoAction',
    () {
      test('should return correct props', () {
        expect(
          const NoAction().props,
          [],
        );
      });
    },
  );

  group(
    'CloseClothAction',
    () {
      test('should return correct props', () {
        expect(
          const CloseClothAction().props,
          [],
        );
      });
    },
  );

  group(
    'ClothValidation',
    () {
      const nameValid = true;
      const descriptionValid = true;
      const clothValidation = ClothValidation(
        nameValid: nameValid,
        descriptionValid: descriptionValid,
      );

      test('should return correct props', () {
        expect(
          clothValidation.props,
          [nameValid, descriptionValid],
        );
      });

      group(
        'isAllValid',
        () {
          test(
            'should return true when name and description are valid',
            () {
              // arrange
              const clothValidation = ClothValidation();
              // assert
              expect(clothValidation.isAllValid, isTrue);
            },
          );
          test(
            'should return false when name or description is not valid',
            () {
              // arrange
              const clothValidation = ClothValidation(
                nameValid: false,
              );
              // assert
              expect(clothValidation.isAllValid, isFalse);
            },
          );
        },
      );

      group(
        'copyWith',
        () {
          test(
            'should return unchanged state when '
            'running copyWith without arguments',
            () {
              // act
              final newClothValidation = clothValidation.copyWith();
              // assert
              expect(newClothValidation, equals(clothValidation));
            },
          );
          test(
            'should return a valid updated model',
            () {
              // arrange
              const newNameValid = false;
              const newDescriptionValid = false;
              // act
              final newEditClothState = clothValidation.copyWith(
                nameValid: newNameValid,
                descriptionValid: newDescriptionValid,
              );
              // assert
              expect(
                newEditClothState,
                equals(
                  const ClothValidation(
                    nameValid: newNameValid,
                    descriptionValid: newDescriptionValid,
                  ),
                ),
              );
            },
          );
        },
      );
    },
  );

  group(
    'EditClothState',
    () {
      const action = CloseClothAction();
      const validation = ClothValidation(nameValid: false);
      const editing = true;
      const loading = false;
      const error = EditClothError.other;
      final editClothState = EditClothState(
        cloth: cloth1,
        action: action,
        validation: validation,
        editing: editing,
        loading: loading,
        error: error,
      );

      group(
        'hasError',
        () {
          test(
            'should return true when error is not EditClothError.none',
            () {
              // arrange
              const state = EditClothState(error: EditClothError.other);
              // assert
              expect(state.hasError, isTrue);
            },
          );
          test(
            'should return false when error is EditClothError.none',
            () {
              // arrange
              const state = EditClothState(error: EditClothError.none);
              // assert
              expect(state.hasError, isFalse);
            },
          );
        },
      );

      group(
        'copyWith',
        () {
          test(
            'should return unchanged state when '
            'running copyWith without arguments',
            () {
              // act
              final newEditClothState = editClothState.copyWith();
              // assert
              expect(newEditClothState, equals(editClothState));
            },
          );
          test(
            'should return a valid updated model',
            () {
              // arrange
              final newCloth = cloth2;
              const newAction = NoAction();
              const newValidation = ClothValidation(descriptionValid: false);
              const newEditing = false;
              const newLoading = true;
              const newError = EditClothError.none;
              // act
              final newEditClothState = editClothState.copyWith(
                cloth: newCloth,
                action: newAction,
                validation: newValidation,
                editing: newEditing,
                loading: newLoading,
                error: newError,
              );
              // assert
              expect(
                newEditClothState,
                equals(
                  EditClothState(
                    cloth: newCloth,
                    action: newAction,
                    validation: newValidation,
                    editing: newEditing,
                    loading: newLoading,
                    error: newError,
                  ),
                ),
              );
            },
          );
        },
      );

      test(
        'should return correct props',
        () {
          expect(
            editClothState.props,
            [
              cloth1,
              action,
              validation,
              editing,
              loading,
              error,
            ],
          );
        },
      );
    },
  );
}
