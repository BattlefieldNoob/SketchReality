import 'package:json_annotation/json_annotation.dart';

part 'image.g.dart';

@JsonSerializable()
class Image {
  final String uid;
  final int size;
  final int width;
  final String url;
  final int height;

  Image(this.uid, this.size, this.width, this.url, this.height);

  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);
  Map<String, dynamic> toJson() => _$ImageToJson(this);
}
