import 'package:flutter/material.dart';

class ReadMoreText extends StatelessWidget {
  final String text;
  final bool isExpanded;
  final VoidCallback onToggle;
  final int trimLines;
  final TextStyle? textStyle;

  const ReadMoreText({
    super.key,
    required this.text,
    required this.isExpanded,
    required this.onToggle,
    this.trimLines = 2,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = textStyle ??
        TextStyle(
          fontSize: 14,
          color: Colors.grey[700],
          height: 1.4,
          fontFamily: 'SF Pro',
        );

    return LayoutBuilder(
      builder: (context, constraints) {
        final span = TextSpan(text: text, style: effectiveStyle);

        final tp = TextPainter(
          text: span,
          maxLines: trimLines,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        final bool isOverflowing = tp.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              maxLines: isExpanded ? null : trimLines,
              overflow:
                  isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              style: effectiveStyle,
            ),

            if (isOverflowing)
              GestureDetector(
                onTap: onToggle,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    isExpanded ? 'Read less' : 'Read more',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE47830),
                      fontFamily: 'SF Pro',
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
