import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:agroconnect/route/route_constants.dart'; // Adjust this to your project structure

class AppStart extends StatefulWidget {
  const AppStart({Key? key}) : super(key: key);

  @override
  State<AppStart> createState() => _AppStartState();
}

class _AppStartState extends State<AppStart> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    String? sessionToken = await secureStorage.read(key: 'sessionToken');

    if (sessionToken != null && sessionToken.isNotEmpty) {
      // Navigate to home screen
      Navigator.pushReplacementNamed(context, entryPointScreenRoute);
    } else {
      // Navigate to login screen
      Navigator.pushReplacementNamed(context, logInSelectionScreenRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show a splash/loading indicator while checking
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.green,
        ),
      ),
    );
  }
}
