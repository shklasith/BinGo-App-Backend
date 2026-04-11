import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/app_constants.dart';

class ApiService {
  final String baseUrl = AppConstants.baseUrl;

  // Example: POST request
  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('API Error: ${response.body}');
    }
  }

  // Example: GET request
  Future<Map<String, dynamic>> get(String endpoint) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('API Error: ${response.body}');
    }
  }
}