
import 'package:flutter/material.dart';
import 'package:module_flutter/common/model/button_model.dart';
import 'package:module_flutter/ui/painter/bubbles_painter.dart';
import 'package:module_flutter/ui/painter/circle_painter.dart';

class FireButton extends StatefulWidget {
  final AnimationController? controller;
  final Widget child;
  final double size;
  final double bubblesSize;
  final BubblesColor bubblesColor;
  final double circleSize;
  final CircleColor circleColor;

  const FireButton(
      {Key? key,
        required this.controller,
        required this.child,
        this.size = 30.0,
        bubblesSize,
        this.bubblesColor = const BubblesColor(
          dotPrimaryColor: Color(0xFFFFC107),
          dotSecondaryColor: Color(0xFFFF9800),
          dotThirdColor: Color(0xFFFF5722),
          dotLastColor: Color(0xFFF44336),
        ),
        circleSize,
        this.circleColor =
        const CircleColor(start: Color(0xFFFF5722), end: Color(0xFFFFC107))})
      : bubblesSize = bubblesSize ?? size * 2.0,
        circleSize = circleSize ?? size * 0.8,
        super(key: key);

  @override
  _FireButtonState createState() => _FireButtonState();
}

class _FireButtonState extends State<FireButton> {
  late Animation<double> _outerCircleAnimation;
  late Animation<double> _innerCircleAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bubblesAnimation;

  @override
  void initState() {
    _initControlAnimation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller!,
      builder: (BuildContext c, Widget? w) {
        return Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Positioned(
              top: (widget.size - widget.bubblesSize) / 2.0,
              left: (widget.size - widget.bubblesSize) / 2.0,
              child: CustomPaint(
                size: Size(widget.bubblesSize, widget.bubblesSize),
                painter: BubblesPainter(
                  currentProgress: _bubblesAnimation.value,
                  color1: widget.bubblesColor.dotPrimaryColor,
                  color2: widget.bubblesColor.dotSecondaryColor,
                  color3: widget.bubblesColor.dotThirdColorReal,
                  color4: widget.bubblesColor.dotLastColorReal,
                ),
              ),
            ),
            Positioned(
              top: (widget.size - widget.circleSize) / 2.0,
              left: (widget.size - widget.circleSize) / 2.0,
              child: CustomPaint(
                size: Size(widget.circleSize, widget.circleSize),
                painter: CirclePainter(
                  innerCircleRadiusProgress: _innerCircleAnimation.value,
                  outerCircleRadiusProgress: _outerCircleAnimation.value,
                  circleColor: widget.circleColor,
                ),
              ),
            ),
            Container(
              width: widget.size,
              height: widget.size,
              alignment: Alignment.center,
              child: Transform.scale(
                scale: widget.controller!.isAnimating
                    ? _scaleAnimation.value
                    : 1.0,
                child: SizedBox(
                  height: widget.size,
                  width: widget.size,
                  child: widget.child,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _initControlAnimation() {
    _outerCircleAnimation = Tween<double>(
      begin: 0.1,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: widget.controller!,
        curve: const Interval(
          0.0,
          0.3,
          curve: Curves.ease,
        ),
      ),
    );
    _innerCircleAnimation = Tween<double>(
      begin: 0.2,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: widget.controller!,
        curve: const Interval(
          0.2,
          0.5,
          curve: Curves.ease,
        ),
      ),
    );
    _scaleAnimation = Tween<double>(
      begin: 0.2,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: widget.controller!,
        curve: const Interval(
          0.35,
          0.7,
          curve: OvershootCurve(),
        ),
      ),
    );
    _bubblesAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: widget.controller!,
        curve: const Interval(
          0.1,
          1.0,
          curve: Curves.decelerate,
        ),
      ),
    );
  }
}
