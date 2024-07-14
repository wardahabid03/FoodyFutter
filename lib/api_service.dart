import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://tastyworld.p.rapidapi.com/v1/suggest_recipe';
  static const String _apiKey = '75a906eec4mshfa76a48f6af1a32p13482djsnff1637a4030a';
  static const String _apiHost = 'tastyworld.p.rapidapi.com';

  Future<Map<String, dynamic>> fetchRecipes(String ingredients) async {
    final response = await http.get(
      Uri.parse('$_baseUrl?ingredients=$ingredients&limit=10'),
      headers: {
        'x-rapidapi-key': _apiKey,
        'x-rapidapi-host': _apiHost,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load recipes');
    }
  }
}
