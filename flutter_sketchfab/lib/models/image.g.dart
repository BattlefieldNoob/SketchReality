// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Image _$ImageFromJson(Map<String, dynamic> json) {
  return Image(
    json['uid'] as String,
    json['size'] as int,
    json['width'] as int,
    json['url'] as String,
    json['height'] as int,
  );
}

Map<String, dynamic> _$ImageToJson(Image instance) => <String, dynamic>{
      'uid': instance.uid,
      'size': instance.size,
      'width': instance.width,
      'url': instance.url,
      'height': instance.height,
    };
