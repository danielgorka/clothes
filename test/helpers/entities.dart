import 'package:clothes/features/clothes/domain/entities/cloth.dart';
import 'package:clothes/features/clothes/domain/entities/cloth_image.dart';
import 'package:clothes/features/clothes/domain/entities/cloth_tag.dart';

// ClothImage
const clothImage1 = ClothImage(
  id: 1,
  path: 'path/cloth1.png',
);
const clothImage2 = ClothImage(
  id: 2,
  path: 'path/cloth2.jpg',
);
const clothImage3 = ClothImage(
  id: 3,
  path: 'https://test.pl/images/cloth3.jpg',
);
const clothImages1 = [clothImage1, clothImage3];
const clothImages2 = [clothImage2];

// ClothTag
const clothTag1 = ClothTag(
  id: 1,
  type: ClothTagType.color,
  name: 'Red',
);
const clothTag2 = ClothTag(
  id: 2,
  type: ClothTagType.other,
  name: 'Winter',
);
const clothTag3 = ClothTag(
  id: 3,
  type: ClothTagType.other,
  name: 'Party',
);
const clothTags1 = [clothTag1, clothTag3];
const clothTags2 = [clothTag2];

// Cloth
final cloth1 = Cloth(
  id: 1,
  name: 'T-shirt',
  description: 'Too small',
  images: clothImages1,
  tags: clothTags1,
  favourite: true,
  order: 2,
  creationDate: DateTime(2017, 9, 7, 17, 30, 59, 1),
);
final cloth2 = Cloth(
  id: 2,
  name: 'Shorts',
  images: clothImages2,
  tags: clothTags2,
  creationDate: DateTime.now(),
);
final clothWithoutName = Cloth(
  id: 3,
  description: 'Very big',
  images: clothImages1,
  tags: clothTags1,
  favourite: true,
  order: 2,
  creationDate: DateTime.now(),
);
final clothWithoutImages = Cloth(
  id: 4,
  name: 'T-shirt',
  description: 'Too small',
  tags: clothTags1,
  favourite: true,
  order: 2,
  creationDate: DateTime.now(),
);

final clothes1 = [cloth1, clothWithoutName, clothWithoutImages];
final clothes2 = [cloth1, cloth2, clothWithoutName, clothWithoutImages];

final emptyClothes = <Cloth>[];
