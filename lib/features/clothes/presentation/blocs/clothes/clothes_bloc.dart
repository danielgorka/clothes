import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clothes/core/use_cases/no_params.dart';
import 'package:clothes/features/clothes/domain/entities/cloth.dart';
import 'package:clothes/features/clothes/domain/use_cases/get_clothes.dart';
import 'package:equatable/equatable.dart';

part 'clothes_event.dart';
part 'clothes_state.dart';

class ClothesBloc extends Bloc<ClothesEvent, ClothesState> {
  final GetClothes getClothes;
  StreamSubscription? _clothesSubscription;

  ClothesBloc({
    required this.getClothes,
  }) : super(Loading());

  @override
  Stream<ClothesState> mapEventToState(ClothesEvent event) async* {
    if (event is LoadClothes) {
      yield* _mapLoadClothesToState(event);
    } else if (event is ClothesUpdated) {
      yield* _mapClothesUpdatedToState(event);
    } else if (event is ClothesError) {
      yield* _mapClothesErrorToState(event);
    }
  }

  Stream<ClothesState> _mapLoadClothesToState(LoadClothes event) async* {
    _clothesSubscription?.cancel();
    _clothesSubscription = getClothes(NoParams()).listen((either) {
      either.fold(
        (failure) => add(ClothesError()),
        (clothes) => add(ClothesUpdated(clothes: clothes)),
      );
    });
  }

  Stream<ClothesState> _mapClothesUpdatedToState(ClothesUpdated event) async* {
    yield Loaded(clothes: event.clothes);
  }

  Stream<ClothesState> _mapClothesErrorToState(ClothesError event) async* {
    yield LoadError();
  }

  @override
  Future<void> close() {
    _clothesSubscription?.cancel();
    return super.close();
  }
}
