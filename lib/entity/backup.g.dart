// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Backup _$BackupFromJson(Map<String, dynamic> json) {
  return Backup(json['id'] as int, json['name'] as String, json['backup'] as String,
      json['createdTime'] as int);
}

Map<String, dynamic> _$BackupToJson(Backup instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'backup': instance.backup,
      'createdTime': instance.createdTime
    };
