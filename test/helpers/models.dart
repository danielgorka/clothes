import 'package:clothes/features/clothes/data/models/cloth_image_model.dart';
import 'package:clothes/features/clothes/data/models/cloth_model.dart';
import 'package:clothes/features/clothes/data/models/cloth_tag_model.dart';
import 'package:clothes/features/clothes/domain/entities/cloth_tag.dart';

import 'entities.dart';

// ClothImageModel
final clothImageModel1 = ClothImageModel(
  id: clothImage1.id,
  path: clothImage1.path,
);
final clothImageModel2 = ClothImageModel(
  id: clothImage2.id,
  path: clothImage2.path,
);

// ClothTagModel
final clothTagModel1 = ClothTagModel(
  id: clothTag1.id,
  type: _mapClothTagTypeToString(clothTag1.type),
  name: clothTag1.name,
);
final clothTagModel2 = ClothTagModel(
  id: clothTag2.id,
  type: _mapClothTagTypeToString(clothTag2.type),
  name: clothTag2.name,
);
final clothTagModelWithUnknownType = ClothTagModel(
  id: clothTag1.id,
  type: 'unknown type',
  name: clothTag1.name,
);

// ClothModel
final clothModel1 = ClothModel(
  id: cloth1.id,
  name: cloth1.name,
  description: cloth1.description,
  imagesIds: cloth1.images.map((e) => e.id).toList(),
  tagsIds: cloth1.tags.map((e) => e.id).toList(),
  favourite: cloth1.favourite,
  order: cloth1.order,
  creationDate: cloth1.creationDate,
);
final clothModel2 = ClothModel(
  id: cloth2.id,
  name: cloth2.name,
  description: cloth2.description,
  imagesIds: cloth2.images.map((e) => e.id).toList(),
  tagsIds: cloth2.tags.map((e) => e.id).toList(),
  favourite: cloth2.favourite,
  order: cloth2.order,
  creationDate: cloth2.creationDate,
);

String _mapClothTagTypeToString(ClothTagType type) {
  switch (type) {
    case ClothTagType.clothKind:
      return 'clothKind';
    case ClothTagType.color:
      return 'color';
    case ClothTagType.other:
      return 'other';
  }
}
