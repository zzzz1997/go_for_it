import 'package:flutter/material.dart';

///
/// 半选选择框
///
class HalfCheckBox extends StatelessWidget {
  HalfCheckBox(
      {required this.status, required this.color, required this.onPressed});

  // 状态
  final int status;

  // 颜色
  final Color color;

  // 点击事件
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_icon(status)),
      onPressed: onPressed,
      color: status == 2 ? Colors.grey : color,
    );
  }

  ///
  /// 获取图标
  ///
  IconData _icon(int status) {
    IconData iconData;
    switch (status) {
      case 0:
        iconData = Icons.radio_button_unchecked;
        break;
      case 1:
        iconData = Icons.check_circle_outline;
        break;
      case 2:
        iconData = Icons.check_circle_outline;
        break;
      default:
        return Icons.check_circle_outline;
    }
    return iconData;
  }
}
