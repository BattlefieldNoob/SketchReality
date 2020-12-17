// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archives.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Archives _$ArchivesFromJson(Map<String, dynamic> json) {
  return Archives(
    json['gltf'] == null
        ? null
        : Gltf.fromJson(json['gltf'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ArchivesToJson(Archives instance) => <String, dynamic>{
      'gltf': instance.gltf,
    };
