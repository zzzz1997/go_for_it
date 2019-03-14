import 'package:flutter/material.dart';

///
/// 半选选择框状态枚举
///
enum HalfCheckBoxStatus {
  UNCHECKED,
  HALF_CHECKED,
  CHECKED,
}

///
/// 半选选择框
///
class HalfCheckBox extends StatelessWidget {
  // 状态
  final HalfCheckBoxStatus status;

  // 颜色
  final Color color;

  // 点击事件
  final Function onPressed;

  HalfCheckBox({@required this.status, this.color, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_icon(status)),
      onPressed: onPressed,
      color: status == HalfCheckBoxStatus.CHECKED ? Colors.grey : color,
    );
  }

  ///
  /// 获取图标
  ///
  IconData _icon(HalfCheckBoxStatus status) {
    IconData iconData;
    switch (status) {
      case HalfCheckBoxStatus.UNCHECKED:
        iconData = Icons.radio_button_unchecked;
        break;
      case HalfCheckBoxStatus.HALF_CHECKED:
        iconData = Icons.check_circle_outline;
        break;
      case HalfCheckBoxStatus.CHECKED:
        iconData = Icons.check_circle_outline;
        break;
    }
    return iconData;
  }
}
