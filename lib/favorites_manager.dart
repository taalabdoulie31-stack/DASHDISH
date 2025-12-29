// Universal FoodItem class that works for all food types
class FavoriteItem {
  final String name;
  final String image;
  final String description;
  final int price;
  final double rating;
  final String prepTime;
  final String category; // 'pizza', 'pasta', 'burger', 'kebab'

  FavoriteItem({
    required this.name,
    required this.image,
    required this.description,
    required this.price,
    required this.rating,
    required this.prepTime,
    required this.category,
  });
}

// Global list to store all favorites
List<FavoriteItem> globalFavorites = [];

// Helper function to add to favorites
void addToFavorites(FavoriteItem item) {
  if (!globalFavorites.any((fav) => fav.name == item.name)) {
    globalFavorites.add(item);
  }
}

// Helper function to remove from favorites
void removeFromFavorites(String itemName) {
  globalFavorites.removeWhere((fav) => fav.name == itemName);
}

// Helper function to check if item is favorite
bool isFavorite(String itemName) {
  return globalFavorites.any((fav) => fav.name == itemName);
}

// Helper function to toggle favorite status
void toggleFavorite(FavoriteItem item) {
  if (isFavorite(item.name)) {
    removeFromFavorites(item.name);
  } else {
    addToFavorites(item);
  }
}
