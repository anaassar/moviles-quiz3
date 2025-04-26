import 'package:flutter/material.dart';
import 'package:flutter_fingerprint2/views/menu_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnableBiometricView extends StatelessWidget {
  final int userId;

  const EnableBiometricView({super.key, required this.userId});

  Future<void> _saveBiometricPreference(BuildContext context, bool enabled) async {
    final prefs = await SharedPreferences.getInstance();

    if (enabled) {
      await prefs.setBool('biometric_enabled', true);
      await prefs.setInt('user_id', userId);
    }

    // Redirige a la vista principal
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ProfileView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '¿Deseas habilitar el inicio de sesión con datos biométricos?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.white),
                ),
                onPressed: () => _saveBiometricPreference(context, true),
                child: const Text('Sí, habilitar', style: TextStyle(color: Colors.black)),
              ),
              TextButton(
                onPressed: () => _saveBiometricPreference(context, false),
                child: const Text('No, continuar sin biometría', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
