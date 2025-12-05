import 'package:flutter/material.dart';
import '../models/coffee_item.dart';

class CoffeeDetailScreen extends StatefulWidget {
  final CoffeeItem coffee;

  const CoffeeDetailScreen({super.key, required this.coffee});

  @override
  State<CoffeeDetailScreen> createState() => _CoffeeDetailScreenState();
}

class _CoffeeDetailScreenState extends State<CoffeeDetailScreen> {
  bool isFavorite = false;
  String selectedTemperature = 'hot';
  String selectedSize = 'M';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header row
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.chevron_left,
                      color: Color(0xFF2F2D2C),
                      size: 32,
                    ),
                  ),
                  // Title
                  const Text(
                    'Detail',
                    style: TextStyle(
                      color: Color(0xFF2F2D2C),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // Favorite button
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: const Color(0xFFC67C4E),
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
            // Coffee image
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.25,
                    color: const Color(0xFFE0E0E0),
                    child: widget.coffee.imageUrl.isNotEmpty
                        ? Image.network(
                            widget.coffee.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.coffee,
                                size: 64,
                                color: Color(0xFFBDBDBD),
                              );
                            },
                          )
                        : const Icon(
                            Icons.coffee,
                            size: 64,
                            color: Color(0xFFBDBDBD),
                          ),
                  ),
                ),
              ),
            ),
            // Coffee title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.coffee.name,
                  style: const TextStyle(
                    color: Color(0xFF242424),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Temperature selection row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedTemperature == 'hot' 
                        ? 'Hot' 
                        : selectedTemperature == 'cold' 
                            ? 'Cold' 
                            : 'Hot & Cold',
                    style: const TextStyle(
                      color: Color(0xFF9B9B9B),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Row(
                    children: [
                      _buildTemperatureOption('hot', Icons.local_fire_department),
                      const SizedBox(width: 8),
                      _buildTemperatureOption('cold', Icons.ac_unit),
                      const SizedBox(width: 8),
                      _buildTemperatureOption('both', Icons.thermostat),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Rating row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Color(0xFFFBBE21),
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.coffee.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      color: Color(0xFF2F2D2C),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Divider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                height: 1,
                color: const Color(0xFFE0E0E0),
              ),
            ),
            const SizedBox(height: 16),
            // Description section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description',
                    style: TextStyle(
                      color: Color(0xFF2F2D2C),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'A ${widget.coffee.name} is a coffee drink that consists of espresso and steamed milk. It is a delicious and creamy beverage that is perfect for any time of day. Enjoy the rich flavor and smooth texture of this classic coffee drink.',
                    style: const TextStyle(
                      color: Color(0xFF9B9B9B),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Size section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Size',
                    style: TextStyle(
                      color: Color(0xFF2F2D2C),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSizeOption('S'),
                      _buildSizeOption('M'),
                      _buildSizeOption('L'),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Bottom price and buy button
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Price section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Price',
                        style: TextStyle(
                          color: Color(0xFF9B9B9B),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$ ${widget.coffee.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Color(0xFFC67C4E),
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  // Buy Now button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Add to cart functionality
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC67C4E),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Buy Now',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
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
  }

  Widget _buildTemperatureOption(String type, IconData icon) {
    final isSelected = selectedTemperature == type;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTemperature = type;
        });
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFC67C4E) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : const Color(0xFF9B9B9B),
          size: 20,
        ),
      ),
    );
  }

  Widget _buildSizeOption(String size) {
    final isSelected = selectedSize == size;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedSize = size;
          });
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFFC67C4E) : const Color(0xFFE0E0E0),
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              size,
              style: TextStyle(
                color: isSelected ? const Color(0xFFC67C4E) : const Color(0xFF242424),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
