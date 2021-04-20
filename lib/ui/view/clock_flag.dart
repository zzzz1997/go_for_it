import 'package:flutter/material.dart';

///
/// 打卡旗帜
///
class ClockFlag extends StatelessWidget {
  ClockFlag(
      {required this.clocked, required this.color, required this.onPressed});

  // 是否打卡
  final bool clocked;

  // 颜色
  final Color color;

  // 点击事件
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.flag,
        color: clocked ? color : Colors.grey,
      ),
      onPressed: onPressed,
    );
  }
}
