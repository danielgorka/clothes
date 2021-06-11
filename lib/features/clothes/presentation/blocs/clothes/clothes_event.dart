part of 'clothes_bloc.dart';

abstract class ClothesEvent extends Equatable {
  const ClothesEvent();

  @override
  List<Object?> get props => [];
}

class LoadClothes extends ClothesEvent {}

class ClothesUpdated extends ClothesEvent {
  final List<Cloth> clothes;

  const ClothesUpdated({required this.clothes});

  @override
  List<Object?> get props => [clothes];
}

class ClothesError extends ClothesEvent {}
