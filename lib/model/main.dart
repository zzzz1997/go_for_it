import 'dart:math';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:go_for_it/entity/time_task.dart';
import 'package:go_for_it/model/calendar.dart';

///
/// 主状态管理
///
class MainStateModel extends Model with CalendarModel {
  // 定义主题
  ThemeData _themeData;

  // 获取主题
  ThemeData get themeData => _themeData;

  // 今天
  DateTime _today;

  // 获取今天
  DateTime get today => _today;

  // 选择日期
  DateTime _date;

  // 获取所选日期
  DateTime get date => _date;

  // 任务列表
  List<TimeTask> _tasks;

  // 获取任务列表
  List<TimeTask> get tasks => _tasks;

  MainStateModel(context) {
    _initApp(context);
  }

  ///
  /// 初始化app
  ///
  _initApp(context) async {
    _themeData = Theme.of(context).copyWith(
        primaryColor: Colors.blueAccent, accentColor: Colors.cyanAccent);
    _today =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    _date =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    _tasks = getTask(_date);
  }

  ///
  /// 设置时间
  ///
  setDate(DateTime dateTime) {
    _date = dateTime;
    _tasks = getTask(_date);
    notifyListeners();
  }

  ///
  /// 刷新任务列表
  ///
  List<TimeTask> getTask(DateTime dateTime) {
    Random random = Random();
    int length = random.nextInt(15) + 5;
    List<TimeTask> tasks = List(length);
    for (int i = 0; i < length; i++) {
      tasks[i] = TimeTask(i, '${dateTime.day}日的任务$i', 0, 0, 0, random.nextInt(2), 0);
    }
    return tasks;
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
