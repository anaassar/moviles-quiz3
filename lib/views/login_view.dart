import 'package:flutter/material.dart';
import 'package:flutter_fingerprint2/services/auth_service.dart';
import 'package:flutter_fingerprint2/services/local_storage_service.dart';
import 'package:flutter_fingerprint2/utils/biometric_helper.dart';
import 'package:flutter_fingerprint2/views/biometric_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool biometricEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadBiometricStatus();
  }

  Future<void> _loadBiometricStatus() async {
    final enabled = await LocalStorageService.isBiometricEnabled();
    setState(() {
      biometricEnabled = enabled;
    });
  }

Future<void> _login() async {
  final username = _usernameController.text.trim();
  final password = _passwordController.text.trim();

  final result = await AuthService.login(username, password);

  if (result != null) {
    final userId = result['userId'];

    await LocalStorageService.saveToken(result['token']);
    await LocalStorageService.saveUserId(userId);

    if (biometricEnabled) {
      final authenticated = await BiometricHelper.authenticate();
      if (authenticated) {
        final success = await AuthService.biometricLogin(userId);
        if (success) {
          await LocalStorageService.saveUsername(username);
          await LocalStorageService.savePassword(password);
          Navigator.pushReplacementNamed(context, '/profile');
        } else {
          _showError('Error al obtener token biométrico');
        }
      } else {
        _showError('Autenticación biométrica fallida');
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EnableBiometricView(
            userId: userId,
            username: username,
            password: password,
          ),
        ),
      );
    }
  } else {
    _showError('Credenciales incorrectas');
  }
}


  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Usuario'),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Contraseña'),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.deepPurple),
                  ),
                  onPressed: _login,
                  child: const Text(
                    'Iniciar sesión',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                if (biometricEnabled)
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                    ),
                    onPressed: () {
                      _login();
                    },
                    child: const Text(
                      'Usar biometría',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
