import 'package:flutter/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/cache/app_image_cache.dart';
import '../../../controllers/category_controller.dart';
import '../../../controllers/service_controller.dart';

class HomeBootService {
  final CategoryController cat;
  final ServiceController svc;

  HomeBootService({required this.cat, required this.svc});

  Future<void> warmUp(BuildContext context) async {
    // 1) Ensure categories are present
    if (!cat.isLoading && cat.categories.isEmpty) {
      await cat.loadCategories();
    }

    // 2) Choose a safe initial category id (never "all")
    String? _pickInitialCategoryId() {
      if (svc.currentServiceCategoryId.isNotEmpty) return svc.currentServiceCategoryId;
      if (cat.categories.isNotEmpty) return cat.categories.first.categoryId;
      return null; // no valid id yet
    }

    final initialCid = _pickInitialCategoryId();

    // 3) Load services only when a valid category id exists
    if (initialCid != null && initialCid.isNotEmpty) {
      if (!svc.isLoading && svc.services.isEmpty) {
        await svc.loadServices(initialCid);
      }
    }

    // 4) Precache above-the-fold images (skip svgs/invalid URLs)
    final List<ImageProvider> images = [];
    bool _validUrl(String? u) =>
        u != null && u.trim().isNotEmpty && u.startsWith('http') && !u.toLowerCase().endsWith('.svg');

    for (final c in cat.categories.take(8)) {
      final url = c.imgLink;
      if (_validUrl(url)) {
        images.add(CachedNetworkImageProvider(url, cacheManager: AppImageCache.manager));
      }
    }

    if (initialCid != null && initialCid.isNotEmpty && svc.services.isNotEmpty) {
      for (final s in svc.services.take(8)) {
        final url = s.imgLink; // your Service model exposes imgLink
        if (_validUrl(url)) {
          images.add(CachedNetworkImageProvider(url, cacheManager: AppImageCache.manager));
        }
      }
    }

    // 5) Resilient precache
    for (final img in images) {
      try {
        await precacheImage(img, context);
      } catch (_) {
        // Ignore bad bytes / 403 / unsupported formats
      }
    }
  }
}
