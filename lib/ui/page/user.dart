import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:go_for_it/model/main.dart';
import 'package:go_for_it/ui/page/home.dart';
import 'package:go_for_it/util/alert.dart';
import 'package:go_for_it/util/constant.dart';
import 'package:go_for_it/util/transition.dart';

///
/// 用户页面
///
class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainStateModel>(
        builder: (context, widget, model) {
      return Scaffold(
        appBar: AppBar(
          title: Text('User'),
        ),
        body: Column(
          children: <Widget>[
            Text('User'),
            RaisedButton(
              child: Text(Constant.exitLogin),
              onPressed: () {
                _exitLogin(context, model);
              },
            )
          ],
        ),
      );
    });
  }

  ///
  /// 退出登录
  ///
  _exitLogin(BuildContext context, MainStateModel model) async {
    try {
      await model.exitLogin();
      Transition.pushAndRemoveUntil(
          context, HomePage(), TransitionType.inFromBottom);
    } catch (e) {
      Alert.errorBar(context, e.toString() ?? 'error');
    }
  }
}
