import 'package:clothes/features/clothes/domain/entities/cloth_image.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cloth_image_model.g.dart';

@JsonSerializable()
class ClothImageModel extends Equatable {
  final int id;
  final String path;

  const ClothImageModel({
    required this.id,
    required this.path,
  });

  factory ClothImageModel.fromEntity(ClothImage clothImage) {
    return ClothImageModel(
      id: clothImage.id,
      path: clothImage.path,
    );
  }

  ClothImage toEntity() {
    return ClothImage(
      id: id,
      path: path,
    );
  }

  factory ClothImageModel.fromJson(Map<String, dynamic> json) =>
      _$ClothImageModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClothImageModelToJson(this);

  @override
  List<Object?> get props => [id, path];
}
