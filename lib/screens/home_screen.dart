import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/coffee_item.dart';
import '../services/api_service.dart';
import '../widgets/filter_dialog.dart';
import 'coffee_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  List<CoffeeItem> _coffeeItems = [];
  bool _isLoading = true;
  String? _errorMessage;
  FilterOptions _filterOptions = FilterOptions();

  @override
  void initState() {
    super.initState();
    _loadCoffees();
  }

  Future<void> _loadCoffees() async {
    print('Starting to load coffees...');
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      print('Calling API service...');
      final coffees = await _apiService.getAllCoffees(
        search: _filterOptions.searchTerm,
        typeFilter: _filterOptions.coffeeType,
        minPrice: _filterOptions.minPrice,
        maxPrice: _filterOptions.maxPrice,
        sort: _filterOptions.sortBy,
        order: _filterOptions.sortOrder,
      );
      print('Received ${coffees.length} coffees from API');
      setState(() {
        _coffeeItems = coffees;
        _isLoading = false;
      });
      print('State updated successfully');
    } catch (e, stackTrace) {
      print('Error loading coffees: $e');
      print('Stack trace: $stackTrace');
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _showFilterDialog() async {
    final result = await showDialog<FilterOptions>(
      context: context,
      builder: (context) => FilterDialog(initialFilters: _filterOptions),
    );

    if (result != null) {
      setState(() {
        _filterOptions = result;
      });
      _loadCoffees();
    }
  }

  String _buildFilterSummary() {
    final parts = <String>[];

    if (_filterOptions.searchTerm != null) {
      parts.add('Search: "${_filterOptions.searchTerm}"');
    }
    if (_filterOptions.coffeeType != null) {
      parts.add('Type: ${_filterOptions.coffeeType}');
    }
    if (_filterOptions.minPrice != null || _filterOptions.maxPrice != null) {
      if (_filterOptions.minPrice != null && _filterOptions.maxPrice != null) {
        parts.add(
          'Price: \$${_filterOptions.minPrice} - \$${_filterOptions.maxPrice}',
        );
      } else if (_filterOptions.minPrice != null) {
        parts.add('Min: \$${_filterOptions.minPrice}');
      } else {
        parts.add('Max: \$${_filterOptions.maxPrice}');
      }
    }
    if (_filterOptions.sortBy != null) {
      final order = _filterOptions.sortOrder == 'asc' ? '↑' : '↓';
      parts.add('Sort: ${_filterOptions.sortBy} $order');
    }

    return parts.join(' • ');
  }

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

    // Calculate content height dynamically
    // Fixed elements heights:
    // - Location text: 12 + 4 spacing
    // - Location with chevron: 20 + 16 spacing
    // - Search bar: 52 + 12/24 spacing
    // - Filter indicator (if active): 32 + 12 spacing
    // - Promo: 160 + 24 spacing
    // - Coffee types: 38 + 24 spacing
    // - Each coffee card row: ~250 (132 image + 118 details) + 16 spacing
    // - Bottom padding: 8

    final int coffeeRows = (_coffeeItems.length / 2).ceil();
    final double coffeeCardsHeight =
        coffeeRows * 266.0; // 250 card + 16 spacing
    final double filterIndicatorHeight = _filterOptions.hasActiveFilters
        ? 44.0
        : 0.0;

    final double contentHeight =
        16 + // Location text
        20 + // Location with chevron
        16 + // spacing
        52 + // Search bar
        filterIndicatorHeight + // Filter indicator (conditional)
        24 + // spacing
        160 + // Promo
        24 + // spacing
        38 + // Coffee types
        24 + // spacing
        coffeeCardsHeight + // Coffee cards
        8 + // bottom padding
        100; // Extra buffer

    final double whiteBackgroundHeight =
        contentHeight - 280 + 200; // Subtract dark section, add extra

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
                  // White background (calculated to cover all content)
                  Container(
                    height: whiteBackgroundHeight,
                    color: const Color(0xFFF9F9F9),
                  ),
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
                        // Filter button (square box) with badge
                        Stack(
                          children: [
                            GestureDetector(
                              onTap: _showFilterDialog,
                              child: Container(
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
                            ),
                            // Active filter badge
                            if (_filterOptions.hasActiveFilters)
                              Positioned(
                                top: 4,
                                right: 4,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFBBE21),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    // Active filters indicator
                    if (_filterOptions.hasActiveFilters) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.filter_alt,
                              color: Color(0xFFFBBE21),
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _buildFilterSummary(),
                                style: const TextStyle(
                                  color: Color(0xFFD8D8D8),
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _filterOptions.clear();
                                });
                                _loadCoffees();
                              },
                              child: const Icon(
                                Icons.close,
                                color: Color(0xFFA2A2A2),
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
                    if (_isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(
                            color: Color(0xFFC67C4E),
                          ),
                        ),
                      )
                    else if (_errorMessage != null)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 48,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Failed to load coffees',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _errorMessage!,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _loadCoffees,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFC67C4E),
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      )
                    else if (_coffeeItems.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Text(
                            'No coffees available',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ),
                      )
                    else
                      ...List.generate((_coffeeItems.length / 2).ceil(), (
                        index,
                      ) {
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
                                  _coffeeItems[leftIndex],
                                ),
                              ),
                              if (rightIndex < _coffeeItems.length) ...[
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildCoffeeCard(
                                    context,
                                    _coffeeItems[rightIndex],
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
