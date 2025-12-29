import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

// Import your actual files
import 'profile.dart';
import 'fav.dart';
import 'ham.dart';
import 'pizza.dart';
import 'kebab.dart';
import 'pasta.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Map<String, dynamic>> _categories = [
    {
      'title': 'Hamburger',
      'asset': 'assets/images/BBQ b.png',
      'icon': Icons.lunch_dining,
      'page': const BurgerApp(),
      'tagline': 'Juicy & Delicious',
    },
    {
      'title': 'Pizza',
      'asset': 'assets/images/BBQ p.png',
      'icon': Icons.local_pizza,
      'page': const PizzaApp(),
      'tagline': 'Fresh & Cheesy',
    },
    {
      'title': 'Kebab',
      'asset': 'assets/images/doner.png',
      'icon': Icons.kebab_dining,
      'page': const KebabApp(),
      'tagline': 'Spicy & Tender',
    },
    {
      'title': 'Pasta',
      'asset': 'assets/images/pepe.png',
      'icon': Icons.dinner_dining,
      'page': const PastaApp(),
      'tagline': 'Creamy & Rich',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff443838),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'DashDish',
                    style: GoogleFonts.grenzeGotisch(
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFE7E6E4),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      children: [
                        Text(
                          'yenikent',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.location_on, size: 14),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Animated Promo card
              const AnimatedPromoCard(),

              const SizedBox(height: 20),

              // Enhanced Categories Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Categories',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 60,
                        height: 3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          gradient: LinearGradient(
                            colors: [
                              Colors.orange,
                              Colors.orange.withValues(alpha: 0.5),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white30, width: 0.5),
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const FavouritesPage()),
                        );
                      },
                      icon: const Icon(Icons.favorite_border,
                          size: 16, color: Colors.orange),
                      label: const Text(
                        'Favorites',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Enhanced Category Grid - FIXED OVERFLOW
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85, // Changed from 1.2 to 0.85 for more height
                  ),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    return CategoryCard(
                      title: _categories[index]['title'],
                      asset: _categories[index]['asset'],
                      icon: _categories[index]['icon'],
                      tagline: _categories[index]['tagline'],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => _categories[index]['page']),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
        onTap: (index) {
          setState(() => _currentIndex = index);
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartScreen()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            );
          }
        },
      ),
    );
  }
}

// ================= ENHANCED CATEGORY CARD - FIXED OVERFLOW =================
class CategoryCard extends StatefulWidget {
  final String title;
  final String asset;
  final IconData icon;
  final String tagline;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.asset,
    required this.icon,
    required this.tagline,
    required this.onTap,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _elevationAnimation = Tween<double>(begin: 2.0, end: 8.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleHover(bool hovering) {
    setState(() => _isHovering = hovering);
    if (hovering) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: () => _controller.reverse(),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[300],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: _elevationAnimation.value,
                      spreadRadius: _elevationAnimation.value * 0.5,
                      offset: Offset(0, _elevationAnimation.value * 0.5),
                    ),
                    if (_isHovering)
                      BoxShadow(
                        color: Colors.orange.withValues(alpha: 0.3),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                  ],
                  border: Border.all(
                    color: _isHovering
                        ? Colors.orange.withValues(alpha: 0.5)
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      // Background pattern
                      Positioned(
                        right: -20,
                        bottom: -20,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),

                      // Content - FIXED LAYOUT
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Icon and title row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Icon container
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.1),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    widget.icon,
                                    color: Colors.orange,
                                    size: 20,
                                  ),
                                ),

                                // Arrow indicator
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  transform: Matrix4.translationValues(
                                      _isHovering ? 3 : 0, 0, 0),
                                  child: const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            // Food image - Flexible to take available space
                            Expanded(
                              child: Center(
                                child: Image.asset(
                                  widget.asset,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),

                            const SizedBox(height: 8),

                            // Title and tagline - Fixed height
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  widget.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black87,
                                    letterSpacing: -0.5,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  widget.tagline,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[700],
                                    letterSpacing: 0.3,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                // Order count badge
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      'Order Now',
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.orange[800],
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ================= ANIMATED PROMO CARD =================
class AnimatedPromoCard extends StatefulWidget {
  const AnimatedPromoCard({super.key});

  @override
  State<AnimatedPromoCard> createState() => _AnimatedPromoCardState();
}

class _AnimatedPromoCardState extends State<AnimatedPromoCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<Color?> _borderAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _glowAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.02), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.02, end: 1.0), weight: 50),
    ]).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.15), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 1.0), weight: 60),
    ]).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _borderAnimation = ColorTween(
      begin: Colors.orange[300],
      end: Colors.deepOrangeAccent,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
      ),
    );

    _glowAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 50),
    ]).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _startAnimation();
  }

  void _startAnimation() {
    _controller.repeat(reverse: true);
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_controller.isAnimating) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[300],
              border: Border.all(
                color: _borderAnimation.value!,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withValues(alpha: _glowAnimation.value * 0.3),
                  blurRadius: 20 * _glowAnimation.value,
                  spreadRadius: 3 * _glowAnimation.value,
                ),
              ],
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.orange.shade50,
                  Colors.orange.shade100,
                  Colors.grey[300]!,
                ],
              ),
            ),
            child: Row(
              children: [
                // Animated Image
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.scale(
                      scale: _pulseAnimation.value * 1.1,
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.orange.withValues(alpha: 0.2),
                        ),
                      ),
                    ),
                    RotationTransition(
                      turns: Tween(begin: -0.05, end: 0.05).animate(
                        CurvedAnimation(
                          parent: _controller,
                          curve: Curves.easeInOut,
                        ),
                      ),
                      child: Image.asset(
                        'assets/images/zinger.png',
                        width: 70,
                        height: 70,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 70,
                            height: 70,
                            color: Colors.grey[300],
                            child: const Icon(Icons.fastfood,
                                size: 40, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Transform.translate(
                        offset: Offset(0, -5 * _pulseAnimation.value),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.deepOrange,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.deepOrange.withValues(alpha: 0.5),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Text(
                            '🔥 HOT',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Transform.translate(
                        offset: Offset(20 * (1 - _slideAnimation.value), 0),
                        child: Opacity(
                          opacity: _slideAnimation.value,
                          child: const Text(
                            'Zinger Burger',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Text(
                          '25% OFF',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Colors.deepOrange,
                            shadows: [
                              Shadow(
                                color: Colors.orange.withValues(alpha: 0.5),
                                blurRadius: 3,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Transform.translate(
                        offset: Offset(15 * (1 - _slideAnimation.value), 0),
                        child: Opacity(
                          opacity: _slideAnimation.value,
                          child: const Text(
                            'Weekend special deal',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Transform.scale(
                          scale: 1 + (_pulseAnimation.value - 1) * 0.2,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              gradient: const LinearGradient(
                                colors: [Colors.orange, Colors.deepOrange],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orange.withValues(alpha: 0.5),
                                  blurRadius: 10 * _pulseAnimation.value,
                                  offset: Offset(0, 3 * _pulseAnimation.value),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const BurgerApp(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Transform.translate(
                                    offset: Offset(
                                      3 * (1 - _pulseAnimation.value),
                                      0,
                                    ),
                                    child: const Icon(Icons.bolt, size: 16),
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'ORDER NOW',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  RotationTransition(
                                    turns: Tween(begin: 0.0, end: 1.0).animate(
                                      CurvedAnimation(
                                        parent: _controller,
                                        curve: Curves.easeInOut,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.arrow_forward,
                                      size: 14,
                                    ),
                                  ),
                                ],
                              ),
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
        );
      },
    );
  }
}