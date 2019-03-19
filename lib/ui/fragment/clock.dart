import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_for_it/model/main.dart';
import 'package:go_for_it/ui/view/calendar.dart';
import 'package:go_for_it/util/constant.dart';

///
/// 每日打卡
///
class ClockFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainStateModel>(
      builder: (context, widget, model) {
        double _height = ScreenUtil().setHeight(Constant.height) -
            Constant.appBarHeight -
            MediaQueryData.fromWindow(window).padding.top;
        double _rowHeight = _height -
            Constant.rowHeight -
            2 * Constant.lineHeight -
            2 * Constant.listPadding -
            model.tasks.length * Constant.taskHeight;
        return Scaffold(
          appBar: AppBar(),
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
      },
    );
  }
}
