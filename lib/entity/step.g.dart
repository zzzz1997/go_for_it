// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'step.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Step _$StepFromJson(Map<String, dynamic> json) {
  return Step(
      json['id'] as int, json['taskId'] as int, json['targetTime'] as int, json['createdTime'] as int);
}

Map<String, dynamic> _$StepToJson(Step instance) => <String, dynamic>{
      'id': instance.id,
      'taskId': instance.taskId,
      'targetTime': instance.targetTime,
      'createdTime': instance.createdTime
    };
