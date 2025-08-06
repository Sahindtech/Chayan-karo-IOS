import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class HorizontalServiceScroll extends StatelessWidget {
  final List<Map<String, String>> services;

  const HorizontalServiceScroll({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(right: 16),
        itemCount: services.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final service = services[index];

          return Padding(
            padding: EdgeInsets.only(left: index == 0 ? 0 : 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image with fixed 117x116 dimensions
                Container(
                  width: 117,
                  height: 116,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage(service['image']!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 117,
                  child: Text(
                    service['title']!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                      color: Colors.black,
                      height: 1.33,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/star.svg',
                      height: 14,
                      width: 14,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "4.8 (23k)",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF757575),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: const [
                    Text(
                      "₹499",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFFA9441),
                      ),
                    ),
                    SizedBox(width: 6),
                    Text(
                      "₹599",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.lineThrough,
                        color: Color(0xFFB0B0B0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}