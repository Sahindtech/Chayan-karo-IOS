import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../utils/test_extensions.dart';

// Models and controllers
import '../../../models/service_models.dart';      // Service, CartItem
import '../../../controllers/cart_controller.dart';

class FrequentlyAddedBlock extends StatelessWidget {
  final double scale;
  final String categoryId;
  final String categoryName;              // NEW: to show as title
  final List<Service> services;
  final void Function(String serviceId)? onAdded; // NEW: notify parent

  const FrequentlyAddedBlock({
    super.key,
    required this.scale,
    required this.categoryId,
    required this.categoryName,
    required this.services,
    this.onAdded,
  });

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    // Not reactive on services list; built once for Summary
    final allServices = services;
    debugPrint(
      '🧺 FrequentlyAddedBlock: categoryId="$categoryId", incoming services=${allServices.length}',
    );

    // Only services not already in cart
    final suggestions = allServices.where((service) {
      final isNotInCart = cartController.getQuantity(service.id) == 0;
      debugPrint('🧺 filter svc=${service.id} isNotInCart=$isNotInCart');
      return isNotInCart;
    }).toList();

    if (suggestions.isEmpty || categoryId.isEmpty) {
      debugPrint('🧺 FrequentlyAddedBlock: no suggestions, hiding block');
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          // show this category name instead of static label
          categoryName.isNotEmpty ? categoryName : 'Related services',
          style: TextStyle(
            fontSize: 16.sp * scale,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 12.h * scale),
        SizedBox(
          height: 250.h * scale,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              return _buildAddCard(
                suggestions[index],
                cartController,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAddCard(Service service, CartController cartController) {
    return Container(
      width: 140.w * scale,
      margin: EdgeInsets.only(right: 16.r * scale),
      padding: EdgeInsets.all(8.r * scale),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(25 * scale),
      ),
      child: Column(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(14 * scale),
            child: Image.network(
              service.imgLink,
              width: 120.w * scale,
              height: 120.h * scale,
              fit: BoxFit.cover,
              errorBuilder: (ctx, _, __) => Container(
                width: 120.w * scale,
                height: 120.h * scale,
                color: Colors.grey[300],
                child: Icon(
                  Icons.broken_image,
                  size: 40 * scale,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h * scale),

          // Name
          Text(
            service.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.sp * scale,
            ),
          ),
          SizedBox(height: 4.h * scale),

          // Price
          Text(
            '₹${service.discountedPrice.toInt()}',
            style: TextStyle(fontSize: 14.sp * scale),
          ),
          SizedBox(height: 8.h * scale),

          // Add Button
          InkWell(
            onTap: () {
              final catId =
                  categoryId.isNotEmpty ? categoryId : service.categoryId;

             final item = CartItem.fromService(
  service,
  sourcePage: 'summary_frequently_added_$catId',
  sourceTitle: categoryName,       // use Female Spa, etc.
).copyWith(
  categoryId: catId,
);


              debugPrint(
                '🧺 FrequentlyAddedBlock: adding svc=${service.id}, catId=$catId',
              );

              // 1) add to cart so totals & booking use it
              cartController.addItem(item);

              // 2) notify SummaryScreen so it can add this id into
              //    currentPageSelectedServices => SelectedServicesBlock updates immediately
              if (onAdded != null) {
                onAdded!(service.id);
              }
            },
            child: Container(
              width: 120.w * scale,
              height: 30.h * scale,
              decoration: BoxDecoration(
                color: const Color(0xFFE47830),
                borderRadius: BorderRadius.circular(30 * scale),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                'Add',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp * scale,
                ),
              ),
            ),
          ).withId('frequently_added_add_btn_${service.id}'),
        ],
      ),
    );
  }
}
