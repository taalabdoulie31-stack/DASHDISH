import 'package:flutter/material.dart';
import 'package:flutter_application_9/homepage.dart';
import 'cart_manager.dart';
import 'favorites_manager.dart';
import 'fav.dart';

void main() {
  runApp(const PastaApp());
}

class PastaApp extends StatelessWidget {
  const PastaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pasta App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFF443838),
        fontFamily: 'Roboto',
      ),
      home: const PastaGridPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Pasta {
  final String name;
  final String image;
  final String description;
  final int price;
  final double rating;
  final String prepTime;

  const Pasta({
    required this.name,
    required this.image,
    required this.description,
    required this.price,
    required this.rating,
    required this.prepTime,
  });
}

class PastaGridPage extends StatelessWidget {
  const PastaGridPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Pasta> pastas = [
      const Pasta(
        name: 'Farfelle',
        image: 'assets/images/fa.png',
        description:
            'Classic spaghetti with creamy sauce, bacon, and parmesan.',
        price: 18,
        rating: 4.8,
        prepTime: '20 mins',
      ),
      const Pasta(
        name: 'White Bolognese',
        image: 'assets/images/whi.png',
        description: 'Penne pasta with spicy tomato sauce and garlic.',
        price: 16,
        rating: 4.5,
        prepTime: '15 mins',
      ),
      const Pasta(
        name: 'Alfredo',
        image: 'assets/images/al.png',
        description: 'Fettuccine pasta with creamy Alfredo sauce and parmesan.',
        price: 19,
        rating: 4.7,
        prepTime: '25 mins',
      ),
      const Pasta(
        name: 'Cacio er pepe',
        image: 'assets/images/pepe.png',
        description:
            'Layers of pasta, cheese, and rich meat sauce baked to perfection.',
        price: 20,
        rating: 4.9,
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
          'Pasta',
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
          itemCount: pastas.length,
          itemBuilder: (context, index) {
            return PastaGridCard(
              pasta: pastas[index],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PastaDetailPage(pasta: pastas[index]),
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

class PastaGridCard extends StatelessWidget {
  final Pasta pasta;
  final VoidCallback onTap;

  const PastaGridCard({super.key, required this.pasta, required this.onTap});

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
                  child: Image.asset(pasta.image, fit: BoxFit.contain),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                pasta.name,
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

class PastaDetailPage extends StatefulWidget {
  final Pasta pasta;

  const PastaDetailPage({super.key, required this.pasta});

  @override
  State<PastaDetailPage> createState() => _PastaDetailPageState();
}

class _PastaDetailPageState extends State<PastaDetailPage> {
  int quantity = 1;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = isFavorite(widget.pasta.name);
  }

  void toggleFavorite() {
    setState(() {
      if (_isFavorite) {
        removeFromFavorites(widget.pasta.name);
      } else {
        addToFavorites(FavoriteItem(
          name: widget.pasta.name,
          image: widget.pasta.image,
          description: widget.pasta.description,
          price: widget.pasta.price,
          rating: widget.pasta.rating,
          prepTime: widget.pasta.prepTime,
          category: 'pasta',
        ));
      }
      _isFavorite = !_isFavorite;
    });
  }

  void addToCart() {
    myCart.addItem(CartItem(
      widget.pasta.name,
      widget.pasta.price.toDouble(),
      quantity,
      widget.pasta.image,
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.pasta.name} added to cart!'),
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
                  child: Image.asset(widget.pasta.image, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.pasta.name,
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
                    widget.pasta.prepTime,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(width: 24),
                  const Icon(Icons.star, size: 16, color: Color(0xFFFFA500)),
                  const SizedBox(width: 4),
                  Text(
                    widget.pasta.rating.toString(),
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
                widget.pasta.description,
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
                    '\$${widget.pasta.price}',
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
                            if (quantity > 1) setState(() => quantity--);
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
