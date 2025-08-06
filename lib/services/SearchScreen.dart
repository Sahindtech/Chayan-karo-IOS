import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 16),

              // Full-width Search Bar with back icon
              Container(
                height: 42,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      width: 1,
                      color: Color(0x9BE47830),
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Look For Services',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.72),
                        fontSize: 13,
                        fontFamily: 'SF Pro',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              // Trending Searches Title
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Trending searches',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Trending Tags
              Wrap(
                alignment: WrapAlignment.start, // 👈 ensures tags align from left
                spacing: 12,
                runSpacing: 12,
                children: _buildSearchTags(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSearchTags() {
    final List<String> tags = [
      'Professional Cleaning',
      'Electricians',
      'Cleaning',
      'Professional Cleaning',
      'Professional Cleaning',
    ];

    return tags.map((text) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/icons/trend.svg',
              width: 20,
              height: 20,
            ),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                color: Colors.black.withOpacity(0.72),
                fontSize: 13,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
