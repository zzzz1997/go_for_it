import 'package:json_annotation/json_annotation.dart';
import 'package:go_for_it/entity/task.dart';

part 'time_task.g.dart';

///
/// 普通任务实体
///
@JsonSerializable()
class TimeTask extends Task {
  int status;

  TimeTask(int id, String name, int importance, int startTime, int endTime,
      this.status, int createdTime)
      : super(id, name, importance, startTime, endTime, createdTime);

  factory TimeTask.fromJson(Map<String, dynamic> json) =>
      _$TimeTaskFromJson(json);

  Map<String, dynamic> toJson() => _$TimeTaskToJson(this);
}
