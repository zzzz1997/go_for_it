import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:go_for_it/entity/time_task.dart';
import 'package:go_for_it/ui/view/half_check_box.dart';
import 'package:go_for_it/util/constant.dart';

///
/// 日历组件
///
class Calendar extends StatelessWidget {

  Calendar(
    {Key key,
      @required this.width,
      @required this.height,
      @required this.themeData,
      @required this.today,
      @required this.date,
      @required this.tasks,
      @required this.rowHeight,
      @required this.swiperIndex,
      @required this.isWeek,
      @required this.onDateChange,
      @required this.onTaskStatusChange,
      @required this.onSwiperIndexChange,
      @required this.onScroll,
    })
    : super(key: key);

  // 宽度
  final double width;

  // 高度
  final double height;

  // 主题
  final ThemeData themeData;

  // 今天
  final DateTime today;

  // 所选日期
  final DateTime date;

  // 任务列表
  final List<TimeTask> tasks;

  // 星期行高度
  final double rowHeight;

  // swiper位置
  final int swiperIndex;

  // 是否周视图
  final bool isWeek;

  // 日期更改事件
  final Function onDateChange;

  // 任务状态更改时间
  final Function onTaskStatusChange;

  // swiper换页事件
  final Function onSwiperIndexChange;

  final Function onScroll;

  // 滑动控制器
  final ScrollController _scrollController = ScrollController(initialScrollOffset: Constant.lineHeight * (Constant.monthLines - 1));

  @override
  Widget build(BuildContext context) {
    double _midScrollOffset = Constant.lineHeight * (Constant.monthLines - 1);
    _scrollController.addListener(() {
      onScroll(_scrollController.offset);
    });
    return SizedBox(
      width: width,
      height: height,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: Constant.rowHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: Constant.week
                .map((w) => Text(
                w,
                style: TextStyle(
                  color:
                  w == Constant.week[5] || w == Constant.week[6]
                    ? themeData.primaryColor
                    : themeData.textTheme.body1.color),
              ))
                .toList(),
            ),
          ),
          Expanded(
            child: CustomScrollView(
              controller: _scrollController,
              shrinkWrap: true,
              physics:
              _SnappingScrollPhysics(midScrollOffset: _midScrollOffset),
              slivers: <Widget>[
                SliverPersistentHeader(
                  pinned: true,
                  floating: true,
                  delegate: _SliverAppBarDelegate(
                    minHeight: Constant.lineHeight,
                    maxHeight: Constant.lineHeight * Constant.monthLines,
                    child: Swiper(
                      itemCount: Constant.pageLength,
                      index: swiperIndex,
                      itemBuilder: (BuildContext context, int index) {
                        return ClipRect(
                          child: _CalendarView(
                            width: width,
                            themeData: themeData,
                            today: today,
                            date: date,
                            isWeek: isWeek,
                            swiperIndex: swiperIndex,
                            index: index,
                            onDateChange: onDateChange,
                          ),
                        );
                      },
                      onIndexChanged: (int index) {
                        bool isLeftScroll =
                        _isLeftScroll(swiperIndex, index);
                        onSwiperIndexChange(index);
                        if (isLeftScroll) {
                          if (isWeek) {
                            onDateChange(date.subtract(Duration(
                              days: Constant.weekLength + date.weekday - 1)));
                          } else {
                            onDateChange(
                              DateTime(date.year, date.month - 1, 1));
                          }
                        } else {
                          if (isWeek) {
                            onDateChange(date.add(Duration(
                              days: Constant.weekLength - date.weekday + 1)));
                          } else {
                            onDateChange(
                              DateTime(date.year, date.month + 1, 1));
                          }
                        }
                      },
                    ),
                  )),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: Constant.listPadding),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                        if (index == tasks.length) {
                          return SizedBox(
                            height: rowHeight,
                          );
                        }
                        TimeTask task = tasks[index];
                        return SizedBox(
                          height: Constant.taskHeight,
                          child: Card(
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  task.name,
                                  style: TextStyle(
                                    decoration: task.status == HalfCheckBoxStatus.CHECKED.index
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                    color: task.status == HalfCheckBoxStatus.CHECKED.index
                                      ? themeData.textTheme.body1.color
                                      .withOpacity(Constant.opacity)
                                      : themeData.textTheme.body1.color),
                                ),
                                HalfCheckBox(
                                  status: HalfCheckBoxStatus.values[task.status],
                                  color: themeData.primaryColor,
                                  onPressed: () {
                                    onTaskStatusChange(task.id);
                                  },
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: tasks.length + 1,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ));
  }

  ///
  /// 判断是否左滑
  ///
  bool _isLeftScroll(int preIndex, int nowIndex) {
    if (preIndex == 0 && nowIndex == 2) {
      return true;
    } else if (preIndex == 2 && nowIndex == 0) {
      return false;
    } else {
      return preIndex > nowIndex;
    }
  }
}

///
/// 滑动引擎
///
class _SnappingScrollPhysics extends ClampingScrollPhysics {
  const _SnappingScrollPhysics({
    ScrollPhysics parent,
    @required this.midScrollOffset,
  })  : assert(midScrollOffset != null),
      super(parent: parent);

  final double midScrollOffset;

  @override
  _SnappingScrollPhysics applyTo(ScrollPhysics ancestor) {
    return _SnappingScrollPhysics(
      parent: buildParent(ancestor), midScrollOffset: midScrollOffset);
  }

  Simulation _toMidScrollOffsetSimulation(double offset, double dragVelocity) {
    final double velocity = max(dragVelocity, minFlingVelocity);
    return ScrollSpringSimulation(spring, offset, midScrollOffset, velocity,
      tolerance: tolerance);
  }

  Simulation _toZeroScrollOffsetSimulation(double offset, double dragVelocity) {
    final double velocity = max(dragVelocity, minFlingVelocity);
    return ScrollSpringSimulation(spring, offset, 0.0, velocity,
      tolerance: tolerance);
  }

  @override
  Simulation createBallisticSimulation(
    ScrollMetrics position, double dragVelocity) {
    final Simulation simulation =
    super.createBallisticSimulation(position, dragVelocity);
    final double offset = position.pixels;

    if (simulation != null) {
      final double simulationEnd = simulation.x(double.infinity);
      if (simulationEnd >= midScrollOffset) return simulation;
      if (dragVelocity > 0.0)
        return _toMidScrollOffsetSimulation(offset, dragVelocity);
      if (dragVelocity < 0.0)
        return _toZeroScrollOffsetSimulation(offset, dragVelocity);
    } else {
      final double snapThreshold = midScrollOffset / 2.0;
      if (offset >= snapThreshold && offset < midScrollOffset)
        return _toMidScrollOffsetSimulation(offset, dragVelocity);
      if (offset > 0.0 && offset < snapThreshold)
        return _toZeroScrollOffsetSimulation(offset, dragVelocity);
    }
    return simulation;
  }
}

///
/// 自定义SliverHeader
///
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  // 最小高度
  final double minHeight;

  // 最大高度
  final double maxHeight;

  // 子布局
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
    BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
      minHeight != oldDelegate.minHeight ||
      child != oldDelegate.child;
  }

  @override
  String toString() => '_SliverAppBarDelegate';
}

///
/// 日历视图
///
class _CalendarView extends AnimatedWidget {
  _CalendarView({
    Key key,
    @required this.width,
    @required this.themeData,
    @required this.today,
    @required this.date,
    @required this.isWeek,
    @required this.swiperIndex,
    @required this.index,
    @required this.onDateChange,
  }) : super(key: key, listenable: ValueNotifier<double>(0.0));

  // 宽度
  final double width;

  // 主题
  final ThemeData themeData;

  // 今天
  final DateTime today;

  // 当前日期
  final DateTime date;

  // 是否星期格式
  final bool isWeek;

  // swiper位置
  final int swiperIndex;

  // 当前位置
  final int index;

  final Function onDateChange;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: _build);
  }

  ///
  /// 构建日历布局
  ///
  Widget _build(BuildContext context, BoxConstraints constraints) {
    if (isWeek) {
      List<Widget> widgets = List();
      for (int i = 0; i < Constant.weekLength; i++) {
        DateTime dateTime = date.add(Duration(
          days: i - date.weekday + 1 + Constant.weekLength * _indexOffset(index)));
        widgets.add(_buildDate(dateTime, isWeek: true));
      }
      return SizedBox(
        width: width,
        height: Constant.lineHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: widgets,
        ));
    } else {
      DateTime firstDay =
      DateTime(date.year, date.month + _indexOffset(index), 1);
      int preLength = firstDay.weekday - 1;
      List<Widget> widgets = List();
      int _lineIndex = 0;
      for (int i = 0; i < Constant.weekLength * Constant.monthLines; i++) {
        DateTime dateTime = firstDay.add(Duration(days: i - preLength));
        widgets.add(_buildDate(dateTime));
        if (dateTime == date) {
          _lineIndex = i ~/ Constant.weekLength;
        }
      }
      List<Widget> children = List();
      for (int i = 0; i < Constant.monthLines; i++) {
        children.add(LayoutId(
          id: 'week$i',
          child: SizedBox(
            width: width,
            height: Constant.lineHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:
              widgets.sublist(Constant.weekLength * i, Constant.weekLength * (i + 1)),
            ),
          )));
      }
      return CustomMultiChildLayout(
        delegate: _CalendarLayout(lineIndex: _lineIndex),
        children: children,
      );
    }
  }

  ///
  /// 日期
  ///
  Widget _buildDate(DateTime dateTime, {isWeek = false}) {
    return InkResponse(
      onTap: () {
        onDateChange(dateTime);
      },
      containedInkWell: false,
      child: SizedBox(
        width: (width ~/ Constant.weekLength).toDouble(),
        height: Constant.lineHeight,
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: Container(
            decoration: BoxDecoration(
              color: dateTime == date
                ? themeData.primaryColor
                : Colors.transparent,
              shape: BoxShape.circle),
            child: Center(
              child: Text(dateTime.day.toString(),
                style: TextStyle(
                  color: dateTime == date
                    ? Colors.white
                    : dateTime == today
                    ? themeData.primaryColor
                    : dateTime.month == date.month || isWeek
                    ? themeData.textTheme.body1.color
                    : themeData.textTheme.body1.color
                    .withOpacity(Constant.opacity),
                )),
            ),
          ),
        ),
      ),
    );
  }

  ///
  /// 计算swiper偏移
  ///
  int _indexOffset(int index) {
    int offsetIndex = index - swiperIndex;
    return offsetIndex >= -1 && offsetIndex <= 1 ? offsetIndex : -1;
  }
}

///
/// 日历布局
///
class _CalendarLayout extends MultiChildLayoutDelegate {
  _CalendarLayout({@required this.lineIndex});

  // 当前行数
  final int lineIndex;

  @override
  void performLayout(Size size) {
    for (int i = 0; i < Constant.monthLines; i++) {
      final String weekId = 'week$i';
      if (hasChild(weekId)) {
        layoutChild(weekId, BoxConstraints(maxHeight: Constant.lineHeight));
        double dy = Constant.lineHeight * i -
          lineIndex *
            (Constant.monthLines * Constant.lineHeight - size.height) /
            (Constant.monthLines - 1);
        positionChild(weekId, Offset(0.0, dy));
      }
    }
  }

  @override
  bool shouldRelayout(_CalendarLayout oldDelegate) {
    return lineIndex != oldDelegate.lineIndex;
  }
}
