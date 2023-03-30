import 'dart:convert';
import 'package:injectable/injectable.dart';

import '../../../models/post.dart';
import '../../../modules/home/widgets/home_tabs.dart';
import '../keychain/shared_prefs.dart';
import '../keychain/shared_prefs_key.dart';

abstract class HomePostsLocalDataSource {
  List<Post>? getHomePosts(String type);
  Future<void> saveHomePosts(List<Post>? items, String type);
}

@LazySingleton(as: HomePostsLocalDataSource)
class HomePostsLocalDataSourceImpl implements HomePostsLocalDataSource {
  HomePostsLocalDataSourceImpl(this._sharedPrefs);

  final SharedPrefs _sharedPrefs;

  @override
  List<Post>? getHomePosts(String type) {
    final String key = type == HomePostType.latest.rawValue
        ? SharedPrefsKey.homeLatestPosts
        : type == HomePostType.popular.rawValue
            ? SharedPrefsKey.homePopularPosts
            : SharedPrefsKey.homeMyPosts;
    final String? data = _sharedPrefs.get(key);
    if (data == null) {
      return null;
    }
    return List<Post>.from(
      (jsonDecode(data) as List<dynamic>).map<Post>(
        (dynamic x) => Post.fromJson(x as Map<String, dynamic>),
      ),
    );
  }

  @override
  Future<void> saveHomePosts(List<Post>? items, String type) async {
    final String key = type == HomePostType.latest.rawValue
        ? SharedPrefsKey.homeLatestPosts
        : type == HomePostType.popular.rawValue
            ? SharedPrefsKey.homePopularPosts
            : SharedPrefsKey.homeMyPosts;
    if (items != null) {
      await _sharedPrefs.put(key, jsonEncode(items));
    }
  }
}
