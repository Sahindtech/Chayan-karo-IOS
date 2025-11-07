import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HorizontalServiceScroll extends StatelessWidget {
  const HorizontalServiceScroll({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Sample static service list
    final List<Map<String, dynamic>> services = [
      {
        "title": "Hair Keratin Treatment",
        "image": "assets/x1.jpg",
        "rating": "4.8 (2.3k)",
        "price": 499,
        "oldPrice": 599,
      },
      {
        "title": "Hair Trimming",
        "image": "assets/x2.jpg",
        "rating": "4.7 (1.8k)",
        "price": 699,
        "oldPrice": 899,
      },
      {
        "title": "Full Body Bleach-Oxylife",
        "image": "assets/x3.jpg",
        "rating": "4.6 (1.2k)",
        "price": 399,
        "oldPrice": 499,
      },
      {
        "title": "Chest Bleach-O3+",
        "image": "assets/x4.jpg",
        "rating": "4.9 (3.1k)",
        "price": 299,
        "oldPrice": 399,
      },
      {
        "title": "Deep Tissue Massage-Back",
        "image": "assets/x5.jpg",
        "rating": "4.5 (900)",
        "price": 549,
        "oldPrice": 699,
      },
      {
        "title": "Swedish Massage-Full Body",
        "image": "assets/x6.jpg",
        "rating": "4.4 (750)",
        "price": 799,
        "oldPrice": 999,
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isTablet = constraints.maxWidth >= 600;
        double scaleFactor = isTablet ? constraints.maxWidth / 411 : 1.0;

        double imageWidth = 117.w * scaleFactor;
        double imageHeight = 116.h * scaleFactor;
        double titleFontSize = 12.sp * scaleFactor;
        double priceFontSize = 12.sp * scaleFactor;
        double oldPriceFontSize = 10.sp * scaleFactor;
        double ratingFontSize = 10.sp * scaleFactor;
        double starSize = 14.h * scaleFactor;

        double contentHeight = imageHeight +
            8.h * scaleFactor +
            (titleFontSize * 1.33 * 2) +
            4.h * scaleFactor +
            (ratingFontSize * 1.2) +
            4.h * scaleFactor +
            (priceFontSize * 1.2) +
            5.h * scaleFactor;

        return SizedBox(
          height: contentHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            itemCount: services.length,
            separatorBuilder: (_, __) => SizedBox(width: 12.w * scaleFactor),
            itemBuilder: (context, index) {
              final service = services[index];

              return SizedBox(
                width: imageWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🖼️ Service Image
                    Container(
                      width: imageWidth,
                      height: imageHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10 * scaleFactor),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10 * scaleFactor),
                        child: Image.asset(
                          service["image"],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: Icon(
                                Icons.cleaning_services,
                                color: const Color(0xFFFF6F00),
                                size: 32.sp * scaleFactor,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h * scaleFactor),

                    // 🏷️ Service Title
                    SizedBox(
                      width: imageWidth,
                      child: Text(
                        service["title"],
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                          color: Colors.black,
                          height: 1.33,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 4.h * scaleFactor),

                    // ⭐ Rating Row
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/star.svg',
                          height: starSize,
                          width: starSize,
                          colorFilter: const ColorFilter.mode(
                            Colors.amber,
                            BlendMode.srcIn,
                          ),
                          placeholderBuilder: (_) => Icon(
                            Icons.star,
                            size: starSize,
                            color: Colors.amber,
                          ),
                        ),
                        SizedBox(width: 4.w * scaleFactor),
                        Expanded(
                          child: Text(
                            service["rating"],
                            style: TextStyle(
                              fontSize: ratingFontSize,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF757575),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h * scaleFactor),

                    // 💰 Price Row
                    Row(
                      children: [
                        Text(
                          "₹${service["price"]}",
                          style: TextStyle(
                            fontSize: priceFontSize,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFFA9441),
                          ),
                        ),
                        SizedBox(width: 6.w * scaleFactor),
                        Text(
                          "₹${service["oldPrice"]}",
                          style: TextStyle(
                            fontSize: oldPriceFontSize,
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.lineThrough,
                            color: const Color(0xFFB0B0B0),
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
      },
    );
  }
}
