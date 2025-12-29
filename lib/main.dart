import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

// Screens
import 'landing.dart';
import 'login.dart';
import 'signup.dart';
import 'homepage.dart';
import 'profile.dart';
import 'fav.dart';
import 'forgot.dart';
import 'reset.dart';
import 'confirm.dart';
import 'checkout.dart';
import 'cart_screen.dart';
import 'pasta.dart';
import 'ham.dart';
import 'pizza.dart';
import 'kebab.dart';
import 'appmap.dart';

/// 🔴 MAIN — Firebase initialized ONCE here
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

/// 🔵 APP ROOT
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DashDish',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const GothicDropScreen(),
      routes: {
        '/landing': (context) => const LandingPage(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfilePage(),
        '/fav': (context) => const FavouritesPage(),
        '/forget': (context) => const ForgetPasswordPage(), // Now works
        '/reset': (context) => const ResetPasswordPage(),
        '/confirm': (context) => const ConfirmNewPasswordPage(),
        '/cart': (context) => CartScreen(), // REMOVED const - StatefulWidget
        '/checkout': (context) => const CheckoutScreen(), // Checkout page
        '/bur': (context) => const KebabApp(),
        '/pizza': (context) => const PizzaApp(),
        '/pasta': (context) => const PastaApp(),
        '/ham': (context) => const BurgerApp(),
        '/map': (context) => const AppMapScreen(),
      },
    );
  }
}

/// 🔵 INTRO ANIMATION SCREEN
class GothicDropScreen extends StatefulWidget {
  const GothicDropScreen({super.key});

  @override
  State<GothicDropScreen> createState() => _GothicDropScreenState();
}

class _GothicDropScreenState extends State<GothicDropScreen> {
  final List<String> phrases = [
    'MERRY CHRISTMAS',
    'AND',
    'HAPPY NEW YEAR',
    'DASHDISH',
  ];

  List<Widget> activeLetters = [];
  bool animationComplete = false;
  bool showTapHint = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startAnimation();
    });
  }

  Future<void> startAnimation() async {
    for (int i = 0; i < phrases.length; i++) {
      await playPhrase(phrases[i]);
      await Future.delayed(const Duration(seconds: 2));

      if (i < phrases.length - 1) {
        setState(() => activeLetters.clear());
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }

    setState(() => animationComplete = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => showTapHint = true);
  }

  Future<void> playPhrase(String text) async {
    final screenWidth = MediaQuery.of(context).size.width;
    final letters = text.split('');
    final startX = (screenWidth - letters.length * 34) / 2;

    activeLetters.clear();
    setState(() {});

    for (int i = 0; i < letters.length; i++) {
      activeLetters.add(
        FallingLetter(
          letter: letters[i],
          x: startX + i * 34,
          index: i,
          isBrand: text == 'DASHDISH',
        ),
      );
      setState(() {});
      await Future.delayed(const Duration(milliseconds: 120));
    }
  }

  void navigate() {
    if (animationComplete) {
      Navigator.pushReplacementNamed(context, '/landing');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: navigate,
      child: Scaffold(
        backgroundColor: const Color(0xFF443838),
        body: Stack(
          children: [
            ...activeLetters,
            if (showTapHint)
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Column(
                  children: const [
                    Text(
                      'Tap anywhere to continue',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(height: 10),
                    Icon(Icons.arrow_downward, color: Colors.white70),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// 🔵 FALLING LETTER WIDGET
class FallingLetter extends StatefulWidget {
  final String letter;
  final double x;
  final int index;
  final bool isBrand;

  const FallingLetter({
    super.key,
    required this.letter,
    required this.x,
    required this.index,
    required this.isBrand,
  });

  @override
  State<FallingLetter> createState() => _FallingLetterState();
}

class _FallingLetterState extends State<FallingLetter>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> fall;
  late Animation<double> swing;
  late Animation<double> opacity;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1600 + widget.index * 90),
    );

    fall = Tween<double>(begin: -120, end: 220).animate(
      CurvedAnimation(parent: controller, curve: Curves.bounceOut),
    );

    swing = Tween<double>(begin: -0.2, end: 0.2).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
      ),
    );

    opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.3, 1.0),
      ),
    );

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      child: Text(
        widget.letter,
        style: GoogleFonts.grenzeGotisch(
          fontSize: widget.isBrand ? 48 : 40,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          shadows: const [
            Shadow(offset: Offset(2, 4), blurRadius: 8, color: Colors.black54),
            Shadow(offset: Offset(-1, -1), blurRadius: 4, color: Colors.black),
          ],
        ),
      ),
      builder: (context, child) {
        return Positioned(
          left: widget.x,
          top: fall.value,
          child: Opacity(
            opacity: opacity.value,
            child: Transform.rotate(
              angle: swing.value * sin(controller.value * pi * 2),
              child: child,
            ),
          ),
        );
      },
    );
  }
}
