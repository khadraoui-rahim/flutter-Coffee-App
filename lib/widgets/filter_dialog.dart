import 'package:flutter/material.dart';

class FilterOptions {
  String? searchTerm;
  String? coffeeType;
  double? minPrice;
  double? maxPrice;
  String? sortBy;
  String? sortOrder;

  FilterOptions({
    this.searchTerm,
    this.coffeeType,
    this.minPrice,
    this.maxPrice,
    this.sortBy,
    this.sortOrder,
  });

  bool get hasActiveFilters =>
      searchTerm != null ||
      coffeeType != null ||
      minPrice != null ||
      maxPrice != null ||
      sortBy != null;

  void clear() {
    searchTerm = null;
    coffeeType = null;
    minPrice = null;
    maxPrice = null;
    sortBy = null;
    sortOrder = null;
  }

  FilterOptions copyWith({
    String? searchTerm,
    String? coffeeType,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    String? sortOrder,
  }) {
    return FilterOptions(
      searchTerm: searchTerm ?? this.searchTerm,
      coffeeType: coffeeType ?? this.coffeeType,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

class FilterDialog extends StatefulWidget {
  final FilterOptions initialFilters;

  const FilterDialog({super.key, required this.initialFilters});

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late TextEditingController _searchController;
  late TextEditingController _minPriceController;
  late TextEditingController _maxPriceController;

  String? _selectedType;
  String? _selectedSort;
  String? _selectedOrder;

  final List<String> _coffeeTypes = [
    'Espresso',
    'Latte',
    'Cappuccino',
    'Americano',
    'Machiato',
    'Mocha',
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: widget.initialFilters.searchTerm,
    );
    _minPriceController = TextEditingController(
      text: widget.initialFilters.minPrice?.toString() ?? '',
    );
    _maxPriceController = TextEditingController(
      text: widget.initialFilters.maxPrice?.toString() ?? '',
    );
    _selectedType = widget.initialFilters.coffeeType;
    _selectedSort = widget.initialFilters.sortBy;
    _selectedOrder = widget.initialFilters.sortOrder;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final filters = FilterOptions(
      searchTerm: _searchController.text.trim().isEmpty
          ? null
          : _searchController.text.trim(),
      coffeeType: _selectedType,
      minPrice: _minPriceController.text.trim().isEmpty
          ? null
          : double.tryParse(_minPriceController.text.trim()),
      maxPrice: _maxPriceController.text.trim().isEmpty
          ? null
          : double.tryParse(_maxPriceController.text.trim()),
      sortBy: _selectedSort,
      sortOrder: _selectedOrder,
    );
    Navigator.pop(context, filters);
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _minPriceController.clear();
      _maxPriceController.clear();
      _selectedType = null;
      _selectedSort = null;
      _selectedOrder = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFC67C4E),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filter Coffee',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search
                    _buildSectionTitle('Search'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _searchController,
                      hint: 'Search by name...',
                      icon: Icons.search,
                    ),
                    const SizedBox(height: 20),

                    // Coffee Type
                    _buildSectionTitle('Coffee Type'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _coffeeTypes.map((type) {
                        final isSelected = _selectedType == type;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedType = isSelected ? null : type;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFC67C4E)
                                  : const Color(0xFFF9F9F9),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFFC67C4E)
                                    : const Color(0xFFE0E0E0),
                              ),
                            ),
                            child: Text(
                              type,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF2F2D2C),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Price Range
                    _buildSectionTitle('Price Range'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _minPriceController,
                            hint: 'Min',
                            icon: Icons.attach_money,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            'to',
                            style: TextStyle(
                              color: Color(0xFF9B9B9B),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(
                          child: _buildTextField(
                            controller: _maxPriceController,
                            hint: 'Max',
                            icon: Icons.attach_money,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Sort By
                    _buildSectionTitle('Sort By'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: _buildSortOption('Price', 'price')),
                        const SizedBox(width: 12),
                        Expanded(child: _buildSortOption('Rating', 'rating')),
                      ],
                    ),

                    // Sort Order (only show if sort is selected)
                    if (_selectedSort != null) ...[
                      const SizedBox(height: 16),
                      _buildSectionTitle('Order'),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildOrderOption(
                              'Ascending',
                              'asc',
                              Icons.arrow_upward,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildOrderOption(
                              'Descending',
                              'desc',
                              Icons.arrow_downward,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            // Footer buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9F9),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _clearFilters,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Color(0xFFC67C4E)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Clear',
                        style: TextStyle(
                          color: Color(0xFFC67C4E),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _applyFilters,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFFC67C4E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Apply',
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF2F2D2C),
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFA2A2A2), fontSize: 14),
          prefixIcon: Icon(icon, color: const Color(0xFFA2A2A2), size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildSortOption(String label, String value) {
    final isSelected = _selectedSort == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_selectedSort == value) {
            _selectedSort = null;
            _selectedOrder = null;
          } else {
            _selectedSort = value;
            // Set default order based on sort field
            _selectedOrder = value == 'price' ? 'asc' : 'desc';
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFC67C4E) : const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFC67C4E)
                : const Color(0xFFE0E0E0),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF2F2D2C),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderOption(String label, String value, IconData icon) {
    final isSelected = _selectedOrder == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOrder = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFC67C4E) : const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFC67C4E)
                : const Color(0xFFE0E0E0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : const Color(0xFF2F2D2C),
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF2F2D2C),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
