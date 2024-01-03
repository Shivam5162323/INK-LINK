import 'package:flutter/material.dart';

import 'dart:math' as math;

class StaggeredDotsWave extends StatefulWidget {
  final double size;
  final Color color;

  const StaggeredDotsWave({
    Key? key,
    required this.size,
    required this.color,
  }) : super(key: key);

  @override
  State<StaggeredDotsWave> createState() => _StaggeredDotsWaveState();
}

class _StaggeredDotsWaveState extends State<StaggeredDotsWave>
    with SingleTickerProviderStateMixin {
  late AnimationController _offsetController;

  @override
  void initState() {
    super.initState();

    _offsetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    final double oddDotHeight = widget.size * 0.4;
    final double evenDotHeight = widget.size * 0.7;

    return Container(
      alignment: Alignment.center,
      // color: Colors.black,
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _offsetController,
        builder: (_, __) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            DotContainer(
              controller: _offsetController,
              heightInterval: const Interval(0.0, 0.1),
              offsetInterval: const Interval(0.18, 0.28),
              reverseHeightInterval: const Interval(0.28, 0.38),
              reverseOffsetInterval: const Interval(0.47, 0.57),
              color: widget.color,
              size: widget.size,
              maxHeight: oddDotHeight,
            ),
            DotContainer(
              controller: _offsetController,
              heightInterval: const Interval(0.09, 0.19),
              offsetInterval: const Interval(0.27, 0.37),
              reverseHeightInterval: const Interval(0.37, 0.47),
              reverseOffsetInterval: const Interval(0.56, 0.66),
              color: widget.color,
              size: widget.size,
              maxHeight: evenDotHeight,
            ),
            DotContainer(
              controller: _offsetController,
              heightInterval: const Interval(0.18, 0.28),
              offsetInterval: const Interval(0.36, 0.46),
              reverseHeightInterval: const Interval(0.46, 0.56),
              reverseOffsetInterval: const Interval(0.65, 0.75),
              color: widget.color,
              size: widget.size,
              maxHeight: oddDotHeight,
            ),
            DotContainer(
              controller: _offsetController,
              heightInterval: const Interval(0.27, 0.37),
              offsetInterval: const Interval(0.45, 0.55),
              reverseHeightInterval: const Interval(0.55, 0.65),
              reverseOffsetInterval: const Interval(0.74, 0.84),
              color: widget.color,
              size: widget.size,
              maxHeight: evenDotHeight,
            ),
            DotContainer(
              controller: _offsetController,
              heightInterval: const Interval(0.36, 0.46),
              offsetInterval: const Interval(0.54, 0.64),
              reverseHeightInterval: const Interval(0.64, 0.74),
              reverseOffsetInterval: const Interval(0.83, 0.93),
              color: widget.color,
              size: widget.size,
              maxHeight: oddDotHeight,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _offsetController.dispose();
    super.dispose();
  }
}

class DotContainer extends StatelessWidget {
  final Interval offsetInterval;
  final double size;
  final Color color;

  final Interval reverseOffsetInterval;
  final Interval heightInterval;
  final Interval reverseHeightInterval;
  final double maxHeight;
  final AnimationController controller;

  const DotContainer({
    Key? key,
    required this.offsetInterval,
    required this.size,
    required this.color,
    required this.reverseOffsetInterval,
    required this.heightInterval,
    required this.reverseHeightInterval,
    required this.maxHeight,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final Interval interval = widget.offsetInterval;
    // final Interval reverseInterval = widget.reverseOffsetInterval;
    // final Interval heightInterval = widget.heightInterval;
    // final double size = widget.size;
    // final Interval reverseHeightInterval = widget.reverseHeightInterval;
    // final double maxHeight = widget.maxHeight;
    final double maxDy = -(size * 0.20);

    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Opacity(
              opacity: controller.value <= offsetInterval.end ? 1 : 0,
              // opacity: 1,
              child: Transform.translate(
                offset: Tween<Offset>(
                  begin: Offset.zero,
                  end: Offset(0, maxDy),
                )
                    .animate(
                  CurvedAnimation(
                    parent: controller,
                    curve: offsetInterval,
                  ),
                )
                    .value,
                child: Container(
                  width: size * 0.13,
                  height: Tween<double>(
                    begin: size * 0.13,
                    end: maxHeight,
                  )
                      .animate(
                    CurvedAnimation(
                      parent: controller,
                      curve: heightInterval,
                    ),
                  )
                      .value,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(size),
                  ),
                ),
              ),
            ),
            Opacity(
              opacity: controller.value >= offsetInterval.end ? 1 : 0,
              child: Transform.translate(
                offset: Tween<Offset>(
                  begin: Offset(0, maxDy),
                  end: Offset.zero,
                )
                    .animate(
                  CurvedAnimation(
                    parent: controller,
                    curve: reverseOffsetInterval,
                  ),
                )
                    .value,
                child: Container(
                  width: size * 0.13,
                  height: Tween<double>(
                    end: size * 0.13,
                    begin: maxHeight,
                  )
                      .animate(
                    CurvedAnimation(
                      parent: controller,
                      curve: reverseHeightInterval,
                    ),
                  )
                      .value,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(size),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}














class DrawDot extends StatelessWidget {
  final double width;
  final double height;
  final bool circular;
  final Color color;

  const DrawDot.circular({
    Key? key,
    required double dotSize,
    required this.color,
  })  : width = dotSize,
        height = dotSize,
        circular = true,
        super(key: key);

  const DrawDot.elliptical({
    Key? key,
    required this.width,
    required this.height,
    required this.color,
  })  : circular = false,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        shape: circular ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circular
            ? null
            : BorderRadius.all(Radius.elliptical(width, height)),
      ),
    );
  }
}








class BuildDot extends StatelessWidget {
  final Color color;
  final double angle;
  final double size;
  final Interval interval;
  final AnimationController controller;
  final bool first;
  const BuildDot.first({
    Key? key,
    required this.color,
    required this.angle,
    required this.size,
    required this.interval,
    required this.controller,
  })  : first = true,
        super(key: key);

  const BuildDot.second({
    Key? key,
    required this.color,
    required this.angle,
    required this.size,
    required this.interval,
    required this.controller,
  })  : first = false,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: Transform.translate(
        offset: Offset(0, -size / 2.4),
        child: UnconstrainedBox(
          child: DrawDot.circular(
            color: color,
            dotSize: first
                ? Tween<double>(
              begin: 0.0,
              end: size / 6,
            )
                .animate(
              CurvedAnimation(
                parent: controller,
                curve: interval,
              ),
            )
                .value
                : Tween<double>(
              begin: size / 6,
              end: 0.0,
            )
                .animate(
              CurvedAnimation(
                parent: controller,
                curve: interval,
              ),
            )
                .value,
          ),
        ),
      ),
    );
  }
}






















class HexagonDots extends StatefulWidget {
  final double size;
  final Color color;

  const HexagonDots({
    Key? key,
    required this.size,
    required this.color,
  }) : super(key: key);

  @override
  _BuildSpinnerState createState() => _BuildSpinnerState();
}

class _BuildSpinnerState extends State<HexagonDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();

    _rotationAnimation = Tween<double>(begin: 0, end: 3 * math.pi / 2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.3,
          1.0,
        ),
      ),
    );
  }

  Widget _buildInitialDot(double angle, Interval interval) => BuildDot.first(
    size: widget.size,
    color: widget.color,
    angle: angle,
    controller: _animationController,
    interval: interval,
  );

  Widget _buildLaterDot(double angle, Interval interval) => BuildDot.second(
    size: widget.size,
    color: widget.color,
    angle: angle,
    controller: _animationController,
    interval: interval,
  );

  @override
  Widget build(BuildContext context) {
    const double angle30 = math.pi / 6;
    const double angle60 = math.pi / 3;
    const double angle120 = 2 * math.pi / 3;
    const double angle180 = math.pi;
    const double angle240 = 4 * math.pi / 3;
    const double angle300 = 5 * math.pi / 3;

    return Center(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (_, __) => SizedBox(
          width: widget.size,
          height: widget.size,
          child: _animationController.value <= 0.28
              ? Stack(
            alignment: Alignment.center,
            children: <Widget>[
              _buildInitialDot(0 + angle30, const Interval(0, 0.08)),
              _buildInitialDot(
                  angle60 + angle30, const Interval(0.04, 0.12)),
              _buildInitialDot(
                  angle120 + angle30, const Interval(0.08, 0.16)),
              _buildInitialDot(
                  angle180 + angle30, const Interval(0.12, 0.20)),
              _buildInitialDot(
                  angle240 + angle30, const Interval(0.16, 0.24)),
              _buildInitialDot(
                  angle300 + angle30, const Interval(0.20, 0.28)),
            ],
          )
              : Transform.rotate(
            angle: _rotationAnimation.value,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                _buildLaterDot(
                  0 + angle30,
                  const Interval(
                    0.80,
                    0.88,
                  ),
                ),
                _buildLaterDot(
                  angle60 + angle30,
                  const Interval(
                    0.76,
                    0.84,
                  ),
                ),
                _buildLaterDot(
                  angle120 + angle30,
                  const Interval(
                    0.72,
                    0.80,
                  ),
                ),
                _buildLaterDot(
                  angle180 + angle30,
                  const Interval(
                    0.68,
                    0.76,
                  ),
                ),
                _buildLaterDot(
                  angle240 + angle30,
                  const Interval(
                    0.64,
                    0.72,
                  ),
                ),
                _buildLaterDot(
                  angle300 + angle30,
                  const Interval(
                    0.60,
                    0.68,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}































class TwistingDots extends StatefulWidget {
  final double size;
  final Color leftDotColor;
  final Color rightDotColor;

  const TwistingDots({
    Key? key,
    required this.size,
    required this.leftDotColor,
    required this.rightDotColor,
  }) : super(key: key);

  @override
  _TwistingDotsState createState() => _TwistingDotsState();
}

class _TwistingDotsState extends State<TwistingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    final double size = widget.size;
    final Color firstColor = widget.leftDotColor;
    final Color secondColor = widget.rightDotColor;
    final double dotSize = size / 3;

    return SizedBox(
      width: size,
      height: size,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (_, __) => Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Visibility(
              visible: _animationController.value < 0.5,
              child: Transform.rotate(
                angle: Tween<double>(
                  begin: 0,
                  end: math.pi,
                )
                    .animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: const Interval(
                      0.0,
                      0.5,
                      curve: Curves.elasticOut,
                    ),
                  ),
                )
                    .value,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    DrawDot.circular(
                      dotSize: dotSize,
                      color: firstColor,
                    ),
                    DrawDot.circular(
                      dotSize: dotSize,
                      color: secondColor,
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: _animationController.value > 0.5,
              child: Transform.rotate(
                angle: Tween<double>(
                  begin: -math.pi,
                  end: 0,
                )
                    .animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: const Interval(
                      0.5,
                      1.0,
                      curve: Curves.elasticOut,
                    ),
                  ),
                )
                    .value,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    DrawDot.circular(
                      dotSize: dotSize,
                      color: firstColor,
                    ),
                    DrawDot.circular(
                      dotSize: dotSize,
                      color: secondColor,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}


























class Arc extends CustomPainter {
  final Color _color;
  final double _strokeWidth;
  final double _sweepAngle;
  final double _startAngle;

  Arc._(
      this._color,
      this._strokeWidth,
      this._startAngle,
      this._sweepAngle,
      );

  static Widget draw({
    required Color color,
    required double size,
    required double strokeWidth,
    required double startAngle,
    required double endAngle,
  }) =>
      SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: Arc._(
            color,
            strokeWidth,
            startAngle,
            endAngle,
          ),
        ),
      );

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.height / 2,
    );

    const bool useCenter = false;
    final Paint paint = Paint()
      ..color = _color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = _strokeWidth;

    canvas.drawArc(rect, _startAngle, _sweepAngle, useCenter, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}












class TwoRotatingArc extends StatefulWidget {
  final double size;
  final Color color;
  const TwoRotatingArc({
    Key? key,
    required this.color,
    required this.size,
  }) : super(key: key);

  @override
  _TwoRotatingArcState createState() => _TwoRotatingArcState();
}

class _TwoRotatingArcState extends State<TwoRotatingArc>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  final Cubic firstCurve = Curves.easeInQuart;
  final Cubic secondCurve = Curves.easeOutQuart;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    final double size = widget.size;
    final double strokeWidth = size / 10;
    final Color color = widget.color;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (_, __) => Stack(
        children: <Widget>[
          Visibility(
            visible: _animationController.value <= 0.5,
            child: Transform.rotate(
              angle: Tween<double>(
                begin: 0.0,
                end: 3 * math.pi / 4,
              )
                  .animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(
                    0.0,
                    0.5,
                    curve: firstCurve,
                  ),
                ),
              )
                  .value,
              child: Arc.draw(
                color: color,
                size: size,
                strokeWidth: strokeWidth,
                startAngle: -math.pi / 2,
                // endAngle: math.pi / (size * size),
                endAngle: Tween<double>(
                  begin: math.pi / (size * size),
                  end: -math.pi / 2,
                )
                    .animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Interval(
                      0.0,
                      0.5,
                      curve: firstCurve,
                    ),
                  ),
                )
                    .value,
              ),
            ),
          ),
          Visibility(
            visible: _animationController.value >= 0.5,
            child: Transform.rotate(
              angle: Tween<double>(
                begin: math.pi / 4,
                end: math.pi,
              )
                  .animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(
                    0.5,
                    1.0,
                    curve: secondCurve,
                  ),
                ),
              )
                  .value,
              child: Arc.draw(
                color: color,
                size: size,
                strokeWidth: strokeWidth,
                startAngle: -math.pi / 2,
                // endAngle: math.pi / (size * size),
                endAngle: Tween<double>(
                  begin: math.pi / 2,
                  end: math.pi / (size * size),
                )
                    .animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Interval(
                      0.5,
                      1.0,
                      curve: secondCurve,
                    ),
                  ),
                )
                    .value,
              ),
            ),
          ),

          ///
          ///second one
          ///
          ///
          Visibility(
            visible: _animationController.value <= 0.5,
            child: Transform.rotate(
              angle: Tween<double>(begin: -math.pi, end: -math.pi / 4)
                  .animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(0.0, 0.5, curve: firstCurve),
                ),
              )
                  .value,
              child: Arc.draw(
                color: color,
                size: size,
                strokeWidth: strokeWidth,
                startAngle: -math.pi / 2,
                // endAngle: math.pi / (size * size),
                endAngle: Tween<double>(
                  begin: math.pi / (size * size),
                  end: -math.pi / 2,
                )
                    .animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Interval(
                      0.0,
                      0.5,
                      curve: firstCurve,
                    ),
                  ),
                )
                    .value,
              ),
            ),
          ),
          Visibility(
            visible: _animationController.value >= 0.5,
            child: Transform.rotate(
              angle: Tween<double>(
                begin: -3 * math.pi / 4,
                end: 0.0,
              )
                  .animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(
                    0.5,
                    1.0,
                    curve: secondCurve,
                  ),
                ),
              )
                  .value,
              child: Arc.draw(
                color: color,
                size: size,
                strokeWidth: strokeWidth,
                startAngle: -math.pi / 2,
                // endAngle: math.pi / (size * size),
                endAngle: Tween<double>(
                  begin: math.pi / 2,
                  end: math.pi / (size * size),
                )
                    .animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Interval(
                      0.5,
                      1.0,
                      curve: secondCurve,
                    ),
                  ),
                )
                    .value,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}












class HorizontalRotatingDots extends StatefulWidget {
  final double size;
  final Color color;

  const HorizontalRotatingDots({
    Key? key,
    required this.size,
    required this.color,
  }) : super(key: key);

  @override
  _HorizontalRotatingDotsState createState() => _HorizontalRotatingDotsState();
}

class _HorizontalRotatingDotsState extends State<HorizontalRotatingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _leftDotTranslate;

  late Animation<double> _middleDotScale;
  late Animation<Offset> _middleDotTranslate;

  late Animation<double> _rightDotScale;
  late Animation<Offset> _rightDotTranslate;

  final Interval _interval = const Interval(
    0.0,
    1.0,
    curve: Curves.easeOutCubic,
  );
  @override
  void initState() {
    super.initState();
    final double size = widget.size;
    final double dotSize = size / 4;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();

    _leftDotTranslate = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(size - dotSize, 0),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: _interval,
      ),
    );

    _middleDotScale = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: _interval,
      ),
    );

    _middleDotTranslate = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(-(size - dotSize) / 2, 0),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: _interval,
      ),
    );

    _rightDotScale = Tween<double>(
      begin: 1.0,
      end: 0.6,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: _interval,
      ),
    );

    _rightDotTranslate = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(-(size - dotSize) / 2, 0),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: _interval,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double size = widget.size;

    final Color color = widget.color;
    final double dotSize = size / 4;
    return SizedBox(
      width: size,
      height: size,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (_, __) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Transform.translate(
              offset: _leftDotTranslate.value,
              child: DrawDot.circular(
                dotSize: dotSize,
                color: color,
              ),
            ),
            Transform.scale(
              scale: _middleDotScale.value,
              child: Transform.translate(
                offset: _middleDotTranslate.value,
                child: DrawDot.circular(
                  dotSize: dotSize,
                  color: color,
                ),
              ),
            ),
            Transform.translate(
              offset: _rightDotTranslate.value,
              child: Transform.scale(
                scale: _rightDotScale.value,
                child: DrawDot.circular(
                  dotSize: dotSize,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}





























