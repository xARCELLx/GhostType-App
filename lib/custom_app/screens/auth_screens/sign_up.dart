import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ghost_type/custom_app/screens/SplashScreen.dart';

class SignUpScreen extends StatefulWidget {
  final List<MorphingTextData>? initialTextItems;
  final List<bool>? initialTextStates;
  final List<double>? initialFloatOffsets;
  const SignUpScreen({
    super.key,
    this.initialTextItems,
    this.initialTextStates,
    this.initialFloatOffsets,
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with TickerProviderStateMixin {
  late AnimationController _formController;
  late Animation<double> _scaleAnimation;
  late AnimationController _glassController;
  late Animation<double> _blurAnimation;

  @override
  void initState() {
    super.initState();
    _formController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scaleAnimation = Tween(begin: 5.0, end: 1.0).animate(
      CurvedAnimation(parent: _formController, curve: Curves.easeOutBack),
    );

    _glassController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _blurAnimation = Tween<double>(begin: 0.0, end: 2.5).animate(
      CurvedAnimation(parent: _glassController, curve: Curves.easeOut),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _formController.forward();
        _glassController.forward();
      }
    });
  }

  @override
  void dispose() {
    _formController.dispose();
    _glassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          GhostTypeSplashScreen(
            enableNavigation: false,
            presetTextItems: widget.initialTextItems,
            initialTextStates: widget.initialTextStates,
            initialFloatOffsets: widget.initialFloatOffsets,
          ),
          AnimatedBuilder(
            animation: _blurAnimation,
            builder: (context, child) {
              return BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: _blurAnimation.value,
                  sigmaY: _blurAnimation.value,
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.2),
                ),
              );
            },
          ),
          Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: const Text('THIS IS SIGNUP FORM',style: TextStyle(color: Colors.white),),
            ),
          ),
        ],
      ),
    );
  }
}