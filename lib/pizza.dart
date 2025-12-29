import 'package:flutter/material.dart';
import 'package:flutter_application_9/homepage.dart';
import 'cart_manager.dart';
import 'favorites_manager.dart';
import 'fav.dart';

void main() {
  runApp(const PizzaApp());
}

class PizzaApp extends StatelessWidget {
  const PizzaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pizza App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFF443838),
        fontFamily: 'Roboto',
      ),
      home: const PizzaGridPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Pizza {
  final String name;
  final String image;
  final String description;
  final int price;
  final double rating;
  final String prepTime;

  const Pizza({
    required this.name,
    required this.image,
    required this.description,
    required this.price,
    required this.rating,
    required this.prepTime,
  });
}

class PizzaGridPage extends StatelessWidget {
  const PizzaGridPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Pizza> pizzas = [
      const Pizza(
        name: 'Turkish Pizza',
        image: 'assets/images/tu.png',
        description: 'Classic cheese pizza with fresh tomatoes and basil.',
        price: 15,
        rating: 4.5,
        prepTime: '15 mins',
      ),
      const Pizza(
        name: 'Chicken Pizza',
        image: 'assets/images/chip.png',
        description: 'Spicy pepperoni with mozzarella cheese and tomato sauce.',
        price: 18,
        rating: 4.8,
        prepTime: '20 mins',
      ),
      const Pizza(
        name: 'BBQ Pizza',
        image: 'assets/images/BBQ p.png',
        description: 'Grilled chicken, BBQ sauce, onions, and cheese.',
        price: 20,
        rating: 4.9,
        prepTime: '25 mins',
      ),
      const Pizza(
        name: 'Cheese Pizza',
        image: 'assets/images/cp.png',
        description: 'Loaded with fresh veggies, cheese, and tomato sauce.',
        price: 17,
        rating: 4.3,
        prepTime: '20 mins',
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
          'Pizza',
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
          itemCount: pizzas.length,
          itemBuilder: (context, index) {
            return PizzaGridCard(
              pizza: pizzas[index],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PizzaDetailPage(pizza: pizzas[index]),
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

class PizzaGridCard extends StatelessWidget {
  final Pizza pizza;
  final VoidCallback onTap;

  const PizzaGridCard({super.key, required this.pizza, required this.onTap});

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
                  child: Image.asset(pizza.image, fit: BoxFit.contain),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                pizza.name,
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

class PizzaDetailPage extends StatefulWidget {
  final Pizza pizza;

  const PizzaDetailPage({super.key, required this.pizza});

  @override
  State<PizzaDetailPage> createState() => _PizzaDetailPageState();
}

class _PizzaDetailPageState extends State<PizzaDetailPage> {
  int quantity = 1;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = isFavorite(widget.pizza.name);
  }

  void toggleFavorite() {
    setState(() {
      if (_isFavorite) {
        removeFromFavorites(widget.pizza.name);
      } else {
        addToFavorites(FavoriteItem(
          name: widget.pizza.name,
          image: widget.pizza.image,
          description: widget.pizza.description,
          price: widget.pizza.price,
          rating: widget.pizza.rating,
          prepTime: widget.pizza.prepTime,
          category: 'pizza',
        ));
      }
      _isFavorite = !_isFavorite;
    });
  }

  void addToCart() {
    myCart.addItem(CartItem(
      widget.pizza.name,
      widget.pizza.price.toDouble(),
      quantity,
      widget.pizza.image,
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.pizza.name} added to cart!'),
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
              // Pizza Image
              SizedBox(
                height: 200,
                child: Center(
                  child: Image.asset(widget.pizza.image, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(height: 16),

              // Pizza Name
              Text(
                widget.pizza.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              // Time and Rating
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    widget.pizza.prepTime,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(width: 24),
                  const Icon(Icons.star, size: 16, color: Color(0xFFFFA500)),
                  const SizedBox(width: 4),
                  Text(
                    widget.pizza.rating.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                widget.pizza.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),

              // Price and Quantity
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${widget.pizza.price}',
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

              // Add to Cart Button
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
