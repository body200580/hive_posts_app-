import 'package:hive/hive.dart';
import '../models/post_model.dart';

class FavoritesService {
  static const String boxName = 'favoritesBox';

  Box<Post> get _box => Hive.box<Post>(boxName);

  /// Toggles favorite status for a given [post].
  /// If already in favorites, it is deleted from the box.
  /// Otherwise, a new cloned copy is saved under key `post.id`.
  Future<void> toggleFavorite(Post post) async {
    if (isFavorite(post.id)) {
      await _box.delete(post.id);
    } else {
      // Create a fresh Post copy to prevent HiveObject multi-box runtime error
      final copy = Post(
        id: post.id,
        title: post.title,
        body: post.body,
        userId: post.userId,
      );
      await _box.put(post.id, copy);
    }
  }

  /// Checks whether the post with [id] is marked as a favorite.
  bool isFavorite(int id) {
    return _box.containsKey(id);
  }

  /// Retrieves all favorite posts saved in Hive.
  List<Post> getFavorites() {
    return _box.values.toList();
  }
}
