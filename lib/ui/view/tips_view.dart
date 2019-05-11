import 'package:flutter/material.dart';

///
/// 提示视图
///
class TipsView extends StatelessWidget {
  // 视图
  final Widget view;

  // 提示
  final String tips;

  // 点击方法
  final Function onTap;

  TipsView({@required this.view, this.tips, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            view,
            tips != null ? SizedBox(height: 10,) : SizedBox(),
            tips != null ? Text(tips, style: TextStyle(fontSize: 20),) : SizedBox(),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
