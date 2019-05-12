import 'package:json_annotation/json_annotation.dart';

part 'step.g.dart';

///
/// 打卡足迹实体
///
@JsonSerializable()
class Step {
  int id;
  int taskId;
  int targetTime;
  int createdTime;

  Step(this.id, this.taskId, this.targetTime, this.createdTime);

  factory Step.fromJson(Map<String, dynamic> json) =>
      _$StepFromJson(json);

  Map<String, dynamic> toJson() => _$StepToJson(this);
}
