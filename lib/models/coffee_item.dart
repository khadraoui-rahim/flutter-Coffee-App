class CoffeeItem {
  final String imageUrl;
  final String name;
  final String type;
  final double price;
  final double rating;

  CoffeeItem({
    required this.imageUrl,
    required this.name,
    required this.type,
    required this.price,
    required this.rating,
  });
}

final List<CoffeeItem> coffeeItems = [
  CoffeeItem(
    imageUrl: 'https://images.unsplash.com/photo-1594146971821-373461fd5cd8?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    name: 'Caffe Mocha',
    type: 'Deep Foam',
    price: 4.53,
    rating: 4.8,
  ),
  CoffeeItem(
    imageUrl: 'https://images.unsplash.com/photo-1587466959442-d4d155afc586?q=80&w=1074&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    name: 'Flat White',
    type: 'Espresso',
    price: 3.89,
    rating: 4.5,
  ),
  CoffeeItem(
    imageUrl: 'https://images.unsplash.com/photo-1622843404078-a09315f46ae3?q=80&w=1074&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    name: 'Cappuccino',
    type: 'With Chocolate',
    price: 4.20,
    rating: 4.7,
  ),
  CoffeeItem(
    imageUrl: 'https://images.unsplash.com/photo-1557238574-aca2834bae47?q=80&w=735&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    name: 'Caramel Macchiato',
    type: 'With Oat Milk',
    price: 4.15,
    rating: 4.9,
  ),
  CoffeeItem(
    imageUrl: 'https://images.unsplash.com/photo-1585594467309-b726b6ba2fb5?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    name: 'Americano',
    type: 'Double Shot',
    price: 3.50,
    rating: 4.6,
  ),
];
