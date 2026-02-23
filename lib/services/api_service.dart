import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/coffee_item.dart';
import '../config/api_config.dart';

class ApiService {
  // GET /api/coffees - Get all coffees with optional filters
  Future<List<CoffeeItem>> getAllCoffees({
    String? search,
    String? typeFilter,
    double? minPrice,
    double? maxPrice,
    String? sort,
    String? order,
    int? page,
    int? limit,
  }) async {
    try {
      // Build query parameters
      final queryParams = <String, String>{};

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      if (typeFilter != null && typeFilter.isNotEmpty) {
        queryParams['type_filter'] = typeFilter;
      }
      if (minPrice != null) {
        queryParams['min_price'] = minPrice.toString();
      }
      if (maxPrice != null) {
        queryParams['max_price'] = maxPrice.toString();
      }
      if (sort != null && sort.isNotEmpty) {
        queryParams['sort'] = sort;
      }
      if (order != null && order.isNotEmpty) {
        queryParams['order'] = order;
      }
      if (page != null) {
        queryParams['page'] = page.toString();
      }
      if (limit != null) {
        queryParams['limit'] = limit.toString();
      }

      final uri = Uri.parse(
        '${ApiConfig.baseUrl}/api/coffees',
      ).replace(queryParameters: queryParams.isEmpty ? null : queryParams);

      print('Fetching coffees from: $uri');

      final response = await http
          .get(uri, headers: {'Content-Type': 'application/json'})
          .timeout(ApiConfig.timeout);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        final coffees = jsonList
            .map((json) => CoffeeItem.fromJson(json))
            .toList();
        print('Successfully parsed ${coffees.length} coffees');
        return coffees;
      } else {
        throw Exception('Failed to load coffees: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getAllCoffees: $e');
      rethrow;
    }
  }

  // GET /api/coffees/{id} - Get coffee by ID
  Future<CoffeeItem> getCoffeeById(int id) async {
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConfig.baseUrl}/api/coffees/$id'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        return CoffeeItem.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load coffee: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching coffee: $e');
    }
  }

  // POST /api/coffees - Create a new coffee
  Future<CoffeeItem> createCoffee(CoffeeItem coffee) async {
    try {
      final response = await http
          .post(
            Uri.parse('${ApiConfig.baseUrl}/api/coffees'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(coffee.toJson()),
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 201) {
        return CoffeeItem.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to create coffee: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating coffee: $e');
    }
  }

  // PUT /api/coffees/{id} - Update a coffee
  Future<CoffeeItem> updateCoffee(int id, CoffeeItem coffee) async {
    try {
      final response = await http
          .put(
            Uri.parse('${ApiConfig.baseUrl}/api/coffees/$id'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(coffee.toJson()),
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        return CoffeeItem.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update coffee: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating coffee: $e');
    }
  }

  // DELETE /api/coffees/{id} - Delete a coffee
  Future<void> deleteCoffee(int id) async {
    try {
      final response = await http
          .delete(
            Uri.parse('${ApiConfig.baseUrl}/api/coffees/$id'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode != 204) {
        throw Exception('Failed to delete coffee: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting coffee: $e');
    }
  }
}
