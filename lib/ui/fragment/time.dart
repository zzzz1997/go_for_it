import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_for_it/model/main.dart';
import 'package:go_for_it/ui/view/calendar.dart';
import 'package:go_for_it/util/constant.dart';

///
/// 时间表
///
class TimeFragment extends StatelessWidget {

  // 日历键
  final GlobalKey<CalendarState> _calendarKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainStateModel>(
      builder: (context, widget, model) {
        return Scaffold(
          appBar: AppBar(
            title: Text('${model.date.month}/${model.date.day}'),
            actions: <Widget>[
              model.date != model.today
                ? GestureDetector(
                onTap: () {
                  model.setDate(model.today);
                  _calendarKey.currentState.setDateTask(model.today, model.tasks);
                },
                child: SvgPicture.asset(
                  Constant.todaySVG,
                  width: 24.0,
                  color: Colors.white,
                ),
              )
                : SizedBox(),
            ],
          ),
          body: ScreenUtil().setWidth(Constant.width) > 0
            ? Calendar(
            key: _calendarKey,
            width: ScreenUtil().setWidth(Constant.width),
            height: ScreenUtil().setHeight(Constant.height) -
              Constant.appBarHeight -
              MediaQueryData.fromWindow(window).padding.top,
            themeData: model.themeData,
            today: model.today,
            date: model.date,
            tasks: model.tasks,
            onDateChange: (DateTime dateTime) {
              model.setDate(dateTime);
              _calendarKey.currentState.setDateTask(model.date, model.tasks);
            },
            onTaskStatusChange: (int id) {
              model.changeTaskStatus(id);
            },
          )
            : SizedBox(),
        );
      });
  }
}
