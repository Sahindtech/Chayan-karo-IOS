import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/chayan_header.dart';
import 'feedback_submitted_screen.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  int selectedRating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ChayanHeader(
                title: 'Feedback',
                onBackTap: () => Navigator.pop(context),
              ),
              SizedBox(height: 16.h),

              // Service Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 132.h,
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFF3F3F3), width: 2.w),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(
                          'assets/cleanup.webp',
                          width: 100.w,
                          height: 100.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Diamond Facial',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Inter',
                              color: Color(0xFF161616),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          _dotWithText('2 hrs'),
                          SizedBox(height: 4.h),
                          _dotWithText('Includes dummy info'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              // Question
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'How would you rate the experience\n          and service ?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                    color: Color(0xFF161616),
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // Star Ratings
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      Icons.star,
                      color: selectedRating > index
                          ? Color(0xFFE47830)
                          : Color(0xFFCCCCCC),
                      size: 32,
                    ),
                    onPressed: () {
                      setState(() {
                        selectedRating = index + 1;
                      });
                    },
                  );
                }),
              ),

              if (selectedRating > 0)
                Text(
                  '$selectedRating - ${_getRatingLabel(selectedRating)}',
                  style: TextStyle(fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF161616),
                    fontFamily: 'Inter',
                  ),
                ),

              SizedBox(height: 24.h),

              // Comment Box
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: 'Tell us on how we can improve',
                    hintStyle: TextStyle(fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                    filled: true,
                    fillColor: Color(0xFFF9F9F9),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFFFC76B)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE47830)),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              // Add Photos Title
              Padding(padding: EdgeInsets.only(left: 25.r, bottom: 8.r),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Add Photos',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SF Pro',
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              // Add Photo Blocks
             // Add Photo Blocks
Padding(
  padding: EdgeInsets.only(left: 25.r),
  child: Row(
    children: List.generate(3, (index) {
      return Container(
        margin: EdgeInsets.only(right: 10.r),
        width: 80.w,
        height: 80.h,
        decoration: BoxDecoration(
          color: index == 0 ? Color(0xFFD9D9D9) : Colors.white,
          border: Border.all(
            color: index == 0
                ? Colors.transparent
                : Colors.black.withOpacity(0.6),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            '+',
            style: TextStyle(
              fontSize: 36.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black.withOpacity(0.7),
              shadows: index == 0
                  ? [
                      const Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 4,
                        color: Color(0xFFE47830),
                      ),
                    ]
                  : [],
            ),
          ),
        ),
      );
    }),
  ),
),

              SizedBox(height: 32.h),

              // Submit Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedRating > 0
                        ? const Color(0xFFE47830)
                        : const Color(0xFFD9D9D9),
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: selectedRating > 0
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const FeedbackSubmittedScreen()),
                          );
                        }
                      : null,
                  child: Text('Submit Feedback',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.32,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dotWithText(String text) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 4.h,
          decoration: const BoxDecoration(
            color: Color(0xFF757575),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          text,
          style: TextStyle(fontSize: 14.sp,
            color: Color(0xFF757575),
            fontWeight: FontWeight.w400,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  String _getRatingLabel(int rating) {
    switch (rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Okay';
      case 4:
        return 'Good';
      case 5:
        return 'Excellent';
      default:
        return '';
    }
  }
}