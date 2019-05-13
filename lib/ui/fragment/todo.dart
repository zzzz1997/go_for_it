import 'package:flutter/material.dart';
import 'package:go_for_it/util/constant.dart';

///
/// 待办清单
///
class TodoFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ExpansionTile(
      title: Text(
        Constant.todayTask,
        style: TextStyle(color: Colors.black),
      ),
      initiallyExpanded: true,
      children: <Widget>[Text('bbb'), Text('ccc')],
    ));
  }
}
