import 'package:flutter/material.dart';

///
/// 打卡进度图
///
class ClockProgress extends StatelessWidget {
  ClockProgress({
    required this.width,
    required this.height,
    required this.frontColor,
    this.backColor = Colors.white,
    this.total = 100,
    required this.data,
  })  : assert(width >= 0),
        assert(height >= 0),
        assert(total >= 0);

  // 宽度
  final double width;

  // 高度
  final double height;

  // 前景色
  final Color frontColor;

  // 背景色
  final Color backColor;

  // 总数
  final int total;

  // 数据
  final List<int> data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
          key: GlobalKey(),
          foregroundPainter: _ClockProgressPainter(
            frontColor: frontColor,
            backColor: backColor,
            total: total,
            data: data,
          ),
      ),
    );
  }
}

///
/// 打卡进度图画笔
///
class _ClockProgressPainter extends CustomPainter {
  _ClockProgressPainter({
    required this.frontColor,
    required this.backColor,
    required this.total,
    required this.data,
  });

  // 前景色
  final Color frontColor;

  // 背景色
  final Color backColor;

  // 总数
  final int total;

  // 数据
  final List<int> data;

  @override
  void paint(Canvas canvas, Size size) {
    // 前景画笔
    final Paint frontPaint = Paint()..color = frontColor;
    // 背景画笔
    final Paint backPaint = Paint()..color = backColor;
    // 绘制背景
    canvas.drawRect(
        Rect.fromLTRB(0.0, 0.0, size.width, size.height), backPaint);
    if (total > 0) {
      // 绘制前景
      data.forEach((d) {
        canvas.drawRect(
            Rect.fromLTRB(size.width * d / total, 0.0,
                size.width * (d + 1) / total, size.height),
            frontPaint);
      });
    }
  }

  @override
  bool shouldRepaint(_ClockProgressPainter oldDelegate) {
    return oldDelegate.total != total || oldDelegate.data != data;
  }
}
