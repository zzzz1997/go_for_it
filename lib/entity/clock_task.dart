import 'package:json_annotation/json_annotation.dart';
import 'package:go_for_it/entity/task.dart';

part 'clock_task.g.dart';

///
/// 打卡任务实体
///
@JsonSerializable()
class ClockTask extends Task {
  int type;

  ClockTask(int id, String name, this.type, int importance, int startTime,
      int endTime, int createdTime)
      : super(id, name, importance, startTime, endTime, createdTime);

  factory ClockTask.fromJson(Map<String, dynamic> json) =>
      _$ClockTaskFromJson(json);

  Map<String, dynamic> toJson() => _$ClockTaskToJson(this);
}
