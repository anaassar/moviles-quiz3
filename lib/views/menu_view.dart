import 'package:flutter/material.dart';
import 'package:flutter_fingerprint2/services/local_storage_service.dart';
import 'package:flutter_fingerprint2/views/articulos_view.dart';
import 'package:flutter_fingerprint2/views/login_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool _biometricEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadBiometricStatus();
  }

  Future<void> _loadBiometricStatus() async {
    final enabled = await LocalStorageService.isBiometricEnabled();
    setState(() {
      _biometricEnabled = enabled;
    });
  }

  Future<void> _toggleBiometrics(BuildContext context) async {
    if (_biometricEnabled) {
      await LocalStorageService.clearBiometricPreference();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Biometría deshabilitada')));
    } else {
      await LocalStorageService.setBiometricEnabled(true);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Biometría habilitada')));
    }

    setState(() {
      _biometricEnabled = !_biometricEnabled;
    });
  }

  Future<void> _logout(BuildContext context) async {
    await LocalStorageService.clearSession();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginView()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: Colors.white,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Menú Principal",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            side: BorderSide(width: 3),
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(30),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ListaArticulos(),
                              ),
                            );
                          },
                          child: Icon(
                            Icons.shopping_cart,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Artículos",
                          style: TextStyle(color: Colors.blue, fontSize: 20),
                        ),
                        SizedBox(height: 20),
                        _buildButton(
                          "Ofertas",
                          Icons.local_offer,
                          Colors.redAccent,

                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        const ListaArticulos(soloOfertas: true),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:  _biometricEnabled
                      ? Colors.red
                      : Colors.green,
                ),
                onPressed: () => _toggleBiometrics(context),
                child: Text(
                  _biometricEnabled
                      ? 'Deshabilitar biometría'
                      : 'Habilitar biometría',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _logout(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                child: const Text('Cerrar sesión', 
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildButton(String text, IconData icon, Color color, Function()? onPressed) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            side: BorderSide(width: 3),
            shape: CircleBorder(),
            padding: EdgeInsets.all(30),
          ),
          onPressed: () {
            onPressed!();
          },
          child: Icon(icon, size: 50, color: Colors.white),
        ),
        Text(text, style: TextStyle(color: color, fontSize: 20)),
      ],
    );
  }
}
