import 'package:json_annotation/json_annotation.dart';

part 'backup.g.dart';

///
/// 打卡任务实体
///
@JsonSerializable()
class Backup {
  int id;
  String name;
  String backup;
  int createdTime;

  Backup(this.id, this.name, this.backup, this.createdTime);

  factory Backup.fromJson(Map<String, dynamic> json) =>
      _$BackupFromJson(json);

  Map<String, dynamic> toJson() => _$BackupToJson(this);
}
