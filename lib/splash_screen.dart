import 'package:fitplanv_1/to%20be%20deleted/get_started.dart';
import 'package:fitplanv_1/printtablenametest.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'to be deleted/maps.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoAnimation;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _logoAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    );

    _logoController.forward();

    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FirstScreen(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _logoAnimation,
              child: Container(
                width: 150,
                height: 150,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.fastfood,
                    color: Colors.white,
                    size: 80,
                  ),
                ),
              ),
              builder: (context, child) {
                return Transform.scale(
                  scale: _logoAnimation.value,
                  child: child,
                );
              },
            ),
            const SizedBox(height: 30),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(seconds: 2),
              builder: (context, value, child) {
                return ShaderMask(
                  shaderCallback: (bounds) {
                    return RadialGradient(
                      center: Alignment.topLeft,
                      radius: value * 2,
                      colors: const [Colors.white, Colors.green],
                      tileMode: TileMode.mirror,
                    ).createShader(bounds);
                  },
                  child: const Text(
                    'FitPlan',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      decoration: TextDecoration.none,
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.green,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

