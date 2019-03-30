// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clock_step.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClockStep _$ClockStepFromJson(Map<String, dynamic> json) {
  return ClockStep(json['id'] as int, json['clockTaskId'] as int,
      json['createdTime'] as int);
}

Map<String, dynamic> _$ClockStepToJson(ClockStep instance) => <String, dynamic>{
      'id': instance.id,
      'clockTaskId': instance.clockTaskId,
      'createdTime': instance.createdTime
    };
