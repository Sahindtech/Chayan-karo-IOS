// widgets/common_top_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';

class CommonTopBar extends StatelessWidget {
  final String title;
  final bool showShareIcon;
  final VoidCallback? onBack;
  final VoidCallback? onShare;

  const CommonTopBar({
    super.key,
    required this.title,
    this.showShareIcon = false,
    this.onBack,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.h,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: const Color(0xFFFFEEE0),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack ?? () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios_new, size: 20),
          ),
          const Spacer(),
          Text(
            title,
            style:  TextStyle(
              fontSize: 16.sp,
              fontFamily: 'SFProSemibold',
            ),
          ),
          const Spacer(),
          if (showShareIcon)
            GestureDetector(
              onTap: onShare ?? () {
                Share.share("Check out these popular services!");
              },
              child: const Icon(Icons.share, size: 20),
            )
          else
            SizedBox(width: 20.w),
        ],
      ),
    );
  }
}