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
                  _showSelectDialog(context, model, Constant.weekLanguage,
                      Constant.weekLanguage);
                },
                title: Text(Constant.weekLanguage),
                subtitle: Text(Constant.languages[model.user.language]),
              ),
              ListTile(
                onTap: () {
                  _showSelectDialog(
                      context, model, Constant.weekStart, Constant.weekStart);
                },
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
  /// 选择设置
  ///
  _showSelectDialog(BuildContext context, MainStateModel model, String setting,
      String title) {
    int length = setting == Constant.weekLanguage
        ? Constant.languages.length
        : CalendarParam.weekCh.length;
    List<RadioListTile> _radioListTiles = List(length);
    for (int i = 0; i < length; i++) {
      _radioListTiles[i] = RadioListTile(
        value: i,
        title: Text(setting == Constant.weekLanguage
            ? Constant.languages[i]
            : model.user.language == 0
                ? '周${CalendarParam.weekCh[i]}'
                : CalendarParam.weekEn[i]),
        groupValue: setting == Constant.weekLanguage
            ? model.user.language
            : model.user.startDayOfWeek - 1,
        onChanged: (value) async {
          try {
            await model.setSelectSetting(setting, value);
          } catch (e) {
            // todo alert
          }
          Navigator.pop(context);
        },
      );
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: _radioListTiles,
            ),
          );
        });
  }
}
