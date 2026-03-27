import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:math' as math;
import '../../utils/test_extensions.dart';

import '../controllers/search_controller.dart';
import '../models/search_model.dart';
import '../controllers/category_controller.dart'; 
import 'universal_service_screen.dart'; 

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchPageController());

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isTablet = constraints.maxWidth >= 600;
        final double scaleFactor = isTablet ? constraints.maxWidth / 411 : 1.0;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w * scaleFactor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h * scaleFactor),

                  // --- Search Bar ---
                  Container(
                    height: 42.h * scaleFactor,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1.w * scaleFactor, color: const Color(0x9BE47830)),
                        borderRadius: BorderRadius.circular(5.r * scaleFactor),
                      ),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20.sp * scaleFactor),
                          onPressed: () => Navigator.pop(context),
                        ).withId('search_back_btn'),
                        SizedBox(width: 4.w * scaleFactor),
                        Expanded(
                          child: TextField(
                            controller: controller.textController,
                            focusNode: controller.focusNode,
                            onChanged: controller.onSearchChanged,
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.72),
                              fontSize: 13.sp * scaleFactor,
                              fontFamily: 'SF Pro',
                              fontWeight: FontWeight.w400,
                            ),
                            cursorColor: Colors.black,
                            autofocus: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Look For Services',
                              hintStyle: TextStyle(
                                color: Colors.black.withOpacity(0.72),
                                fontSize: 13.sp * scaleFactor,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w400,
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ).withId('search_input_field'),
                        ),
                        Obx(() => controller.isSearchActive.value
                            ? IconButton(
                                icon: const Icon(Icons.close, color: Colors.grey),
                                onPressed: () {
                                  controller.textController.clear();
                                  controller.onSearchChanged('');
                                },
                              ).withId('search_clear_btn')
                            : const SizedBox.shrink()),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h * scaleFactor),

                  // --- Results Area ---
                  Expanded(
                    child: Obx(() {
                      // 1. Show Loader ONLY when actually fetching data
                      if (controller.isLoading.value) {
                        return Center(
                          child: ThreeDotLoader(
                            size: 16.sp * scaleFactor, 
                            color: const Color(0xFFE47830),
                          )
                        ).withId('search_loading_state');
                      }

                      // 2. Handle Search Active State
                      if (controller.isSearchActive.value) {
                          // A. Results found -> Show List
                          if (controller.searchResults.isNotEmpty) {
                            return ListView.separated(
                              itemCount: controller.searchResults.length,
                              separatorBuilder: (c, i) => SizedBox(height: 12.h),
                              itemBuilder: (context, index) {
                                final item = controller.searchResults[index];
                                return _buildSearchResultItem(context, item, scaleFactor).withId('search_result_$index');
                              },
                            );
                          } 
                          // B. No results AND API has finished -> Show Empty State
                          else if (controller.hasSearched.value) {
                            return _buildEmptyState(context, scaleFactor);
                          } 
                          // C. Waiting for debounce or loading -> Show Blank
                          else {
                            return const SizedBox.shrink();
                          }
                      }

                      // 3. Default View (Trending) - When search is NOT active
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Trending searches',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.sp * scaleFactor,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 20.h * scaleFactor),
                            Wrap(
                              alignment: WrapAlignment.start,
                              spacing: 12.w * scaleFactor,
                              runSpacing: 12.h * scaleFactor,
                              children: _buildSearchTags(scaleFactor, controller),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // --- Empty State ---
  Widget _buildEmptyState(BuildContext context, double scaleFactor) {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100.w * scaleFactor,
              height: 100.h * scaleFactor,
              decoration: BoxDecoration(
                color: const Color(0xFFE47830).withOpacity(0.08), 
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off_rounded, 
                size: 48.sp * scaleFactor,
                color: const Color(0xFFE47830),
              ),
            ),
            SizedBox(height: 24.h * scaleFactor),
            Text(
              'No Services Found',
              style: TextStyle(
                fontSize: 18.sp * scaleFactor,
                fontWeight: FontWeight.w600,
                fontFamily: 'SF Pro',
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8.h * scaleFactor),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w * scaleFactor),
              child: Text(
                'We couldn\'t find any services matching your search. Try checking the spelling or use different keywords.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp * scaleFactor,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'SF Pro',
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- REVISED PROFESSIONAL CARD ITEM ---
  Widget _buildSearchResultItem(BuildContext context, SearchResult item, double scaleFactor) {
    // We use a transparent container with decoration, but put Material inside
    // to enable the InkWell ripple effect (Professional Touch)
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent, // Color moves to Material
        boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        // ClipRRect is implicit in Material with borderRadius
        child: InkWell(
          borderRadius: BorderRadius.circular(8.r), // Limits ripple to corners
          onTap: () async {
            // --- UI FIX FOR KEYBOARD ---
            // 1. Instantly kill focus (closes keyboard)
            FocusScope.of(context).unfocus();
            
            // 2. Small delay to let keyboard animation start (Smoothness)
            await Future.delayed(const Duration(milliseconds: 100));

            try {
              final categoryController = Get.find<CategoryController>();
              
              final foundCategory = categoryController.categories.firstWhereOrNull(
                (cat) => cat.categoryId == item.categoryId
              );

              if (foundCategory != null) {
                Get.to(() => CategoryServiceScreen(
                  category: foundCategory,
                  highlightServiceId: item.id,
                ));
              } else {
                 print("Category info not found locally");
              }
            } catch (e) {
              print("Error navigating: $e");
            }
          },
          child: Container(
            // Use Container here for Border only, padding moves inside
            decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(8.r),
               border: Border.all(color: Colors.grey.shade200),
            ),
            padding: EdgeInsets.all(12.w * scaleFactor),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6.r),
                  child: CachedNetworkImage(
                    imageUrl: item.imgLink ?? "",
                    width: 80.w * scaleFactor,
                    height: 80.w * scaleFactor,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Container(
                      width: 80.w, height: 80.w, color: Colors.grey[200], child: const Icon(Icons.broken_image),
                    ),
                  ),
                ),
                SizedBox(width: 12.w * scaleFactor),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name ?? "Service",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16.sp * scaleFactor, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 4.h * scaleFactor),
                      Text(
                        item.description ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12.sp * scaleFactor, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 8.h * scaleFactor),
                      Text(
                        "₹${item.price?.toStringAsFixed(0) ?? '0'}", 
                        style: TextStyle(
                          fontSize: 14.sp * scaleFactor,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFE47830),
                          fontFamily: 'SF Pro',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSearchTags(double scaleFactor, SearchPageController controller) {
    final List<String> tags = ['Deep Tissue Massage', 'Manicure','Pedicure', 'Cleaning'];
    return tags.map((text) {
      final tagId = text.toLowerCase().replaceAll(' ', '_');
      return GestureDetector(
        onTap: () {
          // Optional: You might want to unfocus here too if you want keyboard to close on tag tap
          // FocusScope.of(Get.context!).unfocus(); 
          controller.textController.text = text;
          controller.onSearchChanged(text);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w * scaleFactor, vertical: 8.h * scaleFactor),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(5.r * scaleFactor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/icons/trend.svg', 
                width: 20.w * scaleFactor, 
              ),
              SizedBox(width: 6.w * scaleFactor), 
              Text(
                text, 
                style: TextStyle(
                  fontSize: 13.sp * scaleFactor,
                  color: Colors.black.withOpacity(0.72),
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w400,
                )
              ),
            ],
          ),
        ),
      ).withId('trending_tag_$tagId');
    }).toList();
  }
}

// --- Three Dot Loader Widget ---
class ThreeDotLoader extends StatefulWidget {
  final Color color;
  final double size;

  const ThreeDotLoader({
    super.key,
    this.color = const Color(0xFFE47830),
    this.size = 14.0,
  });

  @override
  _ThreeDotLoaderState createState() => _ThreeDotLoaderState();
}

class _ThreeDotLoaderState extends State<ThreeDotLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size * 4,
      height: widget.size,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final double start = index * 0.2;
              final double end = start + 0.4;
              double opacity = 0.3;
              double scale = 0.8;
              if (_controller.value >= start && _controller.value <= end) {
                final curveValue = (_controller.value - start) / (end - start);
                final peak = math.sin(curveValue * math.pi);
                opacity = 0.3 + (0.7 * peak);
                scale = 0.8 + (0.4 * peak);
              }
              return Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      color: widget.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}