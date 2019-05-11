import 'dart:math';
import 'package:scoped_model/scoped_model.dart';
import 'package:go_for_it/entity/step.dart';
import 'package:go_for_it/entity/task.dart';

///
/// 任务状态管理
///
abstract class TaskModel extends Model {
  // 普通任务列表
  List<Task> _timeTasks;

  // 获取普通任务列表
  List<Task> get timeTasks => _timeTasks;

  // 打卡任务列表
  List<Task> _clockTasks;

  // 获取打卡任务列表
  List<Task> get clockTasks => _clockTasks;

  // 打卡足迹
  List<Step> _steps;

  // 获取打卡足迹
  List<Step> get steps => _steps;

  factory TaskModel._() => null;

  ///
  /// 刷新任务列表
  ///
  getTimeTask(DateTime dateTime) {
    Random random = Random();
    int length = random.nextInt(10) + 5;
    _timeTasks = List(length);
    for (int i = 0; i < length; i++) {
      _timeTasks[i] = Task(
          i,
          0,
          0,
          '${dateTime.day}日的任务$i',
          '',
          random.nextInt(4),
          random.nextInt(3),
          dateTime.millisecondsSinceEpoch ~/ 1000 + random.nextInt(86400),
          0,
          0);
    }
  }

  ///
  /// 获取打卡任务
  ///
  getClockTask() {
    Random random = Random();
    int length = random.nextInt(10) + 5;
    _clockTasks = List(length);
    for (int i = 0; i < length; i++) {
      int startTime = random.nextInt(10000000) + 1590000000;
      _clockTasks[i] = Task(
          i,
          1,
          random.nextInt(2),
          '打卡任务$i',
          '',
          random.nextInt(4),
          random.nextInt(3),
          startTime,
          random.nextInt(10000000) + startTime,
          0);
    }
    _steps = List(100);
    for (int i = 0; i < 100; i++) {
      int index = random.nextInt(length);
      _steps[i] = Step(
        i,
        index,
        random.nextInt(
            _clockTasks[index].endTime - _clockTasks[index].startTime) +
            _clockTasks[index].startTime,
        random.nextInt(
            _clockTasks[index].endTime - _clockTasks[index].startTime) +
            _clockTasks[index].startTime,
      );
    }
  }

  ///
  /// 更改普通任务状态
  ///
  changeTimeTaskStatus(int id, int checkMode) {
    Task task = _timeTasks[_timeTasks.indexWhere((task) => task.id == id)];
    task.status = (task.status + 1 + (checkMode == 0 ? 1 : 0)) > 2 ? 0 : task.status + 1 + (checkMode == 0 ? 1 : 0);
    notifyListeners();
  }

  ///
  /// 更改打卡任务状态
  ///
  changeClockTaskStatus(int id) {
    Task task = _clockTasks[_clockTasks.indexWhere((task) => task.id == id)];
    task.status = (task.status + 2) > 2 ? 0 : task.status + 2;
    notifyListeners();
  }
}