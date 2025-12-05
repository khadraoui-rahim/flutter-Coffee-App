import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/coffee_item.dart';
import 'coffee_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(Icons.home, true),
                _buildNavItem(Icons.favorite_border, false),
                _buildNavItem(Icons.shopping_bag_outlined, false),
                _buildNavItem(Icons.notifications_outlined, false),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              // Background layers
              Column(
                children: [
                  // Black gradient background
                  Container(
                    height: 280,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFF111111), Color(0xFF313131)],
                      ),
                    ),
                  ),
                  // White background (rest of the page)
                  Container(height: 1000, color: const Color(0xFFF9F9F9)),
                ],
              ),
              // Content layer
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  top: 4.0,
                  right: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Location text
                    const Text(
                      'Location',
                      style: TextStyle(color: Color(0xFFA2A2A2), fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    // Location with chevron
                    Row(
                      children: [
                        const Text(
                          'Algiers, bab ezzouar',
                          style: TextStyle(
                            color: Color(0xFFD8D8D8),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: const Color(0xFFD8D8D8),
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Search bar and settings button
                    Row(
                      children: [
                        // Search box (takes most of the width)
                        Expanded(
                          child: Container(
                            height: 52,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2A2A2A),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Search coffee',
                                  style: TextStyle(
                                    color: Color(0xFFA2A2A2),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Settings button (square box)
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: const Color(0xFFC67C4E),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.tune,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Promo image box
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: double.infinity,
                        height: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: const DecorationImage(
                            image: AssetImage('assets/Promo.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Coffee types horizontal scroll
                    SizedBox(
                      height: 38,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildCoffeeTypeChip('All Coffee', true),
                          const SizedBox(width: 12),
                          _buildCoffeeTypeChip('Machiato', false),
                          const SizedBox(width: 12),
                          _buildCoffeeTypeChip('Latte', false),
                          const SizedBox(width: 12),
                          _buildCoffeeTypeChip('Americano', false),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Coffee items grid - 2 column layout
                    ...List.generate((coffeeItems.length / 2).ceil(), (index) {
                      final leftIndex = index * 2;
                      final rightIndex = leftIndex + 1;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: _buildCoffeeCard(
                                context,
                                coffeeItems[leftIndex],
                              ),
                            ),
                            if (rightIndex < coffeeItems.length) ...[
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildCoffeeCard(
                                  context,
                                  coffeeItems[rightIndex],
                                ),
                              ),
                            ] else
                              const Expanded(child: SizedBox()),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoffeeTypeChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFC67C4E) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF2F2D2C),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCoffeeCard(BuildContext context, CoffeeItem item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with rating
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Container(
                  width: double.infinity,
                  height: 132,
                  color: const Color(0xFFE0E0E0),
                  child: item.imageUrl.isNotEmpty
                      ? Image.network(
                          item.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.coffee,
                              size: 48,
                              color: Color(0xFFBDBDBD),
                            );
                          },
                        )
                      : const Icon(
                          Icons.coffee,
                          size: 48,
                          color: Color(0xFFBDBDBD),
                        ),
                ),
              ),
              // Rating badge
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0x80000000),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Color(0xFFFBBE21),
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Coffee details
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    color: Color(0xFF242424),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.type,
                  style: const TextStyle(
                    color: Color(0xFF9B9B9B),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 12),
                // Price and add button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$ ${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Color(0xFF2F4B4E),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CoffeeDetailScreen(coffee: item),
                          ),
                        );
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFFC67C4E),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 16,
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
    );
  }

  Widget _buildNavItem(IconData icon, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isSelected ? const Color(0xFFC67C4E) : const Color(0xFF8D8D8D),
          size: 28,
        ),
        if (isSelected)
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFFC67C4E),
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }
}
