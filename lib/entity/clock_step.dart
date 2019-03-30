import 'package:json_annotation/json_annotation.dart';

part 'clock_step.g.dart';

///
/// 打卡任务实体
///
@JsonSerializable()
class ClockStep {
  int id;
  int clockTaskId;
  int createdTime;

  ClockStep(this.id, this.clockTaskId, this.createdTime);

  factory ClockStep.fromJson(Map<String, dynamic> json) =>
      _$ClockStepFromJson(json);

  Map<String, dynamic> toJson() => _$ClockStepToJson(this);
}
