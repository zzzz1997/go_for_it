import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:connectivity/connectivity.dart';
import 'package:go_for_it/model/main.dart';
import 'package:go_for_it/ui/page/home.dart';
import 'package:go_for_it/ui/page/setting.dart';
import 'package:go_for_it/util/constant.dart';

///
/// App入口
///
void main() => runApp(MyApp());

///
/// App
///
class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  // 连接状态
  var _connectivityResult = ConnectivityResult.none;

  // 连接对象
  final _connectivity = Connectivity();

  // 连接状态监听
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();

    _initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _connectivityResult = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    MainStateModel model = MainStateModel(context, _connectivityResult);
    return ScreenUtilInit(
      designSize: Size(Constant.width, Constant.height),
      allowFontScaling: false,
      builder: () => ScopedModel<MainStateModel>(
        model: model,
        child: MaterialApp(
          title: Constant.appTag,
          theme: model.themeData,
          home: HomePage(),
          routes: <String, WidgetBuilder>{
            '/home': (BuildContext context) => HomePage(),
            '/setting': (BuildContext context) => SettingPage(),
          },
        ),
      ),
    );
  }

  ///
  /// 初始化连接
  ///
  Future<Null> _initConnectivity() async {
    ConnectivityResult connectivityResult;
    try {
      connectivityResult = await _connectivity.checkConnectivity();
    } catch (e) {
      print(e.toString());
      connectivityResult = ConnectivityResult.none;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _connectivityResult = connectivityResult;
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
