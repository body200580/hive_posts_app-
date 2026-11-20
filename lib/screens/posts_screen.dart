import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/post_model.dart';
import '../services/favorites_service.dart';
import '../services/post_service.dart';
import 'favorites_screen.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final PostService _service = PostService();
  final FavoritesService _favoritesService = FavoritesService();
  late Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = _service.getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          // AppBar action button that navigates to the Favorites screen (Requirement 4)
          IconButton(
            icon: const Icon(Icons.favorite),
            tooltip: 'View Favorites',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error: ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          } else if (snapshot.hasData) {
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _postsFuture = _service.getPosts();
                });
                await _postsFuture;
              },
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final Post post = snapshot.data![index];
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
                      // ValueListenableBuilder listens to favoritesBox for instant reactive updates (Requirement 2)
                      trailing: ValueListenableBuilder<Box<Post>>(
                        valueListenable:
                            Hive.box<Post>('favoritesBox').listenable(),
                        builder: (context, box, _) {
                          final bool isFav = box.containsKey(post.id);
                          return IconButton(
                            icon: Icon(
                              isFav ? Icons.star : Icons.star_border,
                              color: isFav ? Colors.amber : null,
                            ),
                            tooltip: isFav
                                ? 'Remove from Favorites'
                                : 'Add to Favorites',
                            onPressed: () {
                              _favoritesService.toggleFavorite(post);
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
