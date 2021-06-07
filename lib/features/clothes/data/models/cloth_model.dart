import 'package:clothes/features/clothes/domain/entities/cloth.dart';
import 'package:clothes/features/clothes/domain/entities/cloth_image.dart';
import 'package:clothes/features/clothes/domain/entities/cloth_tag.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cloth_model.g.dart';

@JsonSerializable()
class ClothModel extends Equatable {
  final int id;
  final String name;
  final String description;
  final List<int> imagesIds;
  final List<int> tagsIds;
  final bool favourite;
  final int order;
  final DateTime creationDate;

  const ClothModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imagesIds,
    required this.tagsIds,
    required this.favourite,
    required this.order,
    required this.creationDate,
  });

  factory ClothModel.fromEntity(Cloth cloth) {
    return ClothModel(
      id: cloth.id,
      name: cloth.name,
      description: cloth.description,
      imagesIds: cloth.images.map((e) => e.id).toList(),
      tagsIds: cloth.tags.map((e) => e.id).toList(),
      favourite: cloth.favourite,
      order: cloth.order,
      creationDate: cloth.creationDate,
    );
  }

  Cloth toEntity({
    required List<ClothImage> images,
    required List<ClothTag> tags,
  }) {
    return Cloth(
      id: id,
      name: name,
      description: description,
      images: imagesIds
          .map((id) => images.firstWhere((image) => image.id == id))
          .toList(),
      tags:
          tagsIds.map((id) => tags.firstWhere((tag) => tag.id == id)).toList(),
      favourite: favourite,
      order: order,
      creationDate: creationDate,
    );
  }

  factory ClothModel.fromJson(Map<String, dynamic> json) =>
      _$ClothModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClothModelToJson(this);

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        imagesIds,
        tagsIds,
        favourite,
        order,
        creationDate,
      ];
}
