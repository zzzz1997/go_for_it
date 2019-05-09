import 'package:flutter/material.dart';
import 'package:go_for_it/ui/view/full_screen_dialog.dart';

///
/// 弹窗工具类
///
class ModalUtil {

  ///
  /// 显示任务弹窗
  ///
  static void showTaskModal(context, task, type) {
    Navigator.of(context).push(MaterialPageRoute<Null>(
      builder: (BuildContext context) {
        return FullscreenDialog(
          task: task,
          type: type,
        );
      },
      fullscreenDialog: true,
    ));
  }
}
