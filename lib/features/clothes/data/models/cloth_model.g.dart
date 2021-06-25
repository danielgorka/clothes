// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cloth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClothModel _$ClothModelFromJson(Map<String, dynamic> json) {
  return ClothModel(
    id: json['id'] as int,
    name: json['name'] as String,
    description: json['description'] as String,
    imagesIds:
        (json['imagesIds'] as List<dynamic>).map((e) => e as int).toList(),
    tagsIds: (json['tagsIds'] as List<dynamic>).map((e) => e as int).toList(),
    favourite: json['favourite'] as bool,
    order: json['order'] as int,
    creationDate: DateTime.parse(json['creationDate'] as String),
  );
}

Map<String, dynamic> _$ClothModelToJson(ClothModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'imagesIds': instance.imagesIds,
      'tagsIds': instance.tagsIds,
      'favourite': instance.favourite,
      'order': instance.order,
      'creationDate': instance.creationDate.toIso8601String(),
    };
