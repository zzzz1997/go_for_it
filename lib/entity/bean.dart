import 'package:json_annotation/json_annotation.dart';
import 'package:go_for_it/entity/step.dart';
import 'package:go_for_it/entity/task.dart';

part 'bean.g.dart';

///
/// 备份信息数据实体
///
@JsonSerializable()
class Bean {
  List<Task> tasks;
  List<Step> steps;

  Bean(this.tasks, this.steps);

  factory Bean.fromJson(Map<String, dynamic> json) => _$BeanFromJson(json);

  Map<String, dynamic> toJson() => _$BeanToJson(this);
}
