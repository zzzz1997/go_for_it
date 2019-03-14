// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeTask _$TimeTaskFromJson(Map<String, dynamic> json) {
  return TimeTask(
      json['id'] as int,
      json['name'] as String,
      json['importance'] as int,
      json['startTime'] as int,
      json['endTime'] as int,
      json['status'] as int,
      json['createdTime'] as int);
}

Map<String, dynamic> _$TimeTaskToJson(TimeTask instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'importance': instance.importance,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'createdTime': instance.createdTime,
      'status': instance.status
    };
