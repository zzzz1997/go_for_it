import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:connectivity/connectivity.dart';
import 'package:go_for_it/model/backup.dart';
import 'package:go_for_it/model/calendar.dart';
import 'package:go_for_it/model/task.dart';
import 'package:go_for_it/model/user.dart';

///
/// 主状态管理
///
class MainStateModel extends Model
    with BackupModel, CalendarModel, TaskModel, UserModel {
  // 定义主题
  ThemeData _themeData;

  // 获取主题
  ThemeData get themeData => _themeData;

  // 网络连接状态
  ConnectivityResult _connectivityResult;

  // 获取网络连接状态
  ConnectivityResult get connectivityResult => _connectivityResult;

  // 当前位置
  int _currentIndex = 0;

  // 获取当前位置
  int get currentIndex => _currentIndex;

  MainStateModel(context, connectivityResult) {
    _initApp(context, connectivityResult);
  }

  ///
  /// 初始化app
  ///
  _initApp(context, connectivityResult) async {
    _themeData = Theme.of(context).copyWith(
        primaryColor: Colors.blueAccent, accentColor: Colors.cyanAccent);
    _connectivityResult = connectivityResult;
    initDate();
    getClockTask();
    initUser();
  }

  ///
  /// 更改当前页面
  ///
  changePage(int index) {
    _currentIndex = index;
    if (currentIndex == 1) {
      getTimeTask(date);
    }
    notifyListeners();
  }

  ///
  /// 更新时间
  ///
  updateDate(DateTime dateTime) {
    setDate(dateTime);
    if (currentIndex == 0) {
      getClockTask();
    } else if (currentIndex == 1) {
      getTimeTask(dateTime);
    }
    notifyListeners();
  }
}
