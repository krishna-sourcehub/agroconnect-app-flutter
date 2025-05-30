import 'package:agroconnect/route/route_constants.dart';
import 'package:agroconnect/route/router.dart' as router;
import 'package:agroconnect/route/screen_export.dart';
import 'package:agroconnect/screens/auth/views/password_recovery.dart';
import 'package:agroconnect/screens/userdata/address/user_address_screen.dart';
import 'package:agroconnect/screens/userdata/user_data_screen.dart';
import 'package:agroconnect/theme/app_theme.dart';
import 'package:agroconnect/thumbnail_service.dart';
import 'package:agroconnect/utils/Notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ REQUIRED
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService().init(); // Initialize notifications
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  final VideoService videoService = VideoService();
  videoService.requestPermissions();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AgroConnect',
      theme: AppTheme.lightTheme(context),
      themeMode: ThemeMode.light,
      // routes: {
      //   '/': (context) => const AppStart(),
      // },
      // home:GetupiidScreen(),
      onGenerateRoute: router.generateRoute,
      initialRoute: '/',
      // home: ProfileScreen(),
    // initialRoute: entryPointScreenRoute,
    //   initialRoute: logInSelectionScreenRoute,
    //   home: GetupiidScreen()
    );

  }
}
