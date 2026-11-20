import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:posts_app/models/post_model.dart';
import 'package:posts_app/screens/favorites_screen.dart';

void main() {
  group('Post Model Unit Tests', () {
    test('Post.fromJson parses JSON accurately', () {
      final sample = {
        'id': 42,
        'title': 'Test Hive Title',
        'body': 'Test Hive Body Content',
        'userId': 7,
      };

      final post = Post.fromJson(sample);

      expect(post.id, 42);
      expect(post.title, 'Test Hive Title');
      expect(post.body, 'Test Hive Body Content');
      expect(post.userId, 7);
    });

    test('Post.copy creates an independent instance with identical fields', () {
      final original = Post(
        id: 101,
        title: 'Original Post',
        body: 'Original Body',
        userId: 3,
      );

      final copy = original.copy();

      expect(copy.id, original.id);
      expect(copy.title, original.title);
      expect(copy.body, original.body);
      expect(copy.userId, original.userId);
      expect(identical(original, copy), isFalse,
          reason: 'Must be a distinct instance to prevent HiveObject multi-box error');
    });
  });
}
