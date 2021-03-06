import 'package:flutter/material.dart';

///
/// 重要程度视图
///
class ImportanceView extends StatelessWidget {
  ImportanceView(
      {required this.importance,
      this.padding = const EdgeInsets.all(10.0),
      this.fontSize = 25});

  // 重要程度
  final int importance;

  // 边距
  final EdgeInsetsGeometry padding;

  // 字体大小
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text.rich(TextSpan(
          children: _buildText(), style: TextStyle(fontSize: fontSize))),
    );
  }

  ///
  /// 构建文本
  ///
  List<TextSpan> _buildText() {
    List<TextSpan> texts = [];
    for (int i = 0; i < 3; i++) {
      texts.add(
        TextSpan(
            text: '!',
            style: TextStyle(color: i < importance ? Colors.red : Colors.grey)),
      );
    }
    return texts;
  }
}
