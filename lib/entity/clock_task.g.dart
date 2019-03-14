// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clock_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClockTask _$ClockTaskFromJson(Map<String, dynamic> json) {
  return ClockTask(
      json['id'] as int,
      json['name'] as String,
      json['type'] as int,
      json['importance'] as int,
      json['startTime'] as int,
      json['endTime'] as int,
      json['createdTime'] as int);
}

Map<String, dynamic> _$ClockTaskToJson(ClockTask instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'importance': instance.importance,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'createdTime': instance.createdTime,
      'type': instance.type
    };
