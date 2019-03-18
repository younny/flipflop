import 'package:flutter/material.dart';

class ScrollIndicator extends StatelessWidget {
  final int numOfSteps;
  final double scrollPercent;

  ScrollIndicator({
    this.numOfSteps,
    this.scrollPercent
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ScrollIndicatorPainter(
          numOfSteps: numOfSteps,
          scrollPercent: scrollPercent
      ),

      child: Container(),
    );
  }
}

class ScrollIndicatorPainter extends CustomPainter {
  final int numOfSteps;
  final double scrollPercent;
  final Paint trackPaint;
  final Paint thumbPaint;

  ScrollIndicatorPainter({
    this.numOfSteps,
    this.scrollPercent
  }) : trackPaint = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.fill,
        thumbPaint = Paint()
          ..color = Colors.amber
          ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {

    canvas.drawRRect(
        RRect.fromRectAndCorners(
            Rect.fromLTWH(
                0.0,
                0.0,
                size.width,
                size.height
            ),
            topLeft: Radius.circular(3.0),
            topRight: Radius.circular(3.0),
            bottomLeft: Radius.circular(3.0),
            bottomRight: Radius.circular(3.0)

        ),
        trackPaint
    );

    final thumbWidth = size.width / numOfSteps;
    final thumbLeft = scrollPercent * size.width;

    canvas.drawRRect(
        RRect.fromRectAndCorners(
            Rect.fromLTWH(
                thumbLeft,
                0.0,
                thumbWidth,
                size.height
            )
        ),
        thumbPaint
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}