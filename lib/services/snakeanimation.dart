import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 1. The specific "Add" button widget
class AnimatedAddButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isLoading;
  final double scaleFactor;

  const AnimatedAddButton({
    super.key,
    required this.onTap,
    required this.isLoading,
    required this.scaleFactor,
  });

  @override
  State<AnimatedAddButton> createState() => _AnimatedAddButtonState();
}

class _AnimatedAddButtonState extends State<AnimatedAddButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    if (widget.isLoading) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(AnimatedAddButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading && !oldWidget.isLoading) {
      _controller.repeat();
    } else if (!widget.isLoading && oldWidget.isLoading) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: widget.isLoading
          ? _BorderSnakePainter(
              animation: _controller,
              color: const Color(0xFFE47830),
              scaleFactor: widget.scaleFactor)
          : null,
      child: Container(
        width: 75.w * widget.scaleFactor,
        height: 29.h * widget.scaleFactor,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8 * widget.scaleFactor),
          // Only show shadow when NOT loading (cleaner look)
          boxShadow: widget.isLoading
              ? []
              : [
                  BoxShadow(
                    color: const Color(0x33000000),
                    blurRadius: 4 * widget.scaleFactor,
                    offset: Offset(0, 1 * widget.scaleFactor),
                  ),
                ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8 * widget.scaleFactor),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.isLoading ? null : widget.onTap,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      size: 14 * widget.scaleFactor,
                      color: const Color(0xFFE47830),
                    ),
                    SizedBox(width: 4.w * widget.scaleFactor),
                    Text(
                      'Add',
                      style: TextStyle(
                        color: const Color(0xFFE47830),
                        fontSize: 14.sp * widget.scaleFactor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 2. The Generic Wrapper (Use this for the Counter)
class AnimatedBorderWrapper extends StatefulWidget {
  final Widget child;
  final bool isAnimating;
  final double scaleFactor;

  const AnimatedBorderWrapper({
    super.key,
    required this.child,
    required this.isAnimating,
    required this.scaleFactor,
  });

  @override
  State<AnimatedBorderWrapper> createState() => _AnimatedBorderWrapperState();
}

class _AnimatedBorderWrapperState extends State<AnimatedBorderWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    if (widget.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(AnimatedBorderWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating && !oldWidget.isAnimating) {
      _controller.repeat();
    } else if (!widget.isAnimating && oldWidget.isAnimating) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isAnimating) return widget.child;

    return CustomPaint(
      // Use foregroundPainter so the border draws ON TOP of the child (the counter)
      foregroundPainter: _BorderSnakePainter(
        animation: _controller,
        color: const Color(0xFFE47830),
        scaleFactor: widget.scaleFactor,
      ),
      child: widget.child,
    );
  }
}

/// 3. The Shared Painter Logic
class _BorderSnakePainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;
  final double scaleFactor;

  _BorderSnakePainter(
      {required this.animation, required this.color, required this.scaleFactor})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect =
        RRect.fromRectAndRadius(rect, Radius.circular(8 * scaleFactor));

    // 1. Draw faint background border
    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0 * scaleFactor
      ..color = Colors.grey.shade300;
    canvas.drawRRect(rrect, bgPaint);

    // 2. Draw animated "snake"
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0 * scaleFactor
      ..strokeCap = StrokeCap.round
      ..color = color;

    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics().first;

    // Length of the snake (35% of total perimeter)
    final extractLength = metrics.length * 0.35;

    // Calculate start position based on animation (0 to 1)
    final start = metrics.length * animation.value;

    // Extract the path segment
    if (start + extractLength > metrics.length) {
      final firstSegment = metrics.extractPath(start, metrics.length);
      final secondSegment =
          metrics.extractPath(0, start + extractLength - metrics.length);
      canvas.drawPath(firstSegment, paint);
      canvas.drawPath(secondSegment, paint);
    } else {
      final segment = metrics.extractPath(start, start + extractLength);
      canvas.drawPath(segment, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BorderSnakePainter oldDelegate) => true;
}