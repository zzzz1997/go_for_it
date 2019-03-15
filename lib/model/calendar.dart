import 'package:scoped_model/scoped_model.dart';
import 'package:go_for_it/util/constant.dart';

///
/// 日历管理
///
abstract class CalendarModel extends Model {

  // scrollController位移
  double _offset = Constant.lineHeight * (Constant.monthLines - 1);

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

  factory CalendarModel._() => null;

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
    double _midScrollOffset = Constant.lineHeight * (Constant.monthLines - 1);
    bool isWeek = offset >= _midScrollOffset || (_midScrollOffset - offset) < 1;
    if (_isWeek != isWeek) {
      _isWeek = isWeek;
      notifyListeners();
    }
  }
}