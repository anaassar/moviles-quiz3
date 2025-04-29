import 'package:local_auth/local_auth.dart';

class BiometricHelper {
  static final _auth = LocalAuthentication();
  static bool _isAuthInProgress = false; // Variable para rastrear el estado

  static Future<bool> authenticate() async {
    try {
      // Verificar si ya hay una autenticación en progreso
      if (_isAuthInProgress) {
        print('Autenticación ya en progreso. Ignorando nueva solicitud.');
        return false;
      }

      // Marcar como autenticación en progreso
      _isAuthInProgress = true;

      final canCheck = await _auth.canCheckBiometrics;
      final isDeviceSupported = await _auth.isDeviceSupported();

      if (!canCheck || !isDeviceSupported) {
        _isAuthInProgress = false; // Resetear el estado
        return false;
      }

      final isAuthenticated = await _auth.authenticate(
        localizedReason: 'Usa tu huella o rostro para iniciar sesión',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      _isAuthInProgress = false; // Resetear el estado después de la autenticación
      return isAuthenticated;
    } catch (e) {
      print('Error en autenticación biométrica: $e');
      _isAuthInProgress = false; // Asegurarse de resetear el estado en caso de error
      return false;
    }
  }
}
