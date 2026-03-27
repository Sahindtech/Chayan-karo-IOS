import 'package:flutter/material.dart';
import 'dart:math' as math;

class ThreeDotLoader extends StatefulWidget {
  final Color color;
  final double size;

  const ThreeDotLoader({
    super.key,
    this.color = const Color(0xFFE47830), // Orange color
    this.size = 14.0,
  });

  @override
  _ThreeDotLoaderState createState() => _ThreeDotLoaderState();
}

class _ThreeDotLoaderState extends State<ThreeDotLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size * 4,
      height: widget.size,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              // Staggered Wave Effect
              final double start = index * 0.2;
              final double end = start + 0.4;

              double opacity = 0.3;
              double scale = 0.8;

              // Calculate value based on controller
              if (_controller.value >= start && _controller.value <= end) {
                final curveValue = (_controller.value - start) / (end - start);
                final peak = math.sin(curveValue * math.pi);
                opacity = 0.3 + (0.7 * peak);
                scale = 0.8 + (0.4 * peak);
              }

              return Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      color: widget.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}