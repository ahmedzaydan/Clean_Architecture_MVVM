import 'package:mvvm_template/app/constants.dart';
import 'package:mvvm_template/app/extensions.dart';
import 'package:mvvm_template/data/network/error_handler.dart';
import 'package:mvvm_template/data/response/responses.dart';

abstract class LocalDataSource {
  void clearCache();
  void clearCacheByKey(String key);

  HomeResponse getHomeData();
  Future<void> cacheHomeData(HomeResponse homeResponse);

  StoreDetailsResponse getStoreDetails();
  Future<void> cacheStoreDetails(StoreDetailsResponse storeDetailsResponse);
}

class LocalDataSourceImpl implements LocalDataSource {
  // Run time cache
  Map<String, CachedItem> cacheMap = {};

  @override
  void clearCache() {
    cacheMap.clear();
  }

  @override
  void clearCacheByKey(String key) {
    cacheMap.remove(key);
  }

  @override
  HomeResponse getHomeData() {
    CachedItem? cachedItem = cacheMap[Constants.cacheHomeDataKey];
    if (cachedItem != null &&
        cachedItem.isValid(
          expTimeInMilliSeconds: Constants.cacheHomeDataInterval,
        )) {
      return cachedItem.data;
    } else {
      throw ErrorHandler.handle(DataSource.cacheError);
    }
  }

  @override
  Future<void> cacheHomeData(HomeResponse homeResponse) async {
    cacheMap[Constants.cacheHomeDataKey] = CachedItem(homeResponse);
  }

  @override
  StoreDetailsResponse getStoreDetails() {
    CachedItem? cachedItem = cacheMap[Constants.storeDetailsDataKey];
    if (cachedItem != null &&
        cachedItem.isValid(
            expTimeInMilliSeconds: Constants.storeDetailsInterval)) {
      return cachedItem.data;
    } else {
      throw ErrorHandler.handle(DataSource.cacheError);
    }
  }

  @override
  Future<void> cacheStoreDetails(
      StoreDetailsResponse storeDetailsResponse) async {
    cacheMap[Constants.storeDetailsDataKey] = CachedItem(storeDetailsResponse);
  }
}

class CachedItem {
  dynamic data;
  // - what this means
  int cacheTime = DateTime.now().millisecondsSinceEpoch;

  CachedItem(this.data);
}
