import 'package:flutter/material.dart';
import 'ui/keyboard_layout.dart';

void main() {
  runApp(const KeyboardMain());
}

class KeyboardMain extends StatelessWidget {
  const KeyboardMain({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: KeyboardLayout(),
        ),
      ),
    );
  }
}