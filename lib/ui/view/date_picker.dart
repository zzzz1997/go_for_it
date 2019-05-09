import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

// 宽度
const _width = 314.0;

// 选择器高度
const _selectorHeight = 20.0;

// 日历高度（42 * 7）
const _calendarHeight = 294.0;

// 边距
const _padding = 10.0;

// 不透明度
const _opacity = 0.3;

// 开始年份
const _startYear = 1970;

// 结束年份
const _endYear = 2038;

///
/// 日期选择器展示模式
///
enum DatePickerShowMode {
  YEAR,
  DATE,
}

///
/// 日期选择器选择模式
///
enum DatePickerSelectMode {
  DATE,
  RANGE,
}

///
/// 日期选择器
///
class DatePicker {
  ///
  /// 展示选择器选择日期
  ///
  static Future<List<DateTime>> showPicker(BuildContext context,
      DateTime startTime, DateTime endTime, DatePickerSelectMode selectMode,
      {DateTime firstDate,
      DateTime lastDate,
      DatePickerShowMode showMode}) async {
    return await showDialog(
      context: context,
      builder: (context) => _DatePickerDialog(
            startTime: startTime,
            endTime: endTime,
            selectMode: selectMode,
            firstDate: firstDate,
            lastDate: lastDate,
            showMode: showMode,
          ),
    );
  }
}

///
/// 日期选择器弹窗
///
class _DatePickerDialog extends StatefulWidget {
  _DatePickerDialog(
      {Key key,
      @required this.startTime,
      @required this.endTime,
      @required this.selectMode,
      @required this.firstDate,
      @required this.lastDate,
      @required this.showMode})
      : super(key: key);

  // 开始时间
  final DateTime startTime;

  // 结束时间
  final DateTime endTime;

  // 选择模式
  final DatePickerSelectMode selectMode;

  // 可选第一天
  final DateTime firstDate;

  // 可选最后一天
  final DateTime lastDate;

  // 展示模式
  final DatePickerShowMode showMode;

  @override
  State<StatefulWidget> createState() {
    return _DatePickerDialogState();
  }
}

///
/// 日期选择器弹窗状态
///
class _DatePickerDialogState extends State<_DatePickerDialog> {
  // 开始时间
  DateTime _startTime;

  // 结束时间
  DateTime _endTime;

  // 选择模式
  DatePickerSelectMode _selectMode;

  // 可选第一天
  DateTime _firstDate;

  // 可选最后一天
  DateTime _lastDate;

  // 展示模式
  DatePickerShowMode _showMode;

  // 当前选择年份位置
  int _yearIndex = 0;

  @override
  void initState() {
    super.initState();

    _startTime = widget.startTime;
    _endTime = widget.endTime;
    _selectMode = widget.selectMode;
    _firstDate = widget.firstDate ?? DateTime(_startYear);
    _lastDate = widget.lastDate ?? DateTime(_endYear);
    _showMode = widget.showMode ?? DatePickerShowMode.DATE;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData _themeData = Theme.of(context);
    return Dialog(
      child: SizedBox(
        width: _width,
        child: Padding(
          padding: EdgeInsets.all(_padding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                color: _themeData.primaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InkResponse(
                          onTap: () {
                            _changeShowMode(yearIndex: 0);
                          },
                          containedInkWell: false,
                          child: Text(
                            _startTime.year.toString(),
                            style: TextStyle(
                                color: _showMode == DatePickerShowMode.YEAR
                                    ? Colors.white
                                    : Colors.white.withOpacity(_opacity),
                                fontWeight:
                                    _showMode == DatePickerShowMode.YEAR &&
                                            _yearIndex == 0
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                          ),
                        ),
                        SizedBox(
                          height: _padding,
                        ),
                        InkResponse(
                          onTap: _changeShowMode,
                          containedInkWell: false,
                          child: Text(
                            _startTime.day.toString(),
                            style: _themeData.textTheme.display1.copyWith(
                                color: _showMode == DatePickerShowMode.DATE
                                    ? Colors.white
                                    : Colors.white.withOpacity(_opacity)),
                          ),
                        ),
                      ],
                    ),
                    _selectMode == DatePickerSelectMode.RANGE &&
                            _endTime != null
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              InkResponse(
                                onTap: () {
                                  _changeShowMode(yearIndex: 1);
                                },
                                containedInkWell: false,
                                child: Text(
                                  _endTime.year.toString(),
                                  style: TextStyle(
                                      color: _showMode ==
                                              DatePickerShowMode.YEAR
                                          ? Colors.white
                                          : Colors.white.withOpacity(_opacity),
                                      fontWeight: _showMode ==
                                                  DatePickerShowMode.YEAR &&
                                              _yearIndex == 1
                                          ? FontWeight.bold
                                          : FontWeight.normal),
                                ),
                              ),
                              SizedBox(
                                height: _padding,
                              ),
                              InkResponse(
                                onTap: _changeShowMode,
                                containedInkWell: false,
                                child: Text(
                                  _startTime.day.toString(),
                                  style: _themeData.textTheme.display1.copyWith(
                                      color: _showMode ==
                                              DatePickerShowMode.DATE
                                          ? Colors.white
                                          : Colors.white.withOpacity(_opacity)),
                                ),
                              ),
                            ],
                          )
                        : SizedBox(),
                  ],
                ),
              ),
              SizedBox(
                height: _selectorHeight + _calendarHeight,
                child: _showMode == DatePickerShowMode.YEAR
                    ? ListView.builder(
                        itemBuilder: (context, index) {
                          int year = _startYear + index;
                          return GestureDetector(
                            onTap: () {
                              _onYearTap(year);
                            },
                            child: Center(
                              child: Text(
                                '${_startYear + index}',
                                style: (_yearIndex == 0
                                        ? _startTime.year == year
                                        : _endTime.year == year)
                                    ? _themeData.textTheme.headline.copyWith(
                                        color: _themeData.primaryColor)
                                    : _themeData.textTheme.body1,
                              ),
                            ),
                          );
                        },
                        itemCount: _endYear - _startYear + 1,
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(
                            height: _selectorHeight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text('selector'),
                              ],
                            ),
                          ),
                          // todo 日历视图
                        ],
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  ///
  /// 切换显示模式
  ///
  _changeShowMode({int yearIndex = 0}) {
    setState(() {
      _yearIndex = yearIndex;
      _showMode = _showMode == DatePickerShowMode.YEAR
          ? DatePickerShowMode.DATE
          : DatePickerShowMode.YEAR;
    });
  }

  ///
  /// 年点击事件
  ///
  _onYearTap(int year) {
    setState(() {
      if (_yearIndex == 0) {
        _startTime = DateTime(year, _startTime.month, _startTime.day);
      } else {
        _endTime = DateTime(year, _endTime.month, _endTime.day);
      }
      _showMode = DatePickerShowMode.DATE;
    });
  }
}
