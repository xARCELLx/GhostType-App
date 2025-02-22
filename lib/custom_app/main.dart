import 'package:flutter/material.dart';
import 'package:ghost_type/custom_app/screens/SplashScreen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:GhostTypeSplashScreen(enableNavigation: true,),
    );
  }
}




