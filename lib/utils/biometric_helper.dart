import 'package:local_auth/local_auth.dart';

class BiometricHelper {
  static final _auth = LocalAuthentication();

  static Future<bool> authenticate() async {
  try {
    final canCheck = await _auth.canCheckBiometrics;
    final isDeviceSupported = await _auth.isDeviceSupported();

    print('Puede chequear biometría: $canCheck');
    print('Dispositivo soportado: $isDeviceSupported');

    if (!canCheck || !isDeviceSupported) return false;

    return await _auth.authenticate(
      localizedReason: 'Usa tu huella o rostro para iniciar sesión',
      options: const AuthenticationOptions(
        biometricOnly: true,
        stickyAuth: true,
      ),
    );
  } catch (e) {
    print('Error en autenticación biométrica: $e');
    return false;
  }
}

}
