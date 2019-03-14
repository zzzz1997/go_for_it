import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:go_for_it/model/main.dart';
import 'package:go_for_it/ui/fragment/clock.dart';
import 'package:go_for_it/ui/fragment/time.dart';
import 'package:go_for_it/ui/fragment/todo.dart';
import 'package:go_for_it/util/constant.dart';

///
/// 主页面
///
class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

///
/// 主页面状态
///
class _HomePageState extends State<HomePage> {

  // swiper控制器
  final SwiperController _swiperController = SwiperController();

  // 当前位置
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // 初始化ScreenUtil
    ScreenUtil.instance =
        ScreenUtil(width: Constant.width, height: Constant.height)
          ..init(context);
    return ScopedModelDescendant<MainStateModel>(
        builder: (context, widget, model) {
          // 底部导航列表
          List<BottomNavigationBarItem> _items = List();
          for (int i = 0; i < Constant.tabTexts.length; i++) {
            _items.add(BottomNavigationBarItem(
              icon: _getIcon(i, model.themeData.primaryColor),
              title: Text(Constant.tabTexts[i]),
            ));
          }
      return Scaffold(
        body: Swiper(
          controller: _swiperController,
          itemCount: _items.length,
          itemBuilder: _buildItems,
          onIndexChanged: _onIndexChanged,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: _items,
          currentIndex: _currentIndex,
          onTap: _onBarTap,
        ),
      );
    });
  }

  ///
  /// 获取图标
  ///
  _getIcon(int index, Color primaryColor) {
    return SvgPicture.asset(
      Constant.tabSVGs[index],
      color: index == _currentIndex ? primaryColor :  Colors.grey,
      width: 32.0,
    );
  }

  ///
  /// 构建碎片布局
  ///
  Widget _buildItems(BuildContext context, int index) {
    switch (index) {
      case 0:
        return ClockFragment();
        break;
      case 1:
        return TimeFragment();
        break;
      case 2:
        return TodoFragment();
        break;
      default:
        return Text(Constant.unknownArea);
    }
  }

  ///
  /// 页面切换监听
  ///
  _onIndexChanged(int index) {
    setState(() {
      if (_currentIndex != index) {
        _currentIndex = index;
      }
    });
  }

  ///
  /// 底部导航栏点击事件
  ///
  _onBarTap(int index) {
    _swiperController.move(index);
    _onIndexChanged(index);
  }
}
