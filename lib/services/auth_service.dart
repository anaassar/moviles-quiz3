import 'dart:convert';
import 'package:flutter_fingerprint2/services/local_storage_service.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl =
      'https://q3821230-3000.use.devtunnels.ms/api/auth'; // ← pon aquí tu URL correcta

  static Future<Map<String, dynamic>?> login(String nombre, String password) async {
    try {
      
      final url = Uri.parse('$baseUrl/login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'nombre': nombre, 'password': password}),
      );
      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'token': data['token'], 'userId': data['id']};
      } else {
        return null;
      }
    } catch (e) {
      print('Error en login: $e');
      return null;
    }
  }

  static Future<bool> biometricLogin(
    int userId,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/biometric-login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final tokenLargo = data['token'];

        // Guardar nuevo token largo
        await LocalStorageService.saveToken(tokenLargo);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error en biometricEnable: $e');
      return false;
    }
  }
}
