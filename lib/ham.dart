import 'package:flutter/material.dart';
import 'package:flutter_application_9/homepage.dart';
import 'package:flutter_application_9/cart_manager.dart';
import 'favorites_manager.dart';
import 'fav.dart';

void main() {
  runApp(const BurgerApp());
}

class BurgerApp extends StatelessWidget {
  const BurgerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Burger App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFF443838),
        fontFamily: 'Roboto',
      ),
      home: const HamburgerGridPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Burger {
  final String name;
  final String image;
  final String description;
  final int price;
  final double rating;
  final String prepTime;

  const Burger({
    required this.name,
    required this.image,
    required this.description,
    required this.price,
    required this.rating,
    required this.prepTime,
  });
}

class HamburgerGridPage extends StatelessWidget {
  const HamburgerGridPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Burger> burgers = [
      const Burger(
        name: 'Zinger burger',
        image: 'assets/images/zinger.png',
        description:
            'Crispy chicken fillet, fresh lettuce, mayo, and a soft sesame bun.',
        price: 20,
        rating: 4.0,
        prepTime: '10 mins',
      ),
      const Burger(
        name: 'BBQ burger',
        image: 'assets/images/BBQ b.png',
        description: 'Smoky BBQ sauce grilled beef onions and cheese.',
        price: 20,
        rating: 4.9,
        prepTime: '30 mins',
      ),
      const Burger(
        name: 'Cheese burger',
        image: 'assets/images/cb.png',
        description: 'A beef patty with melted cheese and a toasted bun.',
        price: 20,
        rating: 5.0,
        prepTime: '30 mins',
      ),
      const Burger(
        name: 'Black burger',
        image: 'assets/images/bb.png',
        description: 'A tasty burger with a soft and black bun juicy beef.',
        price: 20,
        rating: 4.2,
        prepTime: '30 mins',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF443838),
      appBar: AppBar(
        backgroundColor: const Color(0xFF443838),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
            );
          },
        ),
        title: const Text(
          'Hamburger',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavouritesPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemCount: burgers.length,
          itemBuilder: (context, index) {
            return BurgerGridCard(
              burger: burgers[index],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        BurgerDetailPage(burger: burgers[index]),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class BurgerGridCard extends StatelessWidget {
  final Burger burger;
  final VoidCallback onTap;

  const BurgerGridCard({super.key, required this.burger, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Image.asset(burger.image, fit: BoxFit.contain),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                burger.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: const Text(
                    'Order',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BurgerDetailPage extends StatefulWidget {
  final Burger burger;

  const BurgerDetailPage({super.key, required this.burger});

  @override
  State<BurgerDetailPage> createState() => _BurgerDetailPageState();
}

class _BurgerDetailPageState extends State<BurgerDetailPage> {
  int quantity = 1;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = isFavorite(widget.burger.name);
  }

  void toggleFavorite() {
    setState(() {
      if (_isFavorite) {
        removeFromFavorites(widget.burger.name);
      } else {
        addToFavorites(FavoriteItem(
          name: widget.burger.name,
          image: widget.burger.image,
          description: widget.burger.description,
          price: widget.burger.price,
          rating: widget.burger.rating,
          prepTime: widget.burger.prepTime,
          category: 'burger',
        ));
      }
      _isFavorite = !_isFavorite;
    });
  }

  void addToCart() {
    myCart.addItem(CartItem(
      widget.burger.name,
      widget.burger.price.toDouble(),
      quantity,
      widget.burger.image,
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.burger.name} added to cart!'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF443838),
      appBar: AppBar(
        backgroundColor: const Color(0xFF443838),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : Colors.white,
            ),
            onPressed: toggleFavorite,
          ),
        ],
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 200,
                child: Center(
                  child: Image.asset(widget.burger.image, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.burger.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    widget.burger.prepTime,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(width: 24),
                  const Icon(Icons.star, size: 16, color: Color(0xFFFFA500)),
                  const SizedBox(width: 4),
                  Text(
                    widget.burger.rating.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                widget.burger.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${widget.burger.price}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove, size: 20),
                          onPressed: () {
                            if (quantity > 1) {
                              setState(() => quantity--);
                            }
                          },
                        ),
                        Text(
                          quantity.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, size: 20),
                          onPressed: () {
                            setState(() => quantity++);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: addToCart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFA500),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Add to cart',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
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
