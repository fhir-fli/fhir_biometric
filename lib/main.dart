import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

final LocalAuthentication auth = LocalAuthentication();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
  final bool canAuthenticate =
      canAuthenticateWithBiometrics || await auth.isDeviceSupported();
  final List<BiometricType> biometrics = await auth.getAvailableBiometrics();
  print(canAuthenticate);
  print(biometrics);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(home: MyHomePage());
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: () async {
                  try {
                    final bool didAuthenticate = await auth.authenticate(
                        localizedReason: 'Please authenticate to login');
                  } catch (e, s) {
                    print(e);
                    print(s);
                  }
                },
                child: const Text('Press to Authenticate'),
              ),
            ],
          ),
        ),
      );
}
