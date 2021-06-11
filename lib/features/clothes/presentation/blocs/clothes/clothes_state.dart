part of 'clothes_bloc.dart';

abstract class ClothesState extends Equatable {
  const ClothesState();

  @override
  List<Object> get props => [];
}

class Loading extends ClothesState {}

class Loaded extends ClothesState {
  final List<Cloth> clothes;

  const Loaded({required this.clothes});

  @override
  List<Object> get props => [clothes];
}

class LoadError extends ClothesState {}
