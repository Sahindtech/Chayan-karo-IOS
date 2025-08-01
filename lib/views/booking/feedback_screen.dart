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
        child: Column(
          children: [
            ChayanHeader(
              title: 'Feedback',
              onBackTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Color(0xFFE4E4E4)),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/cleanup.png', // Use the correct asset here
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Diamond Facial',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                            ),
                          ),
                          SizedBox(height: 4),
                          Text('• 2 hrs',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w400)),
                          Text('• Includes dummy info',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w400)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'How would you rate the experience\nand service ?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: 'Tell us on how we can improve',
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  filled: true,
                  fillColor: Color(0xFFF9F9F9),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFFFFC76B)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFFE47830)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
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
          MaterialPageRoute(builder: (_) => const FeedbackSubmittedScreen()),
        );// handle feedback submission
                      }
                    : null,
                child: const Text(
                  'Submit Feedback',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
