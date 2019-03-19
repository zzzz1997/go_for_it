import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:go_for_it/model/calendar.dart';
import 'package:go_for_it/model/clock_task.dart';
import 'package:go_for_it/model/time_task.dart';

///
/// 主状态管理
///
class MainStateModel extends Model
    with CalendarModel, ClockTaskModel, TimeTaskModel {
  // 定义主题
  ThemeData _themeData;

  // 获取主题
  ThemeData get themeData => _themeData;

  MainStateModel(context) {
    _initApp(context);
  }

  ///
  /// 初始化app
  ///
  _initApp(context) async {
    _themeData = Theme.of(context).copyWith(
        primaryColor: Colors.blueAccent, accentColor: Colors.cyanAccent);
    DateTime dateTime = initDate();
    getTask(dateTime);
  }

  ///
  /// 更新时间
  ///
  updateDate(DateTime dateTime) {
    setDate(dateTime);
    getTask(dateTime);
    notifyListeners();
  }
}
