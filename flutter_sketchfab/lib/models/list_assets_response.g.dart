// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_assets_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListAssetsResponse _$ListAssetsResponseFromJson(Map<String, dynamic> json) {
  return ListAssetsResponse(
    json['cursors'] == null
        ? null
        : Cursors.fromJson(json['cursors'] as Map<String, dynamic>),
    json['next'] as String,
    json['previous'] as String,
    (json['results'] as List)
        ?.map(
            (e) => e == null ? null : Asset.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ListAssetsResponseToJson(ListAssetsResponse instance) =>
    <String, dynamic>{
      'cursors': instance.cursors,
      'next': instance.next,
      'previous': instance.previous,
      'results': instance.results,
    };
