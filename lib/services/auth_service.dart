import 'dart:convert';
import 'package:flutter_fingerprint2/services/local_storage_service.dart';
import 'package:http/http.dart' as http;

class AuthService {
  //static const String baseUrl = 'http://10.0.2.2:3000';
  //static const String baseUrl = 'http://localhost:3000';
  static const String baseUrl = 'https://q3821230-3000.use.devtunnels.ms';

  static Future<Map<String, dynamic>?> login(String nombre, String password) async {
    try {
      final url = Uri.parse('$baseUrl/api/auth/login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'nombre': nombre, 'password': password}),
      );
      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final userId = data['id'];

        await LocalStorageService.saveToken(token);
      await LocalStorageService.saveUserId(userId);

      return {'userId': userId};
      }
      return null;
    } catch (e) {
      print('Error in login: $e');
      return null;
    }
  }

  static Future<bool> biometricLogin(int userId) async {
    try {
      final url = Uri.parse('$baseUrl/biometric-login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error in biometricLogin: $e');
      return false;
    }
  }
}

