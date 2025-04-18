import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:5022/api'; // với Android emulator dùng 10.0.2.2

  static Future<List<dynamic>> getAccounts() async {
    final response = await http.get(Uri.parse('$baseUrl/Account'), headers: {
      "Accept": "application/json"
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load accounts');
    }
  }

  static Future<bool> createAccount(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Account'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    return response.statusCode == 201;
  }
}
