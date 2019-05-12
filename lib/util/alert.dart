import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:go_for_it/util/constant.dart';

///
/// 提示工具类
///
class Alert {
  ///
  /// 吐司
  ///
  static toast(String msg,
      {Toast toastLength = Toast.LENGTH_SHORT,
        ToastGravity gravity = ToastGravity.BOTTOM,
        int timeInSecForIos = 1,
        Color backgroundColor = const Color.fromARGB(255, 102, 102, 102),
        Color textColor = Colors.white}) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: toastLength,
        gravity: gravity,
        timeInSecForIos: timeInSecForIos,
        backgroundColor: backgroundColor,
        textColor: textColor);
  }

  ///
  /// 成功提醒bar
  ///
  static successBar(BuildContext context, String message) {
    FlushbarHelper.createSuccess(message: message, duration: Duration(seconds: 2))
      ..show(context);
  }

  ///
  /// 错误提醒bar
  ///
  static errorBar(BuildContext context, String message) {
    FlushbarHelper.createError(message: message, duration: Duration(seconds: 2))
      ..show(context);
  }

  ///
  /// 抛出错误错误提醒bar
  ///
  static errorBarError(BuildContext context, Error e) {
    errorBar(context, e.toString() ?? 'error');
  }

  ///
  /// 创建确定选择弹窗
  ///
  static showConfirm(BuildContext context, String name, Function callback) {
    showDialog<Null>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(Constant.warning),
              content: Text(name),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(Constant.cancel)),
                FlatButton(
                    onPressed: () {
                      callback();
                      Navigator.pop(context);
                    },
                    child: Text(Constant.confirm))
              ]);
        });
  }

  ///
  /// 展示关于弹窗
  ///
  static showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AboutDialog(
          applicationIcon: FlutterLogo(),
          applicationName: Constant.appTag,
          applicationVersion: 'V1.0.0',
          applicationLegalese: Constant.appLegalese,
          children: <Widget>[
            Text(Constant.appDescription),
          ],
        );
      }
    );
  }
}