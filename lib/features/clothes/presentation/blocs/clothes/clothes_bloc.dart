import 'dart:async';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:clothes/core/use_cases/no_params.dart';
import 'package:clothes/features/clothes/domain/entities/cloth.dart';
import 'package:clothes/features/clothes/domain/use_cases/add_cloth_image.dart';
import 'package:clothes/features/clothes/domain/use_cases/create_cloth.dart';
import 'package:clothes/features/clothes/domain/use_cases/get_clothes.dart';
import 'package:clothes/features/clothes/presentation/blocs/edit_image/edit_image_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'clothes_event.dart';
part 'clothes_state.dart';

@injectable
class ClothesBloc extends Bloc<ClothesEvent, ClothesState> {
  final GetClothes getClothes;
  final CreateCloth createCloth;
  final AddClothImage addClothImage;
  StreamSubscription? _clothesSubscription;

  ClothesBloc({
    required this.getClothes,
    required this.createCloth,
    required this.addClothImage,
  }) : super(const ClothesState());

  @override
  Stream<ClothesState> mapEventToState(ClothesEvent event) async* {
    if (event is LoadClothes) {
      yield* _mapLoadClothesToState(event);
    } else if (event is ShowCloth) {
      yield* _mapShowClothToState(event);
    } else if (event is PickImage) {
      yield* _mapPickImageToState(event);
    } else if (event is ImagePicked) {
      yield* _mapImagePickedToState(event);
    } else if (event is CreateEmptyCloth) {
      yield* _mapCreateEmptyClothToState(event);
    } else if (event is CancelAction) {
      yield* _mapCancelActionToState(event);
    }
  }

  Stream<ClothesState> _mapLoadClothesToState(LoadClothes event) async* {
    _clothesSubscription?.cancel();
    _clothesSubscription = getClothes(NoParams()).listen((either) {
      either.fold(
        (failure) => emit(state.copyWith(status: ClothesStatus.error)),
        (clothes) => emit(
          state.copyWith(status: ClothesStatus.loaded, clothes: clothes),
        ),
      );
    });
  }

  Stream<ClothesState> _mapShowClothToState(ShowCloth event) async* {
    yield state.copyWith(action: EditClothAction(clothId: event.clothId));
  }

  Stream<ClothesState> _mapPickImageToState(PickImage event) async* {
    yield state.copyWith(action: PickImageAction(source: event.source));
  }

  Stream<ClothesState> _mapImagePickedToState(ImagePicked event) async* {
    final clothIdEither = await createCloth(
      CreateClothParams(cloth: Cloth.empty()),
    );
    if (clothIdEither.isLeft()) {
      //TODO: return specified error
      yield state.copyWith(status: ClothesStatus.error);
      return;
    }
    final clothId = clothIdEither.getOrElse(() => 0);
    final clothImageEither = await addClothImage(
        AddClothImageParams(clothId: clothId, image: event.image));
    if (clothImageEither.isLeft()) {
      //TODO: return specified error
      yield state.copyWith(status: ClothesStatus.error);
      return;
    }
    yield state.copyWith(action: EditClothAction(clothId: clothId));
  }

  Stream<ClothesState> _mapCreateEmptyClothToState(
    CreateEmptyCloth event,
  ) async* {
    final clothIdEither = await createCloth(
      CreateClothParams(cloth: Cloth.empty()),
    );
    if (clothIdEither.isLeft()) {
      //TODO: return specified error
      yield state.copyWith(status: ClothesStatus.error);
      return;
    }
    final clothId = clothIdEither.getOrElse(() => 0);
    yield state.copyWith(action: EditClothAction(clothId: clothId));
  }

  Stream<ClothesState> _mapCancelActionToState(CancelAction event) async* {
    yield state.copyWith(action: const NoAction());
  }

  @override
  Future<void> close() {
    _clothesSubscription?.cancel();
    return super.close();
  }
}
