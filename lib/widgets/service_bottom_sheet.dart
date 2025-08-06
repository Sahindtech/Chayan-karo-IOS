import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class ServiceBottomSheet extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<String> images;

  const ServiceBottomSheet({
    super.key,
    required this.title,
    required this.subtitle,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 561, // Matches Figma bottom sheet height
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0xE5E47830), // Figma orange stroke
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'SFProSemibold',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontFamily: 'SFProRegular',
              ),
            ),
            const SizedBox(height: 12),

            // One service per row - scrollable
            Expanded(
              child: ListView.separated(
                itemCount: images.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          images[index],
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Grooming essentials',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'SFProSemibold',
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/star.svg',
                                  width: 14,
                                  height: 14,
                                  color: Colors.black, 
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  '4.87 (23k)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'SFProRegular',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              '3 items',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: const [
                                Text(
                                  '₹499',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFFFA9441),
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'SFProBold',
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  '₹599',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Add Button
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFFA9441)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                          ),
                          onPressed: () {
                            // Add to cart or perform action
                          },
                          child: const Text(
                            'Add',
                            style: TextStyle(
                              color: Color(0xFFFA9441),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
