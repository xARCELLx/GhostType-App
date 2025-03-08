import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ghost_type/custom_app/providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            children: [
              Text("THIS IS HOMESCREEN",style: TextStyle(fontFamily: 'xeno',fontSize: 40),),
              Text("THIS IS HOMESCREEN",style: TextStyle(fontFamily: 'xeno',fontSize: 40),),
            ]
        ),
      ),
    );
  }
}
