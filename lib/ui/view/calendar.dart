import 'package:flutter/material.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:gtd_task/util/constant.dart';

// 页面数
const _pageLength = 3;
// 一周周期
const _weekLength = 7;
// 月周行数
const _monthLines = 6;
// 日历高度
const _calendarHeight = 200.0;
// appBar高度
const _appBarHeight = 58.0;
// 其他月日期透明度
const _otherOpacity = 0.3;

///
/// 日历组件
///
class Calendar extends StatefulWidget {
  // 宽度
  final double width;

  // 主题
  final ThemeData themeData;

  Calendar({Key key, @required this.width, @required this.themeData})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CalendarState();
  }
}

///
/// 日历状态
///
class _CalendarState extends State<Calendar> {
  // 宽度
  double _width;

  // 主题
  ThemeData _themeData;

  // 页面控制器
  PageController _controller;

  // 今天
  DateTime _today =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  // 所选日期
  DateTime _date =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  // 滚动监听器
  final ScrollController _scrollController = ScrollController();

  double _offset = 0.0;

  // 文字透明度
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();

    _width = widget.width;
    _themeData = widget.themeData;

    print(_width);

    _controller = PageController(
      initialPage: 1,
      keepPage: true,
      viewportFraction: 1.0,
    );
    _scrollController.addListener(() {
      _onScroll();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_offset < (_calendarHeight - _appBarHeight)) {
      _opacity = _offset / (_calendarHeight - _appBarHeight);
    } else {
      _opacity = 1.0;
    }
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.chevron_left),
              onPressed: () {
                _setData(0);
              },
            ),
            Text('${_date.year}年${_date.month}月'),
            IconButton(
              icon: Icon(Icons.chevron_right),
              onPressed: () {
                _setData(2);
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: Constant.week
              .map((w) => Text(
                    w,
                    style: TextStyle(
                        color: w == '日' || w == '六'
                            ? _themeData.accentColor
                            : _themeData.textTheme.body1.color),
                  ))
              .toList(),
        ),
        Expanded(
          child: PageView.builder(
            controller: _controller,
            itemCount: _pageLength,
            itemBuilder: (context, index) {
              return CustomScrollView(
                controller: _scrollController,
                slivers: <Widget>[
                  SliverAppBar(
                    expandedHeight: _calendarHeight,
                    backgroundColor: Colors.white,
                    title: _buildWeek(index, _opacity),
                    titleSpacing: 0.0,
                    floating: false,
                    pinned: true,
                    snap: false,
                    forceElevated: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: _buildMonth(index),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        if (index == 9) {
                          return SizedBox(
                            height: 500.0,
                          );
                        }
                        return Card(
                          child: Row(
                            children: <Widget>[
                              CircularCheckBox(
                                value: false,
                                materialTapTargetSize: MaterialTapTargetSize.padded,
                                onChanged: (bool x) {

                                }
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: 10,
                    ),
                  ),
                ],
              );
            },
            onPageChanged: (int index) {
              _setData(index);
            },
            pageSnapping: true,
          ),
        )
      ],
    );
  }

  _setData(int index) {
    if (index == 1) {
      return;
    }
    this.setState(() {
      if (_offset <= _calendarHeight - _appBarHeight) {
        if (index == 0) {
          _date = DateTime(_date.year, _date.month - 1, 1);
        } else {
          _date = DateTime(_date.year, _date.month + 1, 1);
        }
      } else {
        if (index == 0) {
          _date = _date.subtract(Duration(
              days: _weekLength +
                  (_date.weekday == _weekLength ? 0 : _date.weekday)));
        } else {
          _date = _date.add(Duration(
              days: _weekLength -
                  (_date.weekday == _weekLength ? 0 : _date.weekday)));
        }
      }
    });
    _controller.animateToPage(1,
        duration: Duration(milliseconds: 1), curve: Threshold(0.0));
  }

  ///
  /// 星期
  ///
  Widget _buildWeek(int index, double opacity) {
    List<Widget> widgets = List();
    for (int i = 0; i < _weekLength; i++) {
      DateTime dateTime = _date.add(Duration(
          days: i - (_date.weekday == _weekLength ? 0 : _date.weekday)));
      widgets.add(
          _buildDate(dateTime, _appBarHeight, isWeek: true, opacity: opacity));
    }
    return opacity < 0.05
        ? SizedBox()
        : Wrap(
            children: widgets,
          );
  }

  ///
  /// 月份
  ///
  Widget _buildMonth(int index) {
    DateTime firstDay = DateTime(_date.year, _date.month + index - 1, 1);
    int preLength = firstDay.weekday == 7 ? 0 : firstDay.weekday;
    List<Widget> widgets = List();
    for (int i = 0; i < _weekLength * _monthLines; i++) {
      DateTime dateTime = firstDay.add(Duration(days: i - preLength));
      widgets.add(_buildDate(dateTime, _calendarHeight / _monthLines));
    }
    return Wrap(
      children: widgets,
    );
  }

  ///
  /// 日期
  ///
  Widget _buildDate(DateTime dateTime, double height,
      {isWeek = false, opacity = 0.0}) {
    return InkResponse(
      onTap: isWeek && opacity < 0.5
          ? null
          : () {
              _selectDate(dateTime);
            },
      containedInkWell: false,
      child: SizedBox(
        width: _width / _weekLength,
        height: height,
        child: Padding(
          padding: EdgeInsets.all(isWeek ? 10.0 : 5.0),
          child: Container(
            decoration: BoxDecoration(
                color: dateTime == _date
                    ? isWeek
                        ? _themeData.primaryColor.withOpacity(opacity)
                        : _themeData.primaryColor
                    : Colors.transparent,
                shape: BoxShape.circle),
            child: Center(
              child: Text(
                dateTime.day.toString(),
                style: TextStyle(
                    color: isWeek
                        ? (dateTime == _date
                                ? Colors.white
                                : dateTime == _today
                                    ? _themeData.primaryColor
                                    : _themeData.textTheme.body1.color)
                            .withOpacity(opacity)
                        : dateTime == _date
                            ? Colors.white
                            : dateTime == _today
                                ? _themeData.primaryColor
                                : dateTime.month == _date.month
                                    ? _themeData.textTheme.body1.color
                                    : _themeData.textTheme.body1.color
                                        .withOpacity(_otherOpacity)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///
  /// 滑动事件
  ///
  _onScroll() {
    if ((_scrollController.offset - _offset).abs() > 10) {
      setState(() {
        _offset = _scrollController.offset;
      });
    }
  }

  ///
  /// 选择时间
  ///
  _selectDate(dateTime) {
    setState(() {
      _date = dateTime;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _scrollController.dispose();
  }
}
