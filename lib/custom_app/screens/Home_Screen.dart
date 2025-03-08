import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ghost_type/custom_app/providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late bool isLoggedIn;
  String? username;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    username = authProvider.username;
  }

  void logout(){
    Provider.of<AuthProvider>(context, listen: false).logout();
    Navigator.pushReplacementNamed(context,'/signup');
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context); // Only one provider call

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Align content properly
          children: [
            Text(
              "Hey ${authProvider.username ?? "Guest"}", // Null safety fix
              style: const TextStyle(fontFamily: 'xeno', fontSize: 40),
            ),
            const SizedBox(height: 20), // Adds spacing between texts
            const Text(
              "THIS IS HOMESCREEN",
              style: TextStyle(fontFamily: 'xeno', fontSize: 40),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: logout, child: Text("LOG OUT")),

          ],
        ),
      ),
    );
  }
}
