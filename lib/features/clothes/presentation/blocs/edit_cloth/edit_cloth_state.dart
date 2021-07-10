part of 'edit_cloth_bloc.dart';

enum EditClothError {
  none,
  clothNotFound,
  savingError,
  other,
}

abstract class EditingClothAction extends Equatable {
  const EditingClothAction();

  @override
  List<Object?> get props => [];
}

class NoAction extends EditingClothAction {
  const NoAction();
}

class CloseClothAction extends EditingClothAction {
  const CloseClothAction();
}

class ClothValidation extends Equatable {
  final bool nameValid;
  final bool descriptionValid;

  const ClothValidation({
    this.nameValid = true,
    this.descriptionValid = true,
  });

  bool get isAllValid => nameValid && descriptionValid;

  ClothValidation copyWith({
    bool? nameValid,
    bool? descriptionValid,
  }) {
    return ClothValidation(
      nameValid: nameValid ?? this.nameValid,
      descriptionValid: descriptionValid ?? this.descriptionValid,
    );
  }

  @override
  List<Object?> get props => [nameValid, descriptionValid];
}

class EditClothState extends Equatable {
  final Cloth? cloth;
  final EditingClothAction action;
  final ClothValidation validation;
  final bool editing;
  final bool loading;
  final EditClothError error;

  const EditClothState({
    this.cloth,
    this.action = const NoAction(),
    this.validation = const ClothValidation(),
    this.editing = false,
    this.loading = false,
    this.error = EditClothError.none,
  });

  bool get hasError => error != EditClothError.none;

  EditClothState copyWith({
    Cloth? cloth,
    EditingClothAction? action,
    ClothValidation? validation,
    bool? editing,
    bool? loading,
    EditClothError? error,
  }) {
    return EditClothState(
      cloth: cloth ?? this.cloth,
      action: action ?? this.action,
      validation: validation ?? this.validation,
      editing: editing ?? this.editing,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        cloth,
        action,
        validation,
        editing,
        loading,
        error,
      ];
}
