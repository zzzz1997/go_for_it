import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gtd_task/model/main.dart';
import 'package:gtd_task/ui/view/calendar.dart';
import 'package:gtd_task/util/constant.dart';

///
/// 主页面
///
class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

///
/// 主页面状态
///
class _HomePageState extends State<HomePage> {

  GlobalKey<CalendarState> _calendarKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // 初始化ScreenUtil
    ScreenUtil.instance =
        ScreenUtil(width: Constant.width, height: Constant.height)
          ..init(context);
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
                Constant.todaySvg,
                width: 24.0,
                color: Colors.white,
              ),
            )
              : SizedBox()
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
                onTaskStatusChange: (int id, bool status) {
                  model.changeTaskStatus(id, status);
                },
              )
            : SizedBox(),
      );
    });
  }
}
