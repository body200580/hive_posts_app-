import 'package:hive/hive.dart';

part 'post_model.g.dart';

@HiveType(typeId: 0)
class Post extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String body;

  @HiveField(3)
  int userId;

  Post({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      userId: json['userId'] as int,
    );
  }

  /// Creates a distinct, detached copy of this [Post].
  /// Required when saving into `favoritesBox` because a [HiveObject]
  /// cannot be registered in more than one box at the same time.
  Post copy() {
    return Post(
      id: id,
      title: title,
      body: body,
      userId: userId,
    );
  }
}
