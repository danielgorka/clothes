import 'package:clothes/features/clothes/data/models/cloth_image_model.dart';
import 'package:clothes/features/clothes/data/models/cloth_model.dart';
import 'package:clothes/features/clothes/data/models/cloth_tag_model.dart';

abstract class BaseClothesLocalDataSource {
  Stream<List<ClothModel>> getClothes();

  Future<ClothModel> getCloth(int id);

  Future<int> createCloth(ClothModel cloth);

  Future<void> updateCloth(ClothModel cloth);

  Future<void> deleteCloth(int id);

  Stream<List<ClothTagModel>> getClothTags();

  Future<ClothTagModel> getClothTag(int id);

  Future<int> createClothTag(ClothTagModel tag);

  Future<void> updateClothTag(ClothTagModel tag);

  Future<void> deleteClothTag(int id);

  Stream<List<ClothImageModel>> getClothImages();

  Future<ClothImageModel> getClothImage(int id);

  Future<int> createClothImage(ClothImageModel image);

  Future<void> updateClothImage(ClothImageModel image);

  Future<void> deleteClothImage(int id);
}
