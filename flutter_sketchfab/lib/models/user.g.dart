// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['uid'] as String,
    json['username'] as String,
    json['displayName'] as String,
    json['profileUrl'] as String,
    json['account'] as String,
    json['avatar'] == null
        ? null
        : Avatar.fromJson(json['avatar'] as Map<String, dynamic>),
    json['uri'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'uid': instance.uid,
      'username': instance.username,
      'displayName': instance.displayName,
      'profileUrl': instance.profileUrl,
      'account': instance.account,
      'avatar': instance.avatar,
      'uri': instance.uri,
    };
