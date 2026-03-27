import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../widgets/service_bottom_sheet.dart';

class HomeServiceSection extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> data;

  const HomeServiceSection({
    super.key,
    required this.title,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isTablet = constraints.maxWidth >= 600;

        double scaleFactor = isTablet
            ? constraints.maxWidth / 411
            : 1.0;

        double cardWidth = 170.w * scaleFactor;
        double cardHeight = 220.h * scaleFactor;
        double titleFontSize = 15.sp * scaleFactor;
        double itemTitleFont = 12.sp * scaleFactor;
        double itemSubtitleFont = 10.sp * scaleFactor;
        double paddingScale = scaleFactor;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16 * paddingScale),
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: titleFontSize,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  height: 1.33,
                ),
              ),
            ),
            SizedBox(height: 12.h * paddingScale),
            SizedBox(
              height: cardHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(left: 12 * paddingScale),
                itemCount: data.length,
                separatorBuilder: (_, __) => SizedBox(width: 8.w * paddingScale),
                itemBuilder: (context, index) {
                  final item = data[index];
                  return GestureDetector(
                    onTap: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => ServiceBottomSheet(
                        title: item['title'],
                        subtitle: item['subtitle'] ?? '',
                        images: List<String>.from(item['images']),
                      ),
                    ),
                    child: Container(
                      width: cardWidth,
                      padding: EdgeInsets.all(8 * paddingScale),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12 * paddingScale),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x11000000),
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: (cardHeight - 60 * paddingScale),
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 4,
                              padding: EdgeInsets.zero,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 4,
                                mainAxisSpacing: 4,
                                childAspectRatio: 1,
                              ),
                              itemBuilder: (_, i) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(8 * paddingScale),
                                  child: Image.asset(
                                    item['images'][i],
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[200],
                                        child: Icon(
                                          Icons.image_not_supported,
                                          size: 30 * paddingScale,
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 6.h * paddingScale),
                          Text(
                            item['title'],
                            style: TextStyle(
                              fontSize: itemTitleFont,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h * paddingScale),
                          Text(
                            item['subtitle'] ?? '',
                            style: TextStyle(
                              fontSize: itemSubtitleFont,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
