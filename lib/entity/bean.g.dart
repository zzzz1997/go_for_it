// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Bean _$BeanFromJson(Map<String, dynamic> json) {
  return Bean(
      (json['tasks'] as List)
          ?.map((e) =>
              e == null ? null : Task.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      (json['steps'] as List)
          ?.map((e) =>
              e == null ? null : Step.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$BeanToJson(Bean instance) =>
    <String, dynamic>{'tasks': instance.tasks, 'steps': instance.steps};
