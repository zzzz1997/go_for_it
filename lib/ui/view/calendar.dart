import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:go_for_it/entity/time_task.dart';
import 'package:go_for_it/ui/view/half_check_box.dart';
import 'package:go_for_it/util/constant.dart';

// 页面数
const _pageLength = 3;
// 一周周期
const _weekLength = 7;
// 月周行数
const _monthLines = 6;
// 月周高度
const _lineHeight = 50.0;
// 任务高度
const _taskHeight = 50.0;
// 列表边距
const _listPadding = 10.0;
// 其他月日期透明度
const _opacity = 0.3;

///
/// 日历组件
///
class Calendar extends StatefulWidget {
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

  // 日期更改事件
  final Function onDateChange;

  // 任务状态更改时间
  final Function onTaskStatusChange;

  Calendar(
      {Key key,
      @required this.width,
      @required this.height,
      @required this.themeData,
      @required this.today,
      @required this.date,
      @required this.tasks,
      this.onDateChange,
      this.onTaskStatusChange})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CalendarState();
  }
}

///
/// 日历状态
///
class CalendarState extends State<Calendar> {
  // 宽度
  double _width;

  // 高度
  double _height;

  // 主题
  ThemeData _themeData;

  // 今天
  DateTime _today;

  // 所选日期
  DateTime _date;

  // 任务列表
  List<TimeTask> _tasks;

  // 日期更改事件
  Function _onDateChange;

  // 任务状态更改时间
  Function _onTaskStatusChange;

  // row键
  GlobalKey _rowKey = GlobalKey();

  // 滑动控制器
  final ScrollController _scrollController = ScrollController();

  // 星期行高度
  double _rowHeight = 0.0;

  // 空白高度
  double _blankHeight = 0.0;

  // swiper位置
  int _swiperIndex = 1;

  @override
  void initState() {
    super.initState();

    _width = widget.width;
    _height = widget.height;
    _themeData = widget.themeData;
    _today = widget.today;
    _date = widget.date;
    _tasks = widget.tasks;
    _onDateChange = widget.onDateChange;
    _onTaskStatusChange = widget.onTaskStatusChange;

    WidgetsBinding widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((_) async {
      if (_rowKey.currentContext != null) {
        _rowHeight =
          _rowKey.currentContext
            .findRenderObject()
            .semanticBounds
            .size
            .height;
        double height = _height -
          _rowHeight -
          _lineHeight -
          2 * _listPadding -
          _tasks.length * _taskHeight;
        setState(() {
          _blankHeight = height > 0 ? height : 0.0;
        });
      }
      await _scrollController.animateTo(_lineHeight * (_monthLines - 1),
        duration: Duration(milliseconds: 100), curve: ElasticInCurve());
      _scrollController.addListener(() {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    const _midScrollOffset = _lineHeight * (_monthLines - 1);
    bool _isWeek = true;
    if (_scrollController.hasClients) {
      _isWeek = _scrollController.offset >= _midScrollOffset ||
          (_midScrollOffset - _scrollController.offset) < 1;
    }
    return SizedBox(
        width: _width,
        height: _height,
        child: Column(
          children: <Widget>[
            Row(
              key: _rowKey,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: Constant.week
                  .map((w) => Text(
                        w,
                        style: TextStyle(
                            color:
                                w == Constant.week[5] || w == Constant.week[6]
                                    ? _themeData.primaryColor
                                    : _themeData.textTheme.body1.color),
                      ))
                  .toList(),
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
                        minHeight: _lineHeight,
                        maxHeight: _lineHeight * _monthLines,
                        child: Swiper(
                          itemCount: _pageLength,
                          index: _swiperIndex,
                          itemBuilder: (BuildContext context, int index) {
                            return ClipRect(
                              child: _CalendarView(
                                width: _width,
                                themeData: _themeData,
                                today: _today,
                                date: _date,
                                isWeek: _isWeek,
                                swiperIndex: _swiperIndex,
                                index: index,
                                onDateChange: _onDateChange,
                              ),
                            );
                          },
                          onIndexChanged: (int index) {
                            bool isLeftScroll =
                                _isLeftScroll(_swiperIndex, index);
                            _swiperIndex = index;
                            if (isLeftScroll) {
                              if (_isWeek) {
                                _onDateChange(_date.subtract(Duration(
                                    days: _weekLength + _date.weekday - 1)));
                              } else {
                                _onDateChange(
                                    DateTime(_date.year, _date.month - 1, 1));
                              }
                            } else {
                              if (_isWeek) {
                                _onDateChange(_date.add(Duration(
                                    days: _weekLength - _date.weekday + 1)));
                              } else {
                                _onDateChange(
                                    DateTime(_date.year, _date.month + 1, 1));
                              }
                            }
                          },
                        ),
                      )),
                  SliverPadding(
                    padding: EdgeInsets.all(_listPadding),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          if (index == _tasks.length) {
                            return SizedBox(
                              height: _blankHeight,
                            );
                          }
                          TimeTask task = _tasks[index];
                          return SizedBox(
                            height: _taskHeight,
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
                                            ? _themeData.textTheme.body1.color
                                                .withOpacity(_opacity)
                                            : _themeData.textTheme.body1.color),
                                  ),
                                  HalfCheckBox(
                                    status: HalfCheckBoxStatus.values[task.status],
                                    color: _themeData.primaryColor,
                                    onPressed: () {
                                      _onTaskStatusChange(task.id);
                                    },
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        childCount: _tasks.length + 1,
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
  /// 设置事件
  ///
  setDateTask(DateTime dateTime, List<TimeTask> tasks) {
    setState(() {
      _date = dateTime;
      _tasks = tasks;
      double height = _height -
          _rowHeight -
          _lineHeight -
          2 * _listPadding -
          _tasks.length * _taskHeight;
      _blankHeight = height > 0 ? height : 0.0;
    });
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
      for (int i = 0; i < _weekLength; i++) {
        DateTime dateTime = date.add(Duration(
            days: i - date.weekday + 1 + _weekLength * _indexOffset(index)));
        widgets.add(_buildDate(dateTime, isWeek: true));
      }
      return SizedBox(
          width: width,
          height: _lineHeight,
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
      for (int i = 0; i < _weekLength * _monthLines; i++) {
        DateTime dateTime = firstDay.add(Duration(days: i - preLength));
        widgets.add(_buildDate(dateTime));
        if (dateTime == date) {
          _lineIndex = i ~/ _weekLength;
        }
      }
      List<Widget> children = List();
      for (int i = 0; i < _monthLines; i++) {
        children.add(LayoutId(
            id: 'week$i',
            child: SizedBox(
              width: width,
              height: _lineHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:
                    widgets.sublist(_weekLength * i, _weekLength * (i + 1)),
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
        width: (width ~/ _weekLength).toDouble(),
        height: _lineHeight,
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
                                    .withOpacity(_opacity),
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
    for (int i = 0; i < _monthLines; i++) {
      final String weekId = 'week$i';
      if (hasChild(weekId)) {
        layoutChild(weekId, BoxConstraints(maxHeight: _lineHeight));
        double dy = _lineHeight * i -
            lineIndex *
                (_monthLines * _lineHeight - size.height) /
                (_monthLines - 1);
        positionChild(weekId, Offset(0.0, dy));
      }
    }
  }

  @override
  bool shouldRelayout(_CalendarLayout oldDelegate) {
    return lineIndex != oldDelegate.lineIndex;
  }
}
