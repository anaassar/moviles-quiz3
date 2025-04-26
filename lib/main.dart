import 'package:flutter/material.dart';
import 'package:flutter_fingerprint2/views/login_view.dart';
import 'package:flutter_fingerprint2/views/menu_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
      home: const LoginView(),
      routes: {
        '/login': (_) => const LoginView(),
        '/profile': (_) => const ProfileView(),
      },
    );
  }
}
