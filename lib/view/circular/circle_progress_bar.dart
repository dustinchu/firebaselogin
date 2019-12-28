import 'dart:math';

import 'package:flutter/material.dart';

typedef ProgressChanged<double> = void Function(double value);

num degToRad(num deg) => deg * (pi / 180.0);

num radToDeg(num rad) => rad * (180.0 / pi);

class CircleProgressBar extends StatefulWidget {
  final double radius;
  final double progress;
  final double dotRadius;
  final Color shadowColor;
  final Color dotStartColor;
  final Color dotEndColor;
  final Color dotEdgeColor;
  final Color ringColor;
  final Color progressColor;

  final ProgressChanged progressChanged;

  const CircleProgressBar({
    Key key,
    @required this.radius,
    @required this.dotRadius,
    @required this.dotStartColor,
    @required this.dotEndColor,
    @required this.progressColor,
    this.shadowColor = Colors.black12,
    this.ringColor = const Color(0XFFF7F7FC),
    this.dotEdgeColor = const Color(0XFFF5F5FA),
    this.progress,
    this.progressChanged,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CircleProgressState();
}

class _CircleProgressState extends State<CircleProgressBar>
    with SingleTickerProviderStateMixin {
  AnimationController progressController;
  bool isValidTouch = false;
  final GlobalKey paintKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    progressController =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    if (widget.progress != null) progressController.value = widget.progress;
    progressController.addListener(() {
      if (widget.progressChanged != null)
        widget.progressChanged(progressController.value);
      setState(() {});
    });
  }

  @override
  void dispose() {
    progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = widget.radius * 2.0;
    final size = new Size(width, width);
    return GestureDetector(
      onPanStart: _onPanStart,
//      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Container(
        alignment: FractionalOffset.center,
        child: CustomPaint(
          key: paintKey,
          size: size,
          painter: ProgressPainter(
              dotRadius: widget.dotRadius,
              shadowColor: widget.shadowColor,
              ringColor: widget.ringColor,
              progressColor: widget.progressColor,
              dotStartColor: widget.dotStartColor,
              dotEndColor: widget.dotEndColor,
              dotEdgeColor: widget.dotEdgeColor,
              progress: progressController.value),
        ),
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    RenderBox getBox = paintKey.currentContext.findRenderObject();
    Offset local = getBox.globalToLocal(details.globalPosition);
    isValidTouch = _checkValidTouch(local);
    if (!isValidTouch) {
      return;
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!isValidTouch) {
      return;
    }
    RenderBox getBox = paintKey.currentContext.findRenderObject();
    Offset local = getBox.globalToLocal(details.globalPosition);
    final double x = local.dx;
    final double y = local.dy;
    final double center = widget.radius;
    double radians = atan((x - center) / (center - y));
    if (y > center) {
      radians = radians + degToRad(180.0);
    } else if (x < center) {
      radians = radians + degToRad(360.0);
    }
    progressController.value = radians / degToRad(360.0);
  }

  void _onPanEnd(DragEndDetails details) {
    if (!isValidTouch) {
      return;
    }
  }

  bool _checkValidTouch(Offset pointer) {
    final double validInnerRadius = widget.radius - widget.dotRadius * 3;
    final double dx = pointer.dx;
    final double dy = pointer.dy;
    final double distanceToCenter =
        sqrt(pow(dx - widget.radius, 2) + pow(dy - widget.radius, 2));
    if (distanceToCenter < validInnerRadius ||
        distanceToCenter > widget.radius) {
      return false;
    }
    return true;
  }
}

class ProgressPainter extends CustomPainter {
  final double dotRadius;
  final double shadowWidth;
  final Color shadowColor;
  final Color dotStartColor;
  final Color dotEndColor;
  final Color dotEdgeColor;
  final Color ringColor;
  final double progress;
  final Color progressColor;

  ProgressPainter({
    this.dotRadius,
    this.shadowWidth = 2.0,
    this.shadowColor = Colors.black12,
    this.ringColor = Colors.black12,
    this.progressColor,
    this.dotStartColor,
    this.dotEndColor,
    this.dotEdgeColor = Colors.black12,
    this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double center = size.width * 0.5;
    final Offset offsetCenter = Offset(center, center);
    final double drawRadius = size.width * 0.5 - dotRadius;
    final angle = 360.0 * progress;
    final double radians = degToRad(angle);

    final double radiusOffset = dotRadius * 0.4;
    final double outerRadius = center - radiusOffset;
    final double innerRadius = center - dotRadius * 2 + radiusOffset;

    Path path = Path.combine(
        PathOperation.difference,
        Path()
          ..addOval(Rect.fromCircle(center: offsetCenter, radius: outerRadius)),
        Path()
          ..addOval(
              Rect.fromCircle(center: offsetCenter, radius: innerRadius)));
    canvas.drawShadow(path, shadowColor, 4.0, true);

    // draw ring.
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color =  Colors.white12
      ..strokeWidth = (outerRadius - innerRadius-2);
    canvas.drawCircle(offsetCenter, drawRadius, ringPaint);

    // draw progress.
    if (progress > 0.0) {
      final progressWidth = outerRadius - innerRadius + radiusOffset ;
      final double offset = asin(progressWidth * 0.5 / drawRadius);
      if (radians > offset) {
        canvas.save();
        canvas.translate(0.0, size.width);
        canvas.rotate(degToRad(-90.0));
        /*
        顏色漸變Flutter提供了三種基礎的用來繪製漸變效果的類：
        SweepGradient（掃描漸變）
        LinearGradient（線性漸變）
        RadialGradient（徑向漸變）。
         */
//        final Gradient gradient = new SweepGradient(
//          endAngle: radians,
//          colors: [
//            Colors.white,
//            currentDotColor,
//          ],
//        );
        final Rect arcRect =
            Rect.fromCircle(center: offsetCenter, radius: drawRadius);
        final progressPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = progressWidth
          ..color = progressColor;
        canvas.drawArc(arcRect, offset, radians - offset, false, progressPaint);
        canvas.restore();
      }
    }

//    // draw dot.
//    final double dx = center + drawRadius * sin(radians);
//    final double dy = center - drawRadius * cos(radians);
//    final dotPaint = Paint()..color = Color.fromRGBO(0, 243, 171, 1);
//    canvas.drawCircle(new Offset(dx, dy), dotRadius + 3, dotPaint);

//    final Gradient gradient = new RadialGradient(
//      center: const Alignment(0, 0), // near the top right
//      colors: [
//        dotStartColor, // yellow sun
//        dotEndColor, // blue sky
//      ],
//      stops: [0.5, 1],
//    );
//    final Rect arcRect =
//        Rect.fromCircle(center: new Offset(dx, dy), radius: dotRadius + 3);
//
//    final dotPaint2 = Paint()..shader = gradient.createShader(arcRect);
//    canvas.drawCircle(new Offset(dx, dy), dotRadius + 3, dotPaint2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
