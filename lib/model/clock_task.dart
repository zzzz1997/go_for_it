import 'dart:math';
import 'package:scoped_model/scoped_model.dart';
import 'package:go_for_it/entity/clock_step.dart';
import 'package:go_for_it/entity/clock_task.dart';

///
/// 打卡任务管理
///
abstract class ClockTaskModel extends Model {

  // 打卡任务列表
  List<ClockTask> _clockTasks;

  // 获取打卡任务列表
  List<ClockTask> get clockTasks => _clockTasks;

  // 打卡足迹
  List<ClockStep> _clockSteps;

  // 获取打卡足迹
  List<ClockStep> get clockSteps => _clockSteps;

  factory ClockTaskModel._() => null;

  ///
  /// 获取打卡任务
  ///
  getClockTask() {
    Random random = Random();
    int length = random.nextInt(10) + 5;
    _clockTasks = List(length);
    for (int i = 0; i < length; i++) {
      int startTime = random.nextInt(10000000) + 1590000000;
      _clockTasks[i] = ClockTask(
        i,
        '打卡任务$i',
        random.nextInt(2),
        random.nextInt(4),
        startTime,
        random.nextInt(10000000) + startTime,
        0);
    }
    _clockSteps = List(100);
    for (int i = 0; i < 100; i++) {
      int index = random.nextInt(length);
      _clockSteps[i] = ClockStep(
        i,
        index,
        random.nextInt(_clockTasks[index].endTime - _clockTasks[index].startTime) + _clockTasks[index].startTime,
      );
    }
  }
}