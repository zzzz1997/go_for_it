import 'package:scoped_model/scoped_model.dart';
import 'package:go_for_it/entity/step.dart';
import 'package:go_for_it/entity/task.dart';
import 'package:go_for_it/util/database_helper.dart';

///
/// 任务状态管理
///
abstract class TaskModel extends Model {
  // 普通任务时间列表
  List<int> _timeTaskTimes = [];

  // 获取普通任务时间列表
  List<int> get timeTaskTimes => _timeTaskTimes;

  // 普通任务列表
  List<Task> _timeTasks = [];

  // 获取普通任务列表
  List<Task> get timeTasks => _timeTasks;

  // 打卡任务列表
  List<Task> _clockTasks = [];

  // 获取打卡任务列表
  List<Task> get clockTasks => _clockTasks;

  // 打卡足迹
  late List<Step> _steps;

  // 获取打卡足迹
  List<Step> get steps => _steps;

  // 打卡锁
  List<int> _clockLocks = [];

  // 获取打卡锁
  List<int> get clockLocks => _clockLocks;

  // 今日任务时间列表
  List<Task> _todayTasks = [];

  // 获取今日任务时间列表
  List<Task> get todayTasks => _todayTasks;

  // 今日打卡足迹
  late List<Step> _todaySteps;

  // 获取今日打卡足迹
  List<Step> get todaySteps => _todaySteps;

  ///
  /// 获取普通任务
  ///
  Future<void> getTimeTask(DateTime dateTime) async {
    _timeTaskTimes = await DatabaseHelper().queryTimeTaskTimeList();
    _timeTasks = await DatabaseHelper().queryTimeTask(dateTime);
  }

  ///
  /// 获取打卡任务
  ///
  Future<void> getClockTask() async {
    _clockTasks = await DatabaseHelper().queryClockTask();
    _steps = await DatabaseHelper().queryStep();
  }

  ///
  /// 获取今日任务
  ///
  Future<void> getTodayTask() async {
    _todayTasks = await DatabaseHelper().queryTodayTask();
    _todaySteps = await DatabaseHelper().queryStep();
  }

  ///
  /// 更改普通任务状态
  ///
  Future<void> changeTimeTaskStatus(int id, int checkMode, int index) async {
    Task task = (index == 1 ? _timeTasks : _todayTasks)[
        (index == 1 ? _timeTasks : _todayTasks)
            .indexWhere((task) => task.id == id)];
    task.status = (task.status + 1 + (checkMode == 0 ? 1 : 0)) > 2
        ? 0
        : task.status + 1 + (checkMode == 0 ? 1 : 0);
    await DatabaseHelper().updateTask(task);
    notifyListeners();
  }

  ///
  /// 更改打卡任务状态
  ///
  Future<void> changeClockTaskStatus(
      int id, int stepIndex, DateTime date, int index) async {
    if (clockLocks.indexOf(id) > -1) {
      return;
    } else {
      _clockLocks.add(id);
      notifyListeners();
      if (stepIndex > -1) {
        Step step = (index == 0 ? _steps : _todaySteps)[stepIndex];
        await DatabaseHelper().deleteStep(step);
        (index == 0 ? _steps : _todaySteps).remove(step);
      } else {
        Step step = Step(0, id, date.millisecondsSinceEpoch ~/ 1000,
            DateTime.now().millisecondsSinceEpoch ~/ 1000);
        step.id = await DatabaseHelper().insertStep(step);
        (index == 0 ? _steps : _todaySteps).add(step);
      }
      _clockLocks.remove(id);
      notifyListeners();
    }
  }

  ///
  /// 保存任务
  ///
  Future<void> saveTask(Task task, String name, String description) async {
    task.name = name;
    task.description = description;
    if (task.id == -1) {
      await DatabaseHelper().insertTask(task);
    } else {
      await DatabaseHelper().updateTask(task);
    }
  }

  ///
  /// 删除任务
  ///
  Future<void> deleteTask(Task task) async {
    if (task.id == -1) {
      return;
    }
    await DatabaseHelper().deleteTask(task);
    if (task.type == 0) {
      _timeTaskTimes.removeAt(
          _timeTaskTimes.indexWhere((time) => time == task.startTime));
      _timeTasks.removeWhere((t) => t.id == task.id);
    } else {
      _clockTasks.removeWhere((t) => t.id == task.id);
    }
  }
}
