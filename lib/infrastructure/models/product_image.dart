import 'package:json_annotation/json_annotation.dart';

part 'product_image.g.dart';

@JsonSerializable()
class ProductImage {
  ProductImage(
    this.folderName,
    this.fileName,
  );

  factory ProductImage.fromJson(Map<String, dynamic> json) =>
      _$ProductImageFromJson(json);

  @JsonKey(name: 'folder_name')
  final String folderName;
  @JsonKey(name: 'file_name')
  final String fileName;
}
