// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) {
  return Task(
    json['id'] as int,
    json['type'] as int,
    json['classification'] as int,
    json['name'] as String,
    json['description'] as String,
    json['importance'] as int,
    json['status'] as int,
    json['startTime'] as int,
    json['endTime'] as int,
    json['createdTime'] as int,
  );
}

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'classification': instance.classification,
      'name': instance.name,
      'description': instance.description,
      'importance': instance.importance,
      'status': instance.status,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'createdTime': instance.createdTime,
    };
