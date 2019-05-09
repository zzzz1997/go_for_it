// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
      json['id'] as int,
      json['username'] as String,
      json['avatar'] as String,
      json['language'] as int,
      json['startDayOfWeek'] as int,
      json['checkMode'] as int,
      json['token'] as String,
      json['tokenTime'] as int,
      false,
      json['createdTime'] as int);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'avatar': instance.avatar,
      'language': instance.language,
      'startDayOfWeek': instance.startDayOfWeek,
      'checkMode': instance.checkMode,
      'token': instance.token,
      'tokenTime': instance.tokenTime,
      'createdTime': instance.createdTime
    };
