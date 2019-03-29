import 'dart:math';
import 'package:scoped_model/scoped_model.dart';
import 'package:go_for_it/entity/time_task.dart';

///
/// 普通任务管理
///
abstract class TimeTaskModel extends Model {
  // 任务列表
  List<TimeTask> _tasks;

  // 获取任务列表
  List<TimeTask> get tasks => _tasks;

  factory TimeTaskModel._() => null;

  ///
  /// 刷新任务列表
  ///
  getTask(DateTime dateTime) {
    Random random = Random();
    int length = random.nextInt(10) + 5;
    _tasks = List(length);
    for (int i = 0; i < length; i++) {
      tasks[i] =
          TimeTask(i, '${dateTime.day}日的任务$i', random.nextInt(4), dateTime.millisecondsSinceEpoch + random.nextInt(86400000), 0, random.nextInt(2), 0);
    }
  }

  ///
  /// 更改任务状态
  ///
  changeTaskStatus(int id) {
    TimeTask task = _tasks[_tasks.indexWhere((task) => task.id == id)];
    task.status = (task.status + 1) > 2 ? 0 : task.status + 1;
    notifyListeners();
  }
}
