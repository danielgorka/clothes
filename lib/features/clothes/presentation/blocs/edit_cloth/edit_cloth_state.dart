part of 'edit_cloth_bloc.dart';

enum EditClothError {
  none,
  clothNotFound,
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

class EditClothState extends Equatable {
  final Cloth? cloth;
  final EditingClothAction action;
  final bool loading;
  final EditClothError error;

  const EditClothState({
    this.cloth,
    this.action = const NoAction(),
    this.loading = false,
    this.error = EditClothError.none,
  });

  bool get hasError => error != EditClothError.none;

  EditClothState copyWith({
    Cloth? cloth,
    EditingClothAction? action,
    bool? loading,
    EditClothError? error,
  }) {
    return EditClothState(
      cloth: cloth ?? this.cloth,
      action: action ?? this.action,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [cloth, action, loading, error];
}
