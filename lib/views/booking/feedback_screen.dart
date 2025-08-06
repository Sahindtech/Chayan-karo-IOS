import 'package:flutter/material.dart';
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
              const SizedBox(height: 16),

              // Service Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 132,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFF3F3F3), width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(
                          'assets/cleanup.webp',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Diamond Facial',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Inter',
                              color: Color(0xFF161616),
                            ),
                          ),
                          const SizedBox(height: 8),
                          _dotWithText('2 hrs'),
                          const SizedBox(height: 4),
                          _dotWithText('Includes dummy info'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Question
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'How would you rate the experience\n          and service ?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                    color: Color(0xFF161616),
                  ),
                ),
              ),

              const SizedBox(height: 16),

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
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF161616),
                    fontFamily: 'Inter',
                  ),
                ),

              const SizedBox(height: 24),

              // Comment Box
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: 'Tell us on how we can improve',
                    hintStyle: const TextStyle(
                      fontSize: 14,
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

              const SizedBox(height: 24),

              // Add Photos Title
              const Padding(
                padding: EdgeInsets.only(left: 25, bottom: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Add Photos',
                    style: TextStyle(
                      fontSize: 20,
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
  padding: const EdgeInsets.only(left: 25),
  child: Row(
    children: List.generate(3, (index) {
      return Container(
        margin: const EdgeInsets.only(right: 10),
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: index == 0 ? const Color(0xFFD9D9D9) : Colors.white,
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
              fontSize: 36,
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

              const SizedBox(height: 32),

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
                  child: const Text(
                    'Submit Feedback',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: 'SF Pro Display',
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.32,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
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
          width: 4,
          height: 4,
          decoration: const BoxDecoration(
            color: Color(0xFF757575),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
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
