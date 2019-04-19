import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

///
/// 任务实体
///
@JsonSerializable()
class Task {
  int id;
  int type;
  int classification;
  String name;
  int importance;
  int status;
  int startTime;
  int endTime;
  int createdTime;

  Task(this.id, this.type, this.classification, this.name, this.importance,
      this.status, this.startTime, this.endTime, this.createdTime);

  factory Task.fromJson(Map<String, dynamic> json) =>
      _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
