import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_for_it/entity/time_task.dart';
import 'package:go_for_it/model/main.dart';
import 'package:go_for_it/ui/view/calendar.dart';
import 'package:go_for_it/ui/view/half_check_box.dart';
import 'package:go_for_it/util/constant.dart';

// 任务高度
const _taskHeight = 70.0;

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
            model.tasks.length * _taskHeight;
        return Scaffold(
          appBar: AppBar(),
          body: ScreenUtil().setWidth(Constant.width) > 0
              ? Calendar(
                  width: ScreenUtil().setWidth(Constant.width),
                  height: _height,
                  themeData: model.themeData,
                  today: model.today,
                  date: model.date,
                  swiperIndex: model.swiperIndex,
                  isWeek: model.isWeek,
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      if (index == model.tasks.length) {
                        return SizedBox(
                          height: _rowHeight > 0 ? _rowHeight : 0.0,
                        );
                      }
                      TimeTask task = model.tasks[index];
                      return SizedBox(
                        height: _taskHeight,
                        child: Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                task.name,
                                style: TextStyle(
                                    decoration: task.status ==
                                            HalfCheckBoxStatus.CHECKED.index
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    color: task.status ==
                                            HalfCheckBoxStatus.CHECKED.index
                                        ? model.themeData.textTheme.body1.color
                                            .withOpacity(Constant.opacity)
                                        : model
                                            .themeData.textTheme.body1.color),
                              ),
                              HalfCheckBox(
                                status: HalfCheckBoxStatus.values[task.status],
                                color: model.themeData.primaryColor,
                                onPressed: () {
                                  model.changeTaskStatus(task.id);
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: model.tasks.length + 1,
                  ),
                  onDateChange: (DateTime dateTime) {
                    model.updateDate(dateTime);
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
