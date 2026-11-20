import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/post_model.dart';
import '../services/favorites_service.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoritesService favoritesService = FavoritesService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Posts'),
      ),
      // Automatically listens to favoritesBox changes for real-time reactivity
      body: ValueListenableBuilder<Box<Post>>(
        valueListenable: Hive.box<Post>('favoritesBox').listenable(),
        builder: (context, box, _) {
          final List<Post> favorites = box.values.toList();

          // Friendly empty state message (Requirement 5)
          if (favorites.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star_border_rounded,
                    size: 72,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap the star icon on any post to save it here for offline reading.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          // List of favorites using the same card layout as the posts list (Requirement 3)
          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final Post post = favorites[index];
              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(post.id.toString()),
                  ),
                  title: Text(
                    post.title,
                    maxLines: 1,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    post.body,
                    maxLines: 2,
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    tooltip: 'Remove from Favorites',
                    onPressed: () {
                      favoritesService.toggleFavorite(post);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
