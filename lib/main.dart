import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ghost_type/custom_app/providers/auth_provider.dart';
import 'package:ghost_type/custom_app/screens/SplashScreen.dart';
import 'package:ghost_type/custom_app/screens/auth_screens/sign_up.dart';
import 'package:ghost_type/custom_app/screens/auth_screens/login_screen.dart';

void main() {
  runApp(
    // Wrap the app with ChangeNotifierProvider to provide AuthProvider
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const GhostTypeSplashScreen(enableNavigation: true),
      routes: {
        '/signup': (context) => const SignUpScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}