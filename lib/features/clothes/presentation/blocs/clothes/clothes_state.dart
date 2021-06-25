part of 'clothes_bloc.dart';

enum ClothesStatus {
  loading,
  error,
  loaded,
}

abstract class ClothesAction extends Equatable {
  const ClothesAction();

  @override
  List<Object?> get props => [];
}

class NoAction extends ClothesAction {
  const NoAction();
}

class PickImageAction extends ClothesAction {
  final ImagePickerSource source;

  const PickImageAction({required this.source});

  @override
  List<Object?> get props => [source];
}

class EditClothAction extends ClothesAction {
  final int clothId;

  const EditClothAction({required this.clothId});

  @override
  List<Object?> get props => [clothId];
}

class ClothesState extends Equatable {
  final ClothesStatus status;
  final ClothesAction action;
  final List<Cloth> clothes;

  const ClothesState({
    this.status = ClothesStatus.loading,
    this.action = const NoAction(),
    this.clothes = const [],
  });

  ClothesState copyWith({
    ClothesStatus? status,
    ClothesAction? action,
    List<Cloth>? clothes,
  }) {
    return ClothesState(
      status: status ?? this.status,
      action: action ?? this.action,
      clothes: clothes ?? this.clothes,
    );
  }

  @override
  List<Object> get props => [status, action, clothes];
}
