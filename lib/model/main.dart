import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

///
/// 主状态管理
///
class MainStateModel extends Model {
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
      primaryColor: Colors.blueAccent, accentColor: Colors.greenAccent);
  }
}