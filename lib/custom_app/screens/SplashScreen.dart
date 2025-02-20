import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: GhostTypeSplashScreen(),
  ));
}

class GhostTypeSplashScreen extends StatefulWidget {
  const GhostTypeSplashScreen({Key? key}) : super(key: key);

  @override
  State<GhostTypeSplashScreen> createState() => _GhostTypeSplashScreenState();
}

class _GhostTypeSplashScreenState extends State<GhostTypeSplashScreen> {
  final List<MorphingTextData> textItems = [];
  // Increased container width to 350 to accommodate larger texts.
  static const double containerWidth = 350;
  static const int totalTexts = 20;
  // We'll sample positions in [0.1, 0.9] with a minimum separation.
  static const double minDistanceFraction = 0.12;

  @override
  void initState() {
    super.initState();
    _generateTexts();
  }

  // Expanded feature pairs with language changes and tone adjustments.
  final List<List<String>> pairs = [
    // Language transformations with actual language letters:

    ["HELLO", "こんにちは"],              // Hello
    ["GOODBYE", "さようなら"],            // Goodbye
    // English to Hindi
    ["THANK YOU", "धन्यवाद"],            // Thank You
    ["PLEASE", "कृपया"],                // Please
    // English to Chinese
    ["I LOVE YOU", "我爱你"],              // I Love You
    ["WHAT IS YOUR NAME", "你叫什么名字"], // What is your name?
    // English to Russian
    ["WELCOME", "Добро пожаловать"],      // Welcome
    ["GOOD NIGHT", "Спокойной ночи"],      // Good Night
    // English to Korean
    ["HOW ARE YOU", "안녕하세요?"],         // How are you?
    ["SEE YOU LATER", "나중에 봐요"],       // See You Late
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
    // English → Hindi
  ];

  void _generateTexts() {
    final random = Random();
    pairs.shuffle(random);
    for (int i = 0; i < totalTexts; i++) {
      // Generate random dx, dy in [0.1, 0.9] with a minimum separation.
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
      // Randomize font size between 12 and 32.
      double fontSize = 12 + random.nextDouble() * 20;
      textItems.add(
        MorphingTextData(
          wrongText: pair[0],
          correctText: pair[1],
          dx: pos.dx,
          dy: pos.dy,
          // Morph delay between 3000ms and 4000ms.
          morphDelay: Duration(milliseconds: 3000 + random.nextInt(1000)),
          // Floating amplitude between 3 and 6 pixels.
          floatAmplitude: 3.0 + random.nextDouble() * 3.0,
          // Floating period between 3000 and 5000ms.
          floatPeriod: Duration(milliseconds: 3000 + random.nextInt(2000)),
          fontSize: fontSize,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use LayoutBuilder for responsive positioning.
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: textItems.map((data) {
              // Compute ideal left so that the container is centered at (data.dx * width).
              double idealLeft = (constraints.maxWidth * data.dx) - (containerWidth / 2);
              // Do not clamp, so texts may be partially off-screen if desired.
              double left = idealLeft;
              double top = constraints.maxHeight * data.dy;
              return Positioned(
                left: left,
                top: top,
                child: MorphingTextWidget(
                  data: data,
                  containerWidth: containerWidth,
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

/// Data model for each morphing text.
class MorphingTextData {
  final String wrongText;
  final String correctText;
  final double dx; // Relative horizontal position [0,1]
  final double dy; // Relative vertical position [0,1]
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

/// Widget that displays one morphing text with smooth floating and morph transitions.
class MorphingTextWidget extends StatefulWidget {
  final MorphingTextData data;
  final double containerWidth;
  const MorphingTextWidget({Key? key, required this.data, required this.containerWidth})
      : super(key: key);

  @override
  State<MorphingTextWidget> createState() => _MorphingTextWidgetState();
}

class _MorphingTextWidgetState extends State<MorphingTextWidget>
    with SingleTickerProviderStateMixin {
  bool showCorrect = false;
  late Timer morphTimer;
  late AnimationController floatController;
  late Animation<double> floatAnimation;

  @override
  void initState() {
    super.initState();
    // Floating animation: oscillate smoothly.
    floatController = AnimationController(
      vsync: this,
      duration: widget.data.floatPeriod,
    )..repeat(reverse: true);
    floatAnimation = Tween<double>(
      begin: -widget.data.floatAmplitude,
      end: widget.data.floatAmplitude,
    ).animate(CurvedAnimation(parent: floatController, curve: Curves.easeInOut));

    // Toggle morph state periodically.
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
    // Wrap the text in a fixed-width container with center alignment.
    return AnimatedBuilder(
      animation: floatAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, floatAnimation.value),
          child: Container(
            width: widget.containerWidth,
            alignment: Alignment.center,
            // Reduced horizontal padding to minimize cutting.
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 1500),
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
                  //fontWeight: FontWeight.bold,
                  fontFamily: 'RobotoMono',
                  color: Colors.white,
                  // Uniform white glow effect.
                  shadows: [
                    Shadow(
                      blurRadius: 12,
                      color: Colors.white.withOpacity(0.8),
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

/// Custom transition widget that applies a liquid-like morph effect.
class MorphTransition extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;
  const MorphTransition({Key? key, required this.animation, required this.child})
      : super(key: key);

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

/// Custom clipper that creates a wavy clip path for the morph transition.
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
