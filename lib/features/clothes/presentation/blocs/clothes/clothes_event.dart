part of 'clothes_bloc.dart';

abstract class ClothesEvent extends Equatable {
  const ClothesEvent();

  @override
  List<Object?> get props => [];
}

class LoadClothes extends ClothesEvent {}
