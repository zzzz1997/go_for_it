import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:go_for_it/ui/view/calendar.dart';
import 'package:go_for_it/util/alert.dart';
import 'package:go_for_it/util/constant.dart';

// 宽度
const _width = 314.0;

// 选择器高度
const _selectorHeight = 40.0;

// 日历高度（42 * 7）
const _calendarHeight = 294.0;

// 列表高度
const _listHeight = 40.0;

// 选中列表高度
const _selectedListHeight = 50.0;

// 边距
const _padding = 10.0;

// 不透明度
const _opacity = 0.3;

// 开始年份
const _startYear = 1970;

// 结束年份
const _endYear = 2038;

// 月数
const _monthLength = 12;

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
  static Future<List<DateTime>> showPicker(
      BuildContext context,
      DateTime startTime,
      DateTime endTime,
      DatePickerSelectMode selectMode,
      int language,
      int startDayOfWeek,
      {DateTime? firstDate,
      DateTime? lastDate,
      DatePickerShowMode? showMode}) async {
    return await showDialog(
      context: context,
      builder: (context) => _DatePickerDialog(
        startTime: startTime,
        endTime: endTime,
        selectMode: selectMode,
        language: language,
        startDayOfWeek: startDayOfWeek,
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
      {required this.startTime,
      required this.endTime,
      required this.selectMode,
      required this.language,
      required this.startDayOfWeek,
      required this.firstDate,
      required this.lastDate,
      required this.showMode});

  // 开始时间
  final DateTime startTime;

  // 结束时间
  final DateTime endTime;

  // 选择模式
  final DatePickerSelectMode selectMode;

  // 语言
  final int language;

  // 一周开始时间
  final int startDayOfWeek;

  // 可选第一天
  final DateTime? firstDate;

  // 可选最后一天
  final DateTime? lastDate;

  // 展示模式
  final DatePickerShowMode? showMode;

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
  late DateTime _startTime;

  // 结束时间
  late DateTime _endTime;

  // 选择模式
  late DatePickerSelectMode _selectMode;

  // 语言
  late int _language;

  // 一周开始时间
  late int _startDayOfWeek;

  // 可选第一天
  late DateTime _firstDate;

  // 可选最后一天
  late DateTime _lastDate;

  // 展示模式
  late DatePickerShowMode _showMode;

  // 当前选择年份位置
  int _yearIndex = 0;

  // 今天
  late DateTime _today;

  // 日历位置
  int _index = 0;

  // 滚动控制器
  ScrollController _scrollController = ScrollController();

  // 滑动控制器
  SwiperController _swiperController = SwiperController();

  // 应当滑动
  bool _shouldJump = false;

  @override
  void initState() {
    super.initState();

    _startTime = widget.startTime;
    _endTime = widget.endTime;
    _selectMode = widget.selectMode;
    _language = widget.language;
    _startDayOfWeek = widget.startDayOfWeek;
    _firstDate = widget.firstDate ?? DateTime(_startYear);
    _lastDate = widget.lastDate ?? DateTime(_endYear);
    _showMode = widget.showMode ?? DatePickerShowMode.DATE;

    DateTime now = DateTime.now();
    _today = DateTime(now.year, now.month, now.day);
    _index = _startTime.year * _monthLength +
        _startTime.month -
        _firstDate.year * _monthLength -
        _firstDate.month;

    if (_selectMode == DatePickerSelectMode.DATE) {
      _endTime = _startTime;
    }

    // todo Concurrent modification during iteration: Instance(length:3) of '_GrowableList'.
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (_showMode == DatePickerShowMode.YEAR) {
        _scrollController
            .jumpTo((_startTime.year - _firstDate.year) * _listHeight);
      }
    });
    WidgetsBinding.instance!.addPersistentFrameCallback((_) {
      if (_shouldJump) {
        _scrollController.jumpTo(
            ((_yearIndex == 0 ? _startTime.year : _endTime.year) -
                    _firstDate.year) *
                _listHeight);
        _shouldJump = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    int months = _lastDate.year * _monthLength +
        _lastDate.month -
        _firstDate.year * _monthLength -
        _firstDate.month +
        1;
    return Dialog(
      child: SizedBox(
        width: _width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              color: themeData.primaryColor,
              child: Padding(
                padding: EdgeInsets.all(_padding),
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
                          onLongPress: _showMode == DatePickerShowMode.DATE
                              ? _onStartTimeLongPress
                              : null,
                          containedInkWell: false,
                          child: Text(
                            '${_startTime.day},${_startTime.month}',
                            style: themeData.textTheme.headline4!.copyWith(
                                color: _showMode == DatePickerShowMode.DATE
                                    ? Colors.white
                                    : Colors.white.withOpacity(_opacity)),
                          ),
                        ),
                      ],
                    ),
                    _selectMode == DatePickerSelectMode.RANGE &&
                            _endTime.minute == 0
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
                                onLongPress:
                                    _showMode == DatePickerShowMode.DATE
                                        ? _onEndTimeLongPress
                                        : null,
                                containedInkWell: false,
                                child: Text(
                                  '${_endTime.day},${_endTime.month}',
                                  style: themeData.textTheme.headline4!
                                      .copyWith(
                                          color: _showMode ==
                                                  DatePickerShowMode.DATE
                                              ? Colors.white
                                              : Colors.white
                                                  .withOpacity(_opacity)),
                                ),
                              ),
                            ],
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.all(_padding),
                child: SizedBox(
                  height: _selectorHeight + _calendarHeight,
                  child: _showMode == DatePickerShowMode.YEAR
                      ? ListView.builder(
                          controller: _scrollController,
                          itemBuilder: _yearListBuilder,
                          itemCount: _lastDate.year - _firstDate.year + 1,
                        )
                      : Stack(
                          children: <Widget>[
                            Swiper(
                              controller: _swiperController,
                              loop: false,
                              itemBuilder: _swiperBuilder,
                              itemCount: months,
                              index: _index,
                              onIndexChanged: _onIndexChanged,
                            ),
                            SizedBox(
                              height: _selectorHeight,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.keyboard_arrow_left),
                                    color: themeData.primaryColor,
                                    onPressed:
                                        _index > 0 ? _onLeftPressed : null,
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.keyboard_arrow_right),
                                    color: themeData.primaryColor,
                                    onPressed: _index < months
                                        ? _onRightPressed
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                )),
            ButtonBar(
              children: <Widget>[
                TextButton(
                  child: Text(
                    Constant.cancel,
                    style: TextStyle(color: themeData.primaryColor),
                  ),
                  onPressed: _onCancelPressed,
                ),
                TextButton(
                  child: Text(
                    Constant.confirm,
                    style: TextStyle(color: themeData.primaryColor),
                  ),
                  onPressed: _onConfirmPressed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ///
  /// 年列表构造器
  ///
  Widget _yearListBuilder(context, int index) {
    ThemeData themeData = Theme.of(context);
    int year = _firstDate.year + index;
    bool isSelected =
        _yearIndex == 0 ? _startTime.year == year : _endTime.year == year;
    bool canSelect = _yearIndex == 0 ||
        year * _monthLength + _endTime.month >
            _startTime.year * _monthLength + _startTime.month;
    return GestureDetector(
      onTap: canSelect
          ? () {
              _onYearTap(year);
            }
          : null,
      child: SizedBox(
        height: isSelected ? _selectedListHeight : _listHeight,
        child: Center(
          child: Text(
            year.toString(),
            style: isSelected
                ? themeData.textTheme.headline5!
                    .copyWith(color: themeData.primaryColor)
                : canSelect
                    ? themeData.textTheme.bodyText2
                    : themeData.textTheme.bodyText2!.copyWith(
                        color: themeData.textTheme.bodyText2!.color!
                            .withOpacity(_opacity)),
          ),
        ),
      ),
    );
  }

  ///
  /// 日历视图构造器
  ///
  Widget _swiperBuilder(context, int index) {
    ThemeData themeData = Theme.of(context);
    double width = _calendarHeight / CalendarParam.weekLength;
    List<Widget> week = [];
    for (int i = 0; i < CalendarParam.weekLength; i++) {
      int index = _startDayOfWeek - 1 + i;
      index = index >= 7 ? index - CalendarParam.weekLength : index;
      week.add(SizedBox(
        width: width,
        height: width,
        child: Center(
          child: Text(
            _language == 0
                ? CalendarParam.weekCh[index]
                : CalendarParam.weekEn[index],
            style: TextStyle(
                color: index == 5 || index == 6
                    ? themeData.primaryColor
                    : themeData.textTheme.bodyText2!.color),
          ),
        ),
      ));
    }
    DateTime firstDay = DateTime(_firstDate.year, _firstDate.month + index);
    int space = firstDay.weekday -
        _startDayOfWeek +
        (_startDayOfWeek > firstDay.weekday ? CalendarParam.weekLength : 0);
    List<Widget> days = [];
    for (int i = 0;
        i < CalendarParam.monthLines * CalendarParam.weekLength;
        i++) {
      if (i >= space) {
        DateTime dateTime = firstDay.add(Duration(days: i - space));
        bool isInRange =
            dateTime.isAfter(_startTime) && dateTime.isBefore(_endTime);
        TextStyle textStyle = dateTime.isAtSameMomentAs(_today)
            ? themeData.textTheme.bodyText1!
                .copyWith(color: themeData.primaryColor)
            : themeData.textTheme.bodyText2!;
        days.add(dateTime.month == firstDay.month
            ? GestureDetector(
                onTap: () {
                  _onDateTap(dateTime);
                },
                child: Container(
                  width: width,
                  height: width,
                  decoration: BoxDecoration(
                    color: isInRange
                        ? themeData.primaryColor.withOpacity(_opacity)
                        : (dateTime.isAtSameMomentAs(_startTime) ||
                                dateTime.isAtSameMomentAs(_endTime))
                            ? themeData.primaryColor
                            : Colors.white,
                    borderRadius: dateTime.isAtSameMomentAs(_startTime) &&
                            dateTime.isAtSameMomentAs(_endTime)
                        ? BorderRadius.all(Radius.circular(width / 2))
                        : dateTime.isAtSameMomentAs(_startTime)
                            ? BorderRadius.horizontal(
                                left: Radius.circular(width / 2))
                            : dateTime.isAtSameMomentAs(_endTime)
                                ? BorderRadius.horizontal(
                                    right: Radius.circular(width / 2))
                                : null,
                  ),
                  child: Center(
                    child: Text(
                      dateTime.day.toString(),
                      style: isInRange ||
                              (dateTime.isAtSameMomentAs(_startTime) ||
                                  dateTime.isAtSameMomentAs(_endTime))
                          ? textStyle.copyWith(color: Colors.white)
                          : textStyle,
                    ),
                  ),
                ),
              )
            : SizedBox(
                width: width,
                height: width,
              ));
      } else {
        days.add(SizedBox(
          width: width,
          height: width,
        ));
      }
    }
    Wrap calendar = Wrap(
      children: days,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: _selectorHeight,
          child: Center(
            child: Text('${firstDay.month},${firstDay.year}'),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: week,
        ),
        calendar
      ],
    );
  }

  ///
  /// 切换显示模式
  ///
  _changeShowMode({int yearIndex = -1}) {
    setState(() {
      if (_showMode == DatePickerShowMode.YEAR && yearIndex == -1) {
        _showMode = DatePickerShowMode.DATE;
      } else if (yearIndex > -1) {
        _yearIndex = yearIndex;
        _showMode = DatePickerShowMode.YEAR;
        _shouldJump = true;
      }
    });
  }

  ///
  /// 年点击事件
  ///
  _onYearTap(int year) {
    setState(() {
      if (_yearIndex == 0) {
        _startTime = DateTime(year, _startTime.month, _startTime.day);
        if (_selectMode == DatePickerSelectMode.DATE) {
          _endTime = _startTime;
        } else if (_startTime.isAfter(_endTime)) {
          _endTime = _startTime.add(Duration(minutes: 1));
        }
        _index = _startTime.year * _monthLength +
            _startTime.month -
            _firstDate.year * _monthLength -
            _firstDate.month;
      } else {
        _endTime = DateTime(year, _endTime.month, _endTime.day);
        _index = _endTime.year * _monthLength +
            _endTime.month -
            _firstDate.year * _monthLength -
            _firstDate.month;
      }
      _showMode = DatePickerShowMode.DATE;
    });
  }

  ///
  /// 开始时间长按事件
  ///
  _onStartTimeLongPress() {
    _swiperController.move(
        _startTime.year * _monthLength +
            _startTime.month -
            _firstDate.year * _monthLength -
            _firstDate.month,
        animation: false);
  }

  ///
  /// 结束时间长按事件
  ///
  _onEndTimeLongPress() {
    _swiperController.move(
        _endTime.year * _monthLength +
            _endTime.month -
            _firstDate.year * _monthLength -
            _firstDate.month,
        animation: false);
  }

  ///
  /// 左按钮点击事件
  ///
  _onLeftPressed() {
    _swiperController.previous();
  }

  ///
  /// 右按钮点击事件
  ///
  _onRightPressed() {
    _swiperController.next();
  }

  ///
  /// 滑动位置更改事件
  ///
  _onIndexChanged(index) {
    setState(() {
      _index = index;
    });
  }

  ///
  /// 时间点击事件
  ///
  _onDateTap(DateTime dateTime) {
    setState(() {
      if (_selectMode == DatePickerSelectMode.DATE) {
        _startTime = dateTime;
        _endTime = dateTime;
      } else {
        if (dateTime.isAfter(_endTime)) {
          _endTime = dateTime;
        } else {
          _startTime = dateTime;
          _endTime = dateTime.add(Duration(minutes: 1));
        }
      }
    });
  }

  ///
  /// 取消按钮点击事件
  ///
  _onCancelPressed() {
    Navigator.pop(context);
  }

  ///
  /// 确认按钮点击事件
  ///
  _onConfirmPressed() {
    if (_endTime.minute == 0) {
      Navigator.pop(context, [_startTime, _endTime]);
    } else {
      Alert.errorBar(context, Constant.selectTimeError);
    }
  }
}
