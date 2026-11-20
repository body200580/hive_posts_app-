import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/post_model.dart';
import 'screens/posts_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PostAdapter());

  // Open boxes early
  await Hive.openBox<Post>('postsBox');
  await Hive.openBox<Post>('favoritesBox'); // used in the assignment

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Offline Posts & Favorites',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F172A),
          primary: const Color(0xFF0F172A),
          secondary: const Color(0xFF0D9488),
        ),
      ),
      home: const PostsScreen(),
    );
  }
}
