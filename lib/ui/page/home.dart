import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gtd_task/model/main.dart';
import 'package:gtd_task/ui/view/calendar.dart';
import 'package:gtd_task/util/constant.dart';

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
  @override
  Widget build(BuildContext context) {
    // 初始化ScreenUtil
    ScreenUtil.instance =
        ScreenUtil(width: Constant.width, height: Constant.height)
          ..init(context);
    return ScopedModelDescendant<MainStateModel>(
        builder: (context, widget, model) {
      return Scaffold(
        appBar: AppBar(),
        body: ScreenUtil().setWidth(Constant.width) > 0
            ? Calendar(
                width: ScreenUtil().setWidth(Constant.width),
                themeData: model.themeData,
              )
            : SizedBox(),
      );
    });
  }
}
