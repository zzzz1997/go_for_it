import 'package:scoped_model/scoped_model.dart';
import 'package:go_for_it/ui/view/calendar.dart';

///
/// 日历状态管理
///
abstract class CalendarModel extends Model {
  // 今天
  late DateTime _today;

  // 获取今天
  DateTime get today => _today;

  // 选择日期
  late DateTime _date;

  // 获取所选日期
  DateTime get date => _date;

  // scrollController位移
  double _offset = CalendarParam.lineHeight * (CalendarParam.monthLines - 1);

  // 获取scrollController位移
  double get offset => _offset;

  // 是否周视图
  bool _isWeek = true;

  // 获取是否周视图
  bool get isWeek => _isWeek;

  // 滑动位置
  int _swiperIndex = 1;

  // 获取滑动位置
  int get swiperIndex => _swiperIndex;

  ///
  /// 初始化时间
  ///
  DateTime initDate() {
    _today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    _date =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    return _date;
  }

  ///
  /// 设置当前时间
  ///
  setDate(DateTime dateTime) {
    _date = dateTime;
  }

  ///
  /// 更改swiper位置
  ///
  changeSwiperIndex(int index) {
    _swiperIndex = index;
    notifyListeners();
  }

  ///
  /// 滑动事件
  ///
  onScroll(offset) {
    _offset = offset;
    double _midScrollOffset =
        CalendarParam.lineHeight * (CalendarParam.monthLines - 1);
    bool isWeek = offset >= _midScrollOffset || (_midScrollOffset - offset) < 5;
    if (_isWeek != isWeek) {
      _isWeek = isWeek;
      notifyListeners();
    }
  }
}
