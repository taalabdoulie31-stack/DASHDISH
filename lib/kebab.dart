import 'package:flutter/material.dart';
import 'package:flutter_application_9/homepage.dart';
import 'package:flutter_application_9/cart_manager.dart';
import 'favorites_manager.dart';
import 'fav.dart';

class KebabApp extends StatelessWidget {
  const KebabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kebab App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFF443838),
        fontFamily: 'Roboto',
      ),
      home: const KebabGridPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Kebab {
  final String name;
  final String image;
  final String description;
  final int price;
  final double rating;
  final String prepTime;

  const Kebab({
    required this.name,
    required this.image,
    required this.description,
    required this.price,
    required this.rating,
    required this.prepTime,
  });
}

class KebabGridPage extends StatefulWidget {
  const KebabGridPage({super.key});

  @override
  State<KebabGridPage> createState() => _KebabGridPageState();
}

class _KebabGridPageState extends State<KebabGridPage> {
  @override
  void initState() {
    super.initState();
    myCart.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    myCart.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Kebab> kebabs = [
      const Kebab(
        name: 'Shish Kebab',
        image: 'assets/images/shi.png',
        description: 'Tender pieces of marinated meat grilled on skewers.',
        price: 25,
        rating: 4.8,
        prepTime: '20 mins',
      ),
      const Kebab(
        name: 'Doner Kebab',
        image: 'assets/images/doner.png',
        description:
            'Thinly sliced roasted meat served with flatbread and sauces.',
        price: 18,
        rating: 4.6,
        prepTime: '15 mins',
      ),
      const Kebab(
        name: 'Adana Kebab',
        image: 'assets/images/adana.png',
        description: 'Spicy minced meat skewers grilled to perfection.',
        price: 22,
        rating: 4.7,
        prepTime: '25 mins',
      ),
      const Kebab(
        name: 'Chapli Kebab',
        image: 'assets/images/ck.png',
        description: 'Juicy lamb skewers with traditional spices.',
        price: 28,
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
          'Kebabs',
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
          itemCount: kebabs.length,
          itemBuilder: (context, index) {
            return KebabGridCard(
              kebab: kebabs[index],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => KebabDetailPage(kebab: kebabs[index]),
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

class KebabGridCard extends StatelessWidget {
  final Kebab kebab;
  final VoidCallback onTap;

  const KebabGridCard({super.key, required this.kebab, required this.onTap});

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
                  child: Image.asset(kebab.image, fit: BoxFit.contain),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                kebab.name,
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

class KebabDetailPage extends StatefulWidget {
  final Kebab kebab;

  const KebabDetailPage({super.key, required this.kebab});

  @override
  State<KebabDetailPage> createState() => _KebabDetailPageState();
}

class _KebabDetailPageState extends State<KebabDetailPage> {
  int quantity = 1;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _isFavorite = isFavorite(widget.kebab.name);
  }

  void toggleFavorite() {
    setState(() {
      if (_isFavorite) {
        removeFromFavorites(widget.kebab.name);
      } else {
        addToFavorites(FavoriteItem(
          name: widget.kebab.name,
          image: widget.kebab.image,
          description: widget.kebab.description,
          price: widget.kebab.price,
          rating: widget.kebab.rating,
          prepTime: widget.kebab.prepTime,
          category: 'kebab',
        ));
      }
      _isFavorite = !_isFavorite;
    });
  }

  void addToCart() {
    myCart.addItem(CartItem(
      widget.kebab.name,
      widget.kebab.price.toDouble(),
      quantity,
      widget.kebab.image,
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.kebab.name} added to cart!'),
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
                  child: Image.asset(widget.kebab.image, fit: BoxFit.contain),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.kebab.name,
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
                    widget.kebab.prepTime,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(width: 24),
                  const Icon(Icons.star, size: 16, color: Color(0xFFFFA500)),
                  const SizedBox(width: 4),
                  Text(
                    widget.kebab.rating.toString(),
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
                widget.kebab.description,
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
                    '\$${widget.kebab.price}',
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
