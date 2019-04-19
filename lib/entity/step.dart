import 'package:json_annotation/json_annotation.dart';

part 'step.g.dart';

///
/// 打卡任务实体
///
@JsonSerializable()
class Step {
  int id;
  int taskId;
  int createdTime;

  Step(this.id, this.taskId, this.createdTime);

  factory Step.fromJson(Map<String, dynamic> json) =>
      _$StepFromJson(json);

  Map<String, dynamic> toJson() => _$StepToJson(this);
}
