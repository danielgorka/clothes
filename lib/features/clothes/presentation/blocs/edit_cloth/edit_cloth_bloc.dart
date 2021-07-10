import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clothes/app/utils/clothes_utils.dart';
import 'package:clothes/core/error/failures.dart';
import 'package:clothes/features/clothes/domain/entities/cloth.dart';
import 'package:clothes/features/clothes/domain/entities/cloth_tag.dart';
import 'package:clothes/features/clothes/domain/use_cases/get_cloth.dart';
import 'package:clothes/features/clothes/domain/use_cases/update_cloth.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'edit_cloth_event.dart';
part 'edit_cloth_state.dart';

@injectable
class EditClothBloc extends Bloc<EditClothEvent, EditClothState> {
  final GetCloth getCloth;
  final UpdateCloth updateCloth;

  EditClothBloc({
    required this.getCloth,
    required this.updateCloth,
  }) : super(const EditClothState(loading: true));

  @override
  Stream<EditClothState> mapEventToState(EditClothEvent event) async* {
    if (event is SetCloth) {
      yield* _mapSetClothToState(event);
    } else if (event is ChangeFavourite) {
      yield* _mapChangeFavouriteToState(event);
    } else if (event is UpdateClothName) {
      yield* _mapUpdateClothNameToState(event);
    } else if (event is UpdateClothDescription) {
      yield* _mapUpdateClothDescriptionToState(event);
    } else if (event is AddTagToCloth) {
      yield* _mapAddTagToClothToState(event);
    } else if (event is RemoveTagFromCloth) {
      yield* _mapRemoveTagFromClothToState(event);
    } else if (event is EditCloth) {
      yield* _mapEditClothToState(event);
    } else if (event is SaveCloth) {
      yield* _mapSaveClothToState(event);
    } else if (event is ClearError) {
      yield* _mapClearErrorToState(event);
    } else if (event is ClearAction) {
      yield* _mapClearActionToState(event);
    } else if (event is CloseCloth) {
      yield* _mapCloseClothToState(event);
    }
  }

  Stream<EditClothState> _mapSetClothToState(SetCloth event) async* {
    yield const EditClothState(loading: true);

    final either = await getCloth(GetClothParams(id: event.clothId));
    yield* either.fold(
      (failure) async* {
        if (failure is ObjectNotFoundFailure) {
          yield state.copyWith(
            loading: false,
            error: EditClothError.clothNotFound,
          );
        } else {
          yield state.copyWith(
            loading: false,
            error: EditClothError.other,
          );
        }
      },
      (cloth) async* {
        yield state.copyWith(cloth: cloth, loading: false);
      },
    );
  }

  Stream<EditClothState> _mapChangeFavouriteToState(
    ChangeFavourite event,
  ) async* {
    final originalCloth = state.cloth!;
    final updatedCloth = originalCloth.copyWith(favourite: event.favourite);

    yield state.copyWith(
      loading: true,
      cloth: updatedCloth,
    );

    final failure = await updateCloth(UpdateClothParams(cloth: updatedCloth));
    if (failure == null) {
      yield state.copyWith(loading: false);
    } else {
      yield state.copyWith(
        loading: false,
        cloth: originalCloth,
        error: EditClothError.other,
      );
    }
  }

  Stream<EditClothState> _mapUpdateClothNameToState(
    UpdateClothName event,
  ) async* {
    yield state.copyWith(
      cloth: state.cloth!.copyWith(name: event.name),
      validation: state.validation.copyWith(
        nameValid: ClothesUtils.validateName(event.name),
      ),
    );
  }

  Stream<EditClothState> _mapUpdateClothDescriptionToState(
    UpdateClothDescription event,
  ) async* {
    yield state.copyWith(
      cloth: state.cloth!.copyWith(description: event.description),
      validation: state.validation.copyWith(
        descriptionValid: ClothesUtils.validateDescription(event.description),
      ),
    );
  }

  Stream<EditClothState> _mapAddTagToClothToState(AddTagToCloth event) async* {
    if (state.cloth!.tags.any((tag) => tag.id == event.tag.id)) {
      return;
    }

    yield state.copyWith(
      cloth: state.cloth!.copyWith(
        tags: state.cloth!.tags + [event.tag],
      ),
    );
  }

  Stream<EditClothState> _mapRemoveTagFromClothToState(
    RemoveTagFromCloth event,
  ) async* {
    final updatedTags = List<ClothTag>.from(state.cloth!.tags);
    updatedTags.removeWhere((tag) => tag.id == event.tagId);
    yield state.copyWith(
      cloth: state.cloth!.copyWith(tags: updatedTags),
    );
  }

  Stream<EditClothState> _mapEditClothToState(EditCloth event) async* {
    yield state.copyWith(editing: true);
  }

  Stream<EditClothState> _mapSaveClothToState(SaveCloth event) async* {
    yield state.copyWith(loading: true);

    final validation = _validateCloth(state.cloth!);

    if (!validation.isAllValid) {
      yield state.copyWith(loading: false, validation: validation);
      return;
    }

    final failure = await updateCloth(
      UpdateClothParams(cloth: state.cloth!),
    );

    if (failure != null) {
      yield state.copyWith(loading: false, error: EditClothError.savingError);
      return;
    }
    yield state.copyWith(loading: false, editing: false);
  }

  Stream<EditClothState> _mapClearErrorToState(ClearError event) async* {
    yield state.copyWith(error: EditClothError.none);
  }

  Stream<EditClothState> _mapClearActionToState(ClearAction event) async* {
    yield state.copyWith(action: const NoAction());
  }

  Stream<EditClothState> _mapCloseClothToState(CloseCloth event) async* {
    yield state.copyWith(action: const CloseClothAction());
  }

  ClothValidation _validateCloth(Cloth cloth) {
    return ClothValidation(
      nameValid: ClothesUtils.validateName(cloth.name),
      descriptionValid: ClothesUtils.validateDescription(cloth.description),
    );
  }
}
