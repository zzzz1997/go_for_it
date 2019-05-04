import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_for_it/entity/task.dart';
import 'package:go_for_it/model/main.dart';
import 'package:go_for_it/ui/view/calendar.dart';
import 'package:go_for_it/ui/view/clock_progress.dart';
import 'package:go_for_it/ui/view/half_check_box.dart';
import 'package:go_for_it/ui/view/importance_view.dart';
import 'package:go_for_it/util/constant.dart';

// 任务高度
const _taskHeight = 70.0;

// 卡片边距（list使用card包裹需要填充边距）
const _cardPadding = 4;

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
          MediaQueryData
            .fromWindow(window)
            .padding
            .top;
        double _rowHeight = _height -
          CalendarParam.rowHeight -
          2 * CalendarParam.lineHeight -
          2 * CalendarParam.listPadding -
          model.clockTasks.length * _taskHeight + _cardPadding;
        return Scaffold(
          body: ScreenUtil().setWidth(Constant.width) > 0
            ? Calendar(
            width: ScreenUtil().setWidth(Constant.width),
            height: _height,
            themeData: model.themeData,
            startDayOfWeek: model.user.startDayOfWeek,
            language: model.user.language,
            today: model.today,
            date: model.date,
            swiperIndex: model.swiperIndex,
            isWeek: model.isWeek,
            delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                if (index == model.clockTasks.length) {
                  return SizedBox(
                    height: _rowHeight > 0 ? _rowHeight : 0.0,
                  );
                }
                Task task = model.clockTasks[index];
                var steps = model.steps
                  .where((step) =>
                step.taskId == task.id).toList();
                int length = steps.length;
                List<int> data = List(length);
                for (int i = 0; i < length; i++) {
                  data[i] = DateTime
                    .fromMillisecondsSinceEpoch(steps[i].createdTime * 1000)
                    .difference(DateTime.fromMillisecondsSinceEpoch(
                    task.startTime * 1000))
                    .inDays;
                }
                return Material(
                  child: SizedBox(
                    height: _taskHeight,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                ImportanceView(importance: task.importance),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      task.name,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text.rich(
                                      TextSpan(children: <TextSpan>[
                                        TextSpan(text: '已坚持'),
                                        TextSpan(
                                          text:
                                          length
                                            .toString(),
                                          style:
                                          TextStyle(color: Colors.red)),
                                        TextSpan(text: '天')
                                      ]),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            HalfCheckBox(
                              status: HalfCheckBoxStatus.values[1],
                              color: model.themeData.primaryColor,
                              onPressed: () {
                                // model.changeTaskStatus(task.id);
                              },
                            )
                          ],
                        ),
                        ClockProgress(
                          width: ScreenUtil().setWidth(Constant.width),
                          height: 5,
                          frontColor: Colors.grey,
                          backColor: Colors.grey.withOpacity(0.2),
                          total: DateTime
                            .fromMillisecondsSinceEpoch(task.endTime * 1000)
                            .difference(DateTime.fromMillisecondsSinceEpoch(
                            task.startTime * 1000))
                            .inDays
                            .abs(),
                          data: data,
                        )
                      ],
                    )
                  ),
                );
              },
              childCount: model.clockTasks.length + 1,
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
