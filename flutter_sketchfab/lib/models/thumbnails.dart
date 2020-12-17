import 'package:json_annotation/json_annotation.dart';

import 'image.dart';

part 'thumbnails.g.dart';

@JsonSerializable()
class Thumbnails {
  final List<Image> images;

  Thumbnails(this.images);

  factory Thumbnails.fromJson(Map<String, dynamic> json) =>
      _$ThumbnailsFromJson(json);
  Map<String, dynamic> toJson() => _$ThumbnailsToJson(this);
}
