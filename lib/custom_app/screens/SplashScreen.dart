import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ghost_type/custom_app/screens/Home_Screen.dart';
import 'package:ghost_type/custom_app/screens/auth_screens/sign_up.dart';
import 'package:ghost_type/custom_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class GhostTypeSplashScreen extends StatefulWidget {
  final bool enableNavigation;
  final List<MorphingTextData>? presetTextItems;
  final List<bool>? initialTextStates;
  final List<double>? initialFloatOffsets;
  const GhostTypeSplashScreen({
    Key? key,
    this.enableNavigation = false,
    this.presetTextItems,
    this.initialTextStates,
    this.initialFloatOffsets,
  }) : super(key: key);

  @override
  State<GhostTypeSplashScreen> createState() => _GhostTypeSplashScreenState();
}

class _GhostTypeSplashScreenState extends State<GhostTypeSplashScreen> with TickerProviderStateMixin {
  late List<MorphingTextData> textItems;
  static const double containerWidth = 350;
  static const int totalTexts = 20;
  static const double minDistanceFraction = 0.12;
  final List<GlobalKey<MorphingTextWidgetState>> _textWidgetKeys = [];
  late AnimationController _spaceController;
  late Animation<double> _nebulaAnimation;

  @override
  void initState() {
    super.initState();
    textItems = widget.presetTextItems ?? [];
    if (textItems.isEmpty) {
      _generateTexts();
    }
    for (int i = 0; i < textItems.length; i++) {
      _textWidgetKeys.add(GlobalKey<MorphingTextWidgetState>());
    }

    _spaceController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20), // Slow cosmic drift
    )..repeat(reverse: true);
    _nebulaAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _spaceController, curve: Curves.easeInOut),
    );

    if (widget.enableNavigation) {
      Timer(const Duration(seconds: 5), () {
        if (mounted) {
          List<bool> currentStates = _textWidgetKeys
              .map((key) => key.currentState?.showCorrect ?? false)
              .toList();
          List<double> currentOffsets = _textWidgetKeys
              .map((key) => key.currentState?.currentOffset ?? 0.0)
              .toList();
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                if(Provider.of<AuthProvider>(context, listen: false).isLoggedIn) {
                  return HomeScreen();
                }
                return SignUpScreen(
                  initialTextItems: textItems,
                  initialTextStates: currentStates,
                  initialFloatOffsets: currentOffsets,
                );
            },
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
              transitionDuration: const Duration(milliseconds: 800),
            ),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _spaceController.dispose();
    super.dispose();
  }

  final List<List<String>> pairs = [
    ["HELLO", "こんにちは"],
    ["GOODBYE", "さようなら"],
    ["THANK YOU", "धन्यवाद"],
    ["PLEASE", "कृपया"],
    ["I LOVE YOU", "我爱你"],
    ["WHAT IS YOUR NAME", "你叫什么名字"],
    ["WELCOME", "Добро пожаловать"],
    ["GOOD NIGHT", "Спокойной ночи"],
    ["HOW ARE YOU", "안녕하세요?"],
    ["SEE YOU LATER", "나중에 봐요"],
    ["GOOD MORNING", "MORNIN'"],
    ["THANK YOU", "THANKS A LOT"],
    ["SEE YOU LATER", "BYE-BYE"],
    ["PLEASE WAIT", "HOLD ON A SEC"],
    ["I DON'T KNOW", "I AM NOT SURE"],
    ["THAT'S GREAT", "FANTASTIC!"],
    ["I'M BUSY", "I'M SWAMPED"],
    ["SORRY", "MY APOLOGIES"],
    ["EXCUSE ME", "PARDON ME"],
    ["GOOD NIGHT", "SLEEP TIGHT"],
  ];

  void _generateTexts() {
    final random = Random();
    pairs.shuffle(random);
    for (int i = 0; i < totalTexts; i++) {
      Offset pos;
      bool valid;
      int attempts = 0;
      do {
        attempts++;
        double dx = 0.1 + random.nextDouble() * 0.8;
        double dy = 0.1 + random.nextDouble() * 0.8;
        pos = Offset(dx, dy);
        valid = true;
        for (final item in textItems) {
          double dist = (Offset(item.dx, item.dy) - pos).distance;
          if (dist < minDistanceFraction) {
            valid = false;
            break;
          }
        }
      } while (!valid && attempts < 100);

      final pair = pairs[i];
      double fontSize = 12 + random.nextDouble() * 20;
      textItems.add(
        MorphingTextData(
          wrongText: pair[0],
          correctText: pair[1],
          dx: pos.dx,
          dy: pos.dy,
          morphDelay: Duration(milliseconds: 1000 + random.nextInt(1000)),
          floatAmplitude: 3.0 + random.nextDouble() * 3.0,
          floatPeriod: Duration(milliseconds: 3000 + random.nextInt(2000)),
          fontSize: fontSize,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _spaceController,
        builder: (context, child) {
          return Container(
            color: const Color(0xFF020203), // Pitch-black void
            child: Stack(
              children: [
                // Cosmic background with nebula, galaxies, and stars
                CustomPaint(
                  painter: CosmicBackgroundPainter(_nebulaAnimation.value),
                  size: Size.infinite,
                ),
                // Morphing text items
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: List.generate(textItems.length, (index) {
                        final data = textItems[index];
                        double idealLeft = (constraints.maxWidth * data.dx) - (containerWidth / 2);
                        double left = idealLeft;
                        double top = constraints.maxHeight * data.dy;
                        return Positioned(
                          left: left,
                          top: top,
                          child: MorphingTextWidget(
                            key: _textWidgetKeys[index],
                            data: data,
                            containerWidth: containerWidth,
                            initialShowCorrect: widget.initialTextStates?.elementAt(index),
                            initialFloatOffset: widget.initialFloatOffsets?.elementAt(index),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CosmicBackgroundPainter extends CustomPainter {
  final double animationValue;

  CosmicBackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(42); // Fixed seed for consistency
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw dense, twinkling stars
    for (int i = 0; i < 300; i++) {
      double x = random.nextDouble() * size.width;
      double y = random.nextDouble() * size.height;
      double radius = random.nextDouble() * 2.5;
      double opacity = 0.2 + random.nextDouble() * 0.7;
      double brightness = 0.8 + 0.2 * sin(animationValue * 2 * pi + i * 0.1); // Subtle pulsing
      paint.color = Colors.white.withOpacity(opacity * brightness);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // Draw bright, flaring stars (like the blue ones in the image)
    for (int i = 0; i < 10; i++) {
      double x = random.nextDouble() * size.width;
      double y = random.nextDouble() * size.height;
      paint.color = Colors.blueAccent.withOpacity(0.6 + 0.3 * sin(animationValue * 2 * pi));
      canvas.drawCircle(Offset(x, y), 3 + sin(animationValue * 2 * pi) * 1.5, paint);
    }

    // Draw nebula (inspired by reds, oranges, purples, blues)
    for (int i = 0; i < 3; i++) {
      double x = random.nextDouble() * size.width;
      double y = random.nextDouble() * size.height;
      paint.shader = RadialGradient(
        colors: [
          Colors.redAccent.withOpacity(0.15 + animationValue * 0.05),
          Colors.orangeAccent.withOpacity(0.1),
          Colors.purpleAccent.withOpacity(0.08),
          Colors.blueAccent.withOpacity(0.05),
          Colors.transparent,
        ],
        stops: [0.0, 0.3, 0.5, 0.7, 1.0],
      ).createShader(Rect.fromCircle(center: Offset(x, y), radius: 200));
      canvas.drawCircle(Offset(x, y), 200 + animationValue * 50, paint);
    }

    // Draw galaxy clusters (swirling, bright centers)
    for (int i = 0; i < 2; i++) {
      double x = random.nextDouble() * size.width;
      double y = random.nextDouble() * size.height;
      paint.shader = RadialGradient(
        colors: [
          Colors.white.withOpacity(0.3),
          Colors.blueAccent.withOpacity(0.15),
          Colors.purpleAccent.withOpacity(0.1),
          Colors.transparent,
        ],
        stops: [0.0, 0.2, 0.4, 1.0],
      ).createShader(Rect.fromCircle(center: Offset(x, y), radius: 150));
      canvas.drawCircle(Offset(x, y), 150 + animationValue * 30, paint);
    }
  }

  @override
  bool shouldRepaint(CosmicBackgroundPainter oldDelegate) => oldDelegate.animationValue != animationValue;
}

class MorphingTextData {
  final String wrongText;
  final String correctText;
  final double dx;
  final double dy;
  final Duration morphDelay;
  final double floatAmplitude;
  final Duration floatPeriod;
  final double fontSize;

  MorphingTextData({
    required this.wrongText,
    required this.correctText,
    required this.dx,
    required this.dy,
    required this.morphDelay,
    required this.floatAmplitude,
    required this.floatPeriod,
    required this.fontSize,
  });
}

class MorphingTextWidget extends StatefulWidget {
  final MorphingTextData data;
  final double containerWidth;
  final bool? initialShowCorrect;
  final double? initialFloatOffset;
  const MorphingTextWidget({
    Key? key,
    required this.data,
    required this.containerWidth,
    this.initialShowCorrect,
    this.initialFloatOffset,
  }) : super(key: key);

  @override
  MorphingTextWidgetState createState() => MorphingTextWidgetState();
}

class MorphingTextWidgetState extends State<MorphingTextWidget> with TickerProviderStateMixin {
  late bool showCorrect;
  late Timer morphTimer;
  late AnimationController floatController;
  late Animation<double> floatAnimation;
  double get currentOffset => floatAnimation.value;

  @override
  void initState() {
    super.initState();
    showCorrect = widget.initialShowCorrect ?? false;

    floatController = AnimationController(
      vsync: this,
      duration: widget.data.floatPeriod,
    );
    if (widget.initialFloatOffset != null) {
      floatController.value = (widget.initialFloatOffset! + widget.data.floatAmplitude) /
          (2 * widget.data.floatAmplitude);
    }
    floatAnimation = Tween<double>(
      begin: -widget.data.floatAmplitude,
      end: widget.data.floatAmplitude,
    ).animate(CurvedAnimation(parent: floatController, curve: Curves.easeInOut));
    floatController.repeat(reverse: true);

    morphTimer = Timer.periodic(widget.data.morphDelay, (timer) {
      if (mounted) {
        setState(() {
          showCorrect = !showCorrect;
        });
      }
    });
  }

  @override
  void dispose() {
    floatController.dispose();
    morphTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: floatAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, floatAnimation.value),
          child: Container(
            width: widget.containerWidth,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              layoutBuilder: (currentChild, previousChildren) {
                return Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    ...previousChildren,
                    if (currentChild != null) currentChild,
                  ],
                );
              },
              transitionBuilder: (child, animation) {
                return MorphTransition(animation: animation, child: child);
              },
              child: Text(
                showCorrect ? widget.data.correctText : widget.data.wrongText,
                key: ValueKey<bool>(showCorrect),
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: widget.data.fontSize,
                  fontWeight: FontWeight.w100,
                  fontFamily: 'Poppins',
                  color: Colors.white.withOpacity(0.9),
                  shadows: [
                    Shadow(
                      blurRadius: 12,
                      color: Colors.blueAccent.withOpacity(0.4),
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class MorphTransition extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;
  const MorphTransition({Key? key, required this.animation, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return ClipPath(
          clipper: MorphClipper(progress: animation.value),
          child: Opacity(
            opacity: animation.value,
            child: child,
          ),
        );
      },
    );
  }
}

class MorphClipper extends CustomClipper<Path> {
  final double progress;
  MorphClipper({required this.progress});

  @override
  Path getClip(Size size) {
    final Path path = Path();
    final int segments = 10;
    final double segmentWidth = size.width / segments;
    path.moveTo(0, 0);
    for (int i = 0; i <= segments; i++) {
      final double x = i * segmentWidth;
      final double wave = ((i % 2 == 0) ? 8 : -8) * progress;
      path.lineTo(x, wave);
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(MorphClipper oldClipper) => oldClipper.progress != progress;
}