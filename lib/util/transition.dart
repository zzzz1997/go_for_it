import 'package:flutter/material.dart';

// 移动类型枚举
enum TransitionType {
  native,
  nativeModal,
  inFromLeft,
  inFromRight,
  inFromBottom,
  fadeIn,
  custom
}

///
/// 移动工具类
///
class Transition {
  ///
  /// 跳转界面
  ///
  static push(
      BuildContext context, Widget page, TransitionType transitionType) {
    Navigator.push(
        context,
        PageRouteBuilder(
            pageBuilder: (BuildContext context, _, __) {
              return page;
            },
            transitionsBuilder:
                Transition.standardTransitionsBuilder(transitionType)));
  }

  ///
  /// 跳转并删除其它栈
  ///
  static pushAndRemoveUntil(
      BuildContext context, Widget page, TransitionType transitionType) {
    Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
            pageBuilder: (BuildContext context, _, __) {
              return page;
            },
            transitionsBuilder:
                Transition.standardTransitionsBuilder(transitionType)),
        (route) => false);
  }

  ///
  /// 移动构建器
  ///
  static RouteTransitionsBuilder standardTransitionsBuilder(
      TransitionType transitionType) {
    return (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child) {
      if (transitionType == TransitionType.fadeIn) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      } else {
        const Offset topLeft = Offset(0.0, 0.0);
        const Offset topRight = Offset(1.0, 0.0);
        const Offset bottomLeft = Offset(0.0, 1.0);
        Offset startOffset = bottomLeft;
        Offset endOffset = topLeft;
        if (transitionType == TransitionType.inFromLeft) {
          startOffset = Offset(-1.0, 0.0);
          endOffset = topLeft;
        } else if (transitionType == TransitionType.inFromRight) {
          startOffset = topRight;
          endOffset = topLeft;
        }

        return SlideTransition(
          position: Tween<Offset>(begin: startOffset, end: endOffset)
              .animate(animation),
          child: child,
        );
      }
    };
  }
}
