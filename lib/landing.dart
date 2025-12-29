import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xff443838),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 10), // Reduced spacing
              Expanded(
                child: SingleChildScrollView(
                  // Added SingleChildScrollView
                  physics:
                      const BouncingScrollPhysics(), // Optional: better scrolling feel
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'WELCOME TO',
                          style: TextStyle(
                            fontSize: 18, // Slightly smaller
                            fontWeight: FontWeight.w600,
                            color: Colors.white70,
                            letterSpacing: 3,
                          ),
                        ),
                        const SizedBox(height: 30), // Reduced spacing

                        // Custom Logo Image - Square like Uber
                        Container(
                          width: 180, // Slightly smaller
                          height: 180, // Slightly smaller
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.3),
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.asset(
                              'images/dashdish_logo.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                // Fallback if image not found
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.orange.shade400,
                                        Colors.orange.shade700,
                                      ],
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.restaurant_menu,
                                        size: 50, // Slightly smaller
                                        color: Colors.white,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'DashDish',
                                        style: GoogleFonts.grenzeGotisch(
                                          fontSize: 22, // Slightly smaller
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 30), // Reduced spacing

                        // App Name
                        Text(
                          'DashDish',
                          style: GoogleFonts.grenzeGotisch(
                            fontSize: 42, // Reduced from 52
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.5, // Slightly reduced
                            shadows: [
                              const Shadow(
                                offset: Offset(0, 3),
                                blurRadius: 8,
                                color: Colors.black26,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Tagline with decorative line
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 25, // Slightly smaller
                              height: 2,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.orange.shade400,
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10), // Reduced
                              child: Text(
                                'FOOD IN A DASH',
                                style: TextStyle(
                                  fontSize: 11, // Slightly smaller
                                  fontWeight: FontWeight.w600,
                                  color: Colors.orange.shade400,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                            Container(
                              width: 25, // Slightly smaller
                              height: 2,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.orange.shade400,
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20), // Reduced spacing

                        // Description
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30), // Reduced
                          child: Text(
                            'Your go-to app for discovering and ordering delicious pizzas, burgers, pasta and kebabs. Order, enjoy – with DashDish.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14, // Slightly smaller
                              color: Colors.white70,
                              height: 1.6,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),

                        const SizedBox(height: 30), // Reduced spacing

                        // Buttons - Made more responsive
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 20), // Padding at bottom
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Login Button
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.orange.withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/login');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 35, // Slightly smaller
                                      vertical: 14, // Slightly smaller
                                    ),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 15, // Slightly smaller
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12), // Reduced spacing

                              // Sign Up Button
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/register');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: const Color(0xff443838),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 35, // Slightly smaller
                                      vertical: 14, // Slightly smaller
                                    ),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      fontSize: 15, // Slightly smaller
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
