import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';

class BiometricAuth {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> get canUseBiometrics async => auth.canCheckBiometrics;

  Future<bool> get isDeviceSupported async => auth.isDeviceSupported();

  Future<bool> get biometricsAvailable async =>
      await canUseBiometrics || await auth.isDeviceSupported();

  Future<List<BiometricType>> get biometricTypes async =>
      auth.getAvailableBiometrics();

  Future<String> login() async {
    if (await biometricsAvailable) {
      try {
        final bool success = await auth.authenticate(
          localizedReason: 'Authenticate using your fingerprint',
          options: const AuthenticationOptions(
            stickyAuth: true,
          ),
        );
        if (success) {
          return 'true';
        } else {
          return 'Unsuccessful';
        }
      } on PlatformException catch (e) {
        if (e.code == auth_error.notAvailable) {
          return 'Biometrics not available, please choose another option';
        } else if (e.code == auth_error.notEnrolled) {
          return 'Biometrics not enrolled. Please choose another option, '
              'or enroll Biometrics and then try again.';
        } else {
          return 'Error trying to login. $e';
        }
      }
    } else {
      return 'Biometrics not available';
    }
  }
}
