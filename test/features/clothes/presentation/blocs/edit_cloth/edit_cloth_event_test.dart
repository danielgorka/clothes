import 'package:clothes/features/clothes/presentation/blocs/edit_cloth/edit_cloth_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../helpers/entities.dart';

void main() {
  group(
    'SetCloth',
    () {
      test('should return correct props', () {
        const clothId = 3;
        const setCloth = SetCloth(clothId: clothId);
        expect(
          setCloth.props,
          [clothId],
        );
      });
    },
  );

  group(
    'ChangeFavourite',
    () {
      test('should return correct props', () {
        const favourite = true;
        const changeFavourite = ChangeFavourite(favourite: favourite);
        expect(
          changeFavourite.props,
          [favourite],
        );
      });
    },
  );

  group(
    'UpdateClothName',
    () {
      test('should return correct props', () {
        const name = 'Cloth name';
        const updateClothName = UpdateClothName(name: name);
        expect(
          updateClothName.props,
          [name],
        );
      });
    },
  );

  group(
    'UpdateClothDescription',
    () {
      test('should return correct props', () {
        const description = 'Cloth description';
        const updateClothDescription = UpdateClothDescription(
          description: description,
        );
        expect(
          updateClothDescription.props,
          [description],
        );
      });
    },
  );

  group(
    'AddTagToCloth',
    () {
      test('should return correct props', () {
        const addTagToCloth = AddTagToCloth(
          tag: clothTag1,
        );
        expect(
          addTagToCloth.props,
          [clothTag1],
        );
      });
    },
  );

  group(
    'RemoveTagFromCloth',
    () {
      const tagId = 11;
      test('should return correct props', () {
        const removeTagFromCloth = RemoveTagFromCloth(
          tagId: tagId,
        );
        expect(
          removeTagFromCloth.props,
          [tagId],
        );
      });
    },
  );

  group(
    'EditCloth',
    () {
      test('should return correct props', () {
        expect(
          EditCloth().props,
          [],
        );
      });
    },
  );

  group(
    'SaveCloth',
    () {
      test('should return correct props', () {
        expect(
          SaveCloth().props,
          [],
        );
      });
    },
  );

  group(
    'ClearError',
    () {
      test('should return correct props', () {
        expect(
          ClearError().props,
          [],
        );
      });
    },
  );

  group(
    'ClearAction',
    () {
      test('should return correct props', () {
        expect(
          ClearAction().props,
          [],
        );
      });
    },
  );

  group(
    'CloseCloth',
    () {
      test('should return correct props', () {
        expect(
          CloseCloth().props,
          [],
        );
      });
    },
  );
}
