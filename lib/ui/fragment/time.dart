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

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainStateModel>(
      builder: (context, widget, model) {
        double _height = ScreenUtil().setHeight(Constant.height) -
          Constant.appBarHeight -
          MediaQueryData.fromWindow(window).padding.top;
        double _rowHeight = _height -
          Constant.rowHeight -
          Constant.lineHeight -
          2 * Constant.listPadding -
          model.tasks.length * Constant.taskHeight;
        return Scaffold(
          appBar: AppBar(
            title: Text('${model.date.month}/${model.date.day}'),
            actions: <Widget>[
              model.date != model.today
                ? GestureDetector(
                onTap: () {
                  model.updateDate(model.today);
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
            width: ScreenUtil().setWidth(Constant.width),
            height: _height,
            themeData: model.themeData,
            today: model.today,
            date: model.date,
            tasks: model.tasks,
            rowHeight: _rowHeight > 0 ? _rowHeight : 0.0,
            swiperIndex: model.swiperIndex,
            isWeek: model.isWeek,
            onDateChange: (DateTime dateTime) {
              model.updateDate(dateTime);
            },
            onTaskStatusChange: (int id) {
              model.changeTaskStatus(id);
            },
            onSwiperIndexChange: (int index) {
              model.changeSwiperIndex(index);
            },
            onScroll: (double position) {
              model.onScroll(position);
            },
          )
            : SizedBox(),
        );
      });
  }
}
