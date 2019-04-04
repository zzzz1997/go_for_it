import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:go_for_it/model/main.dart';
import 'package:go_for_it/ui/view/calendar.dart';
import 'package:go_for_it/util/constant.dart';

///
/// 设置页面
///
class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainStateModel>(
      builder: (context, child, model) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: Text(Constant.setting),
          ),
          body: ListView(
            children: <Widget>[
              ListTile(
                onTap: () {
                  _onWeekLanguageTap(context);
                },
                title: Text(Constant.weekLanguage),
                subtitle: Text(Constant.languages[model.user.language]),
              ),
              ListTile(
                title: Text(Constant.weekStart),
                subtitle: Text(model.user.language == 0
                    ? '周${CalendarParam.weekCh[model.user.startDayOfWeek - 1]}'
                    : CalendarParam.weekEn[model.user.startDayOfWeek - 1]),
              )
            ],
          ),
        );
      },
    );
  }

  ///
  /// 星期语言点击事件
  ///
  _onWeekLanguageTap(BuildContext context) {

  }

  _showSelectDialog() {

  }
}
