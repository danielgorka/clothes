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
    'EditClothState',
    () {
      const action = CloseClothAction();
      const loading = false;
      const error = EditClothError.other;
      final editClothState = EditClothState(
        cloth: cloth1,
        action: action,
        loading: loading,
        error: error,
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
              const newLoading = true;
              const newError = EditClothError.none;
              // act
              final newEditClothState = editClothState.copyWith(
                cloth: newCloth,
                action: newAction,
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
              loading,
              error,
            ],
          );
        },
      );
    },
  );
}
