import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class CalendarParam {
  // 中文星期
  static final weekCh = ['一', '二', '三', '四', '五', '六', '日'];

  // 英文星期
  static final weekEn = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  // 页面数
  static final pageLength = 3;

  // 一周周期
  static final weekLength = 7;

  // 月周行数
  static final monthLines = 6;

  // 月周高度
  static final lineHeight = 50.0;

  // 列表边距
  static final listPadding = 10.0;

  // 其他月日期透明度
  static final opacity = 0.3;

  // 周行高
  static final rowHeight = 20.0;
}

///
/// 日历组件
///
class Calendar extends StatelessWidget {
  Calendar({
    @required this.width,
    @required this.height,
    @required this.themeData,
    @required this.startDayOfWeek,
    @required this.language,
    @required this.today,
    @required this.date,
    @required this.swiperIndex,
    @required this.isWeek,
    @required this.delegate,
    @required this.onDateChange,
    @required this.onSwiperIndexChange,
    @required this.onScroll,
  })  : assert(startDayOfWeek >= 1 && startDayOfWeek <= 7),
        assert(swiperIndex >= 0 && swiperIndex <= 2),
        assert(onDateChange != null),
        assert(onSwiperIndexChange != null),
        assert(onScroll != null);

  // 宽度
  final double width;

  // 高度
  final double height;

  // 主题
  final ThemeData themeData;

  // 开始星期
  final int startDayOfWeek;

  // 语言
  final int language;

  // 今天
  final DateTime today;

  // 所选日期
  final DateTime date;

  // swiper位置
  final int swiperIndex;

  // 是否周视图
  final bool isWeek;

  // 滑动构造器
  final SliverChildBuilderDelegate delegate;

  // 日期更改事件
  final Function onDateChange;

  // swiper换页事件
  final Function onSwiperIndexChange;

  final Function onScroll;

  // 滑动控制器
  final ScrollController _scrollController = ScrollController(
      initialScrollOffset:
          CalendarParam.lineHeight * (CalendarParam.monthLines - 1));

  @override
  Widget build(BuildContext context) {
    double _midScrollOffset =
        CalendarParam.lineHeight * (CalendarParam.monthLines - 1);
    _scrollController.addListener(() {
      onScroll(_scrollController.offset);
    });
    return SizedBox(
        width: width,
        height: height,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: CalendarParam.rowHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _buildWeek(),
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
                        minHeight: CalendarParam.lineHeight,
                        maxHeight:
                            CalendarParam.lineHeight * CalendarParam.monthLines,
                        child: Swiper(
                          itemCount: CalendarParam.pageLength,
                          index: swiperIndex,
                          itemBuilder: (BuildContext context, int index) {
                            return ClipRect(
                              child: _CalendarView(
                                width: width,
                                themeData: themeData,
                                startDayOfWeek: startDayOfWeek,
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
                                    days: CalendarParam.weekLength +
                                        date.weekday -
                                        startDayOfWeek +
                                        (startDayOfWeek > date.weekday
                                            ? 7
                                            : 0))));
                              } else {
                                onDateChange(
                                    DateTime(date.year, date.month - 1, 1));
                              }
                            } else {
                              if (isWeek) {
                                onDateChange(date.add(Duration(
                                    days: CalendarParam.weekLength -
                                        date.weekday +
                                        startDayOfWeek -
                                        (startDayOfWeek > date.weekday
                                            ? 7
                                            : 0))));
                              } else {
                                onDateChange(
                                    DateTime(date.year, date.month + 1, 1));
                              }
                            }
                          },
                        ),
                      )),
                  SliverList(
                    delegate: delegate,
                  ),
                ],
              ),
            )
          ],
        ));
  }

  ///
  /// 构建星期栏
  ///
  List<Widget> _buildWeek() {
    List<Widget> week = List(CalendarParam.weekLength);
    for (int i = 0; i < CalendarParam.weekLength; i++) {
      int index = startDayOfWeek - 1 + i;
      index = index >= 7 ? index - CalendarParam.weekLength : index;
      week[i] = SizedBox(
        width: (width ~/ CalendarParam.weekLength).toDouble(),
        child: Center(
          child: Text(
            language == 0
                ? CalendarParam.weekCh[index]
                : CalendarParam.weekEn[index],
            style: TextStyle(
                color: index == 5 || index == 6
                    ? themeData.primaryColor
                    : themeData.textTheme.body1.color),
          ),
        ),
      );
    }
    return week;
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
    @required this.startDayOfWeek,
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

  // 开始星期
  final int startDayOfWeek;

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
      for (int i = 0; i < CalendarParam.weekLength; i++) {
        DateTime dateTime = date.add(Duration(
            days: i -
                date.weekday +
                startDayOfWeek -
                (startDayOfWeek > date.weekday ? CalendarParam.weekLength : 0) +
                CalendarParam.weekLength * _indexOffset(index)));
        widgets.add(_buildDate(dateTime, isWeek: true));
      }
      return SizedBox(
          width: width,
          height: CalendarParam.lineHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: widgets,
          ));
    } else {
      DateTime firstDay =
          DateTime(date.year, date.month + _indexOffset(index), 1);
      int preLength = firstDay.weekday - startDayOfWeek;
      preLength = preLength < 0 ? preLength + 7 : preLength;
      List<Widget> widgets = List();
      int _lineIndex = 0;
      for (int i = 0;
          i < CalendarParam.weekLength * CalendarParam.monthLines;
          i++) {
        DateTime dateTime = firstDay.add(Duration(days: i - preLength));
        widgets.add(_buildDate(dateTime));
        if (dateTime == date) {
          _lineIndex = i ~/ CalendarParam.weekLength;
        }
      }
      List<Widget> children = List();
      for (int i = 0; i < CalendarParam.monthLines; i++) {
        children.add(LayoutId(
            id: 'week$i',
            child: SizedBox(
              width: width,
              height: CalendarParam.lineHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: widgets.sublist(CalendarParam.weekLength * i,
                    CalendarParam.weekLength * (i + 1)),
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
        width: (width ~/ CalendarParam.weekLength).toDouble(),
        height: CalendarParam.lineHeight,
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
                                    .withOpacity(CalendarParam.opacity),
                    fontWeight: dateTime == today
                        ? FontWeight.bold
                        : themeData.textTheme.body1.fontWeight,
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
    for (int i = 0; i < CalendarParam.monthLines; i++) {
      final String weekId = 'week$i';
      if (hasChild(weekId)) {
        layoutChild(
            weekId, BoxConstraints(maxHeight: CalendarParam.lineHeight));
        double dy = CalendarParam.lineHeight * i -
            lineIndex *
                (CalendarParam.monthLines * CalendarParam.lineHeight -
                    size.height) /
                (CalendarParam.monthLines - 1);
        positionChild(weekId, Offset(0.0, dy));
      }
    }
  }

  @override
  bool shouldRelayout(_CalendarLayout oldDelegate) {
    return lineIndex != oldDelegate.lineIndex;
  }
}
