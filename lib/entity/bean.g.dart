// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bean _$BeanFromJson(Map<String, dynamic> json) {
  return Bean(
    (json['tasks'] as List<dynamic>)
        .map((e) => Task.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['steps'] as List<dynamic>)
        .map((e) => Step.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$BeanToJson(Bean instance) => <String, dynamic>{
      'tasks': instance.tasks,
      'steps': instance.steps,
    };
