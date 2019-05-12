import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_format/date_format.dart';
import 'package:go_for_it/entity/task.dart';
import 'package:go_for_it/model/main.dart';
import 'package:go_for_it/ui/view/calendar.dart';
import 'package:go_for_it/ui/view/half_check_box.dart';
import 'package:go_for_it/ui/view/importance_view.dart';
import 'package:go_for_it/util/constant.dart';
import 'package:go_for_it/util/modal.dart';

// 任务高度
const _taskHeight = 60.0;

// 卡片边距（list使用card包裹需要填充边距）
const _cardPadding = 4.0;

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
          CalendarParam.rowHeight -
          2 * CalendarParam.lineHeight -
          2 * CalendarParam.listPadding -
          model.timeTasks.length * _taskHeight +
          _cardPadding;
      return Scaffold(
        body: ScreenUtil().setWidth(Constant.width) > 0
            ? Calendar(
                width: ScreenUtil().setWidth(Constant.width),
                height: _height,
                startDayOfWeek: model.user.startDayOfWeek,
                language: model.user.language,
                today: model.today,
                date: model.date,
                taskTimes: model.timeTaskTimes,
                swiperIndex: model.swiperIndex,
                isWeek: model.isWeek,
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    if (index == model.timeTasks.length) {
                      return SizedBox(
                        height: _rowHeight > 0 ? _rowHeight : 0.0,
                      );
                    }
                    Task task = model.timeTasks[index];
                    return GestureDetector(
                      onTap: () {
                        ModalUtil.showTaskModal(context, task, task.type);
                      },
                      child: Material(
                        child: SizedBox(
                          height: _taskHeight,
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      ImportanceView(
                                          importance: task.importance),
                                      Text(
                                        task.name,
                                        style: TextStyle(
                                            decoration: task.status == 2
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,
                                            color: task.status == 2
                                                ? model.themeData.textTheme
                                                    .body1.color
                                                    .withOpacity(
                                                        CalendarParam.opacity)
                                                : model.themeData.textTheme
                                                    .body1.color),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(formatDate(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              task.startTime * 1000),
                                          [HH, ':', nn])),
                                      HalfCheckBox(
                                        status: task.status,
                                        color: model.themeData.primaryColor,
                                        onPressed: () {
                                          model.changeTimeTaskStatus(
                                              task.id, model.user.checkMode);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Divider(
                                height: 5,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: model.timeTasks.length + 1,
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
    });
  }
}
