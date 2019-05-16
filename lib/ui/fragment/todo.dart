import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_for_it/entity/task.dart';
import 'package:go_for_it/model/main.dart';
import 'package:go_for_it/ui/view/calendar.dart';
import 'package:go_for_it/ui/view/clock_flag.dart';
import 'package:go_for_it/ui/view/clock_progress.dart';
import 'package:go_for_it/ui/view/half_check_box.dart';
import 'package:go_for_it/ui/view/importance_view.dart';
import 'package:go_for_it/util/constant.dart';
import 'package:go_for_it/util/modal.dart';

// 打卡任务高度
const _clockTaskHeight = 70.0;

// 普通任务高度
const _timeTaskHeight = 60.0;

///
/// 待办清单
///
class TodoFragment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TodoFragmentState();
  }
}

///
/// 待办状态
///
class _TodoFragmentState extends State<TodoFragment>
    with SingleTickerProviderStateMixin {
  // 动画
  Animation _animation;

  // 动画控制器
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 200), value: 1);
    _animation = Tween(begin: 0.0, end: 0.5).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScopedModelDescendant<MainStateModel>(
        builder: (context, child, model) {
          return ExpansionTile(
            title: Text(
              Constant.todayTask,
              style: TextStyle(color: Colors.black),
            ),
            trailing: RotationTransition(
              turns: _animation,
              child: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey,
              ),
            ),
            initiallyExpanded: true,
            children: _buildTask(model),
            onExpansionChanged: _onExpansionChanged,
          );
        },
      ),
    );
  }

  ///
  /// 任务列表构造
  ///
  List<Widget> _buildTask(MainStateModel model) {
    List<Widget> list = List(model.todayTasks.length);
    for (int i = 0; i < model.todayTasks.length; i++) {
      Task task = model.todayTasks[i];
      if (task.type == 0) {
        list[i] = GestureDetector(
          onTap: () {
            ModalUtil.showTaskModal(context, task);
          },
          child: Material(
            child: SizedBox(
              height: _timeTaskHeight,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          ImportanceView(importance: task.importance),
                          Text(
                            task.name,
                            style: TextStyle(
                                decoration: task.status == 2
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                color: task.status == 2
                                    ? model.themeData.textTheme.body1.color
                                        .withOpacity(CalendarParam.opacity)
                                    : model.themeData.textTheme.body1.color),
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
                                  task.id, model.user.checkMode, 2);
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
      } else {
        var steps = model.todaySteps
            .where((step) =>
                step.taskId == task.id &&
                step.targetTime >= task.startTime &&
                step.targetTime <= task.endTime)
            .toList();
        int length = steps.length;
        List<int> data = List(length);
        for (int i = 0; i < length; i++) {
          data[i] = DateTime.fromMillisecondsSinceEpoch(
                  steps[i].targetTime * 1000)
              .difference(
                  DateTime.fromMillisecondsSinceEpoch(task.startTime * 1000))
              .inDays;
        }
        int stepIndex = model.todaySteps.indexWhere((step) =>
            step.taskId == task.id &&
            step.targetTime == model.today.millisecondsSinceEpoch ~/ 1000);
        list[i] = GestureDetector(
          onTap: () {
            ModalUtil.showTaskModal(context, task);
          },
          child: Material(
            child: SizedBox(
              height: _clockTaskHeight,
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
                                      text: model.steps
                                          .where(
                                              (step) => step.taskId == task.id)
                                          .length
                                          .toString(),
                                      style: TextStyle(color: Colors.red)),
                                  TextSpan(text: '天')
                                ]),
                              ),
                            ],
                          )
                        ],
                      ),
                      ClockFlag(
                          clocked: stepIndex > -1,
                          color: model.themeData.primaryColor,
                          onPressed: model.clockLocks.indexOf(task.id) > -1
                              ? null
                              : () {
                                  model.changeClockTaskStatus(
                                      task.id, stepIndex, model.today, 2);
                                }),
                    ],
                  ),
                  ClockProgress(
                    width: ScreenUtil().setWidth(Constant.width),
                    height: 5.0,
                    frontColor: Colors.grey,
                    backColor: Colors.grey.withOpacity(0.2),
                    total:
                        DateTime.fromMillisecondsSinceEpoch(task.endTime * 1000)
                                .difference(DateTime.fromMillisecondsSinceEpoch(
                                    task.startTime * 1000))
                                .inDays
                                .abs() +
                            1,
                    data: data,
                  )
                ],
              ),
            ),
          ),
        );
      }
    }
    return list;
  }

  ///
  /// 展开状态更改事件
  ///
  _onExpansionChanged(expand) {
    setState(() {
      if (expand) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }
}
