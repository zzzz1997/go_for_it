import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:gtd_task/model/main.dart';
import 'package:gtd_task/ui/page/home.dart';
import 'package:gtd_task/util/constant.dart';

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
  @override
  Widget build(BuildContext context) {
    MainStateModel model = MainStateModel(context);
    return ScopedModel<MainStateModel>(
      model: model,
      child: MaterialApp(
        title: Constant.appTag,
        theme: model.themeData,
        home: HomePage(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => HomePage(),
        },
      ),
    );
  }
}