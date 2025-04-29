import 'package:flutter/material.dart';
import 'package:flutter_fingerprint2/services/auth_service.dart';
import 'package:flutter_fingerprint2/services/local_storage_service.dart';
import 'package:flutter_fingerprint2/utils/biometric_helper.dart';

class EnableBiometricView extends StatelessWidget {
  final int userId;
  final String username;
  final String password;


  const EnableBiometricView({super.key, required this.userId, required this.username, required this.password});

  Future<void> _enableBiometrics(BuildContext context) async {
    final authenticated = await BiometricHelper.authenticate();
    if (authenticated) {
      await LocalStorageService.setBiometricEnabled(true);

      final userId = await LocalStorageService.getUserId();

      if (userId != null) {
        final success = await AuthService.biometricLogin(userId);

        if (success) {
          await LocalStorageService.saveUsername(username);
          await LocalStorageService.savePassword(password);
          await LocalStorageService.setBiometricEnabled(true);
          Navigator.pushReplacementNamed(context, '/profile');
        } else {
          await LocalStorageService.setBiometricEnabled(false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al obtener token biométrico')),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Falló autenticación biométrica')));
    }
  }

  Future<void> _skipBiometrics(BuildContext context) async {
    await LocalStorageService.setBiometricEnabled(false);

    // No se pide nada más, ya tienes el token corto que usarás como si fuera largo
    Navigator.pushReplacementNamed(context, '/profile');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('¿Deseas habilitar inicio de sesión con biometría?', style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () => _enableBiometrics(context),
                child: Text('Sí, habilitar', style: TextStyle(color: Colors.white),),
              ),
              TextButton(
                onPressed: () => _skipBiometrics(context),
                child: Text('No, continuar sin biometría', style: TextStyle(color: Colors.red),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
