import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class AppImageCache {
  static final CacheManager manager = CacheManager(
    Config(
      'ck_image_cache',
      stalePeriod: const Duration(days: 14),
      maxNrOfCacheObjects: 1000,
      repo: JsonCacheInfoRepository(databaseName: 'ck_img_cache'),
      fileService: HttpFileService(),
    ),
  );
}
