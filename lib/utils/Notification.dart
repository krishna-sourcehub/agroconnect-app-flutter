import 'package:agroconnect/screens/auth/views/auth_management.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // 🔐 Request permissions (required for iOS & Android 13+)
    NotificationSettings settings = await _messaging.requestPermission(
      carPlay: true,
      criticalAlert: true,
      sound: true,
      announcement: true,
      badge: true,
      alert: true,
      provisional: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('✅ User granted notification permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      debugPrint('❌ User denied notification permission');
    } else {
      debugPrint('⚠️ Notification permission status: ${settings.authorizationStatus}');
    }

    // 🔧 Initialize flutter_local_notifications
    const AndroidInitializationSettings androidInitSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
    );

    await _localNotificationsPlugin.initialize(initSettings);

    // 🔔 Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('📥 Foreground notification received: ${message.notification?.title}');

      if (message.notification != null && message.notification!.android != null) {
        _localNotificationsPlugin.show(
          message.notification.hashCode,
          message.notification!.title,
          message.notification!.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'default_channel',
              'Default Channel',
              channelDescription: 'This is the default notification channel',
              importance: Importance.max,
              priority: Priority.high,
              showWhen: true,
            ),
          ),
        );
      }
    });

    // 🪪 (Optional) Get token to use on backend
    String? token = await _messaging.getToken();
    debugPrint('📲 FCM Token: $token');
    await secureStorage.write(key: "deviceToken", value: token);
  }
}





// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
//
// class NotificationService {
//   final FirebaseMessaging _messaging = FirebaseMessaging.instance;
//
//   Future<void> init() async {
//     // 🔐 Request permissions (required for iOS & Android 13+)
//     NotificationSettings settings = await _messaging.requestPermission(
//       carPlay: true,
//       criticalAlert: true,
//       sound: true,
//       announcement: true,
//       badge: true,
//       alert: true,
//       provisional: true,
//     );
//
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       debugPrint('✅ User granted notification permission');
//     } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
//       debugPrint('❌ User denied notification permission');
//     } else {
//       debugPrint('⚠️ Notification permission status: ${settings.authorizationStatus}');
//     }
//
//     // 📱 Optional: Get the device token for sending push notifications
//     String? token = await _messaging.getToken();
//     debugPrint('📲 FCM Token: $token');
//
//     // 🔔 Optional: Listen to foreground messages
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       debugPrint('📥 Foreground notification received: ${message.notification?.title}');
//     });
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       if (message.notification != null) {
//         print("📥 Foreground Notification Received: ${message.notification?.title}");
//
//         // Show a local notification using flutter_local_notifications package
//         // Or you can show a Snackbar/Dialog, etc.
//       }
//     });
//
//   }
// }
//
//
//
//
//
//
// // import 'package:firebase_messaging/firebase_messaging.dart';
// //
// // class NotificationService {
// //   final FirebaseMessaging _messaging = FirebaseMessaging.instance;
// //
// //   Future<void> init() async {
// //     // iOS and Android 13+ need explicit permission
// //     NotificationSettings settings = await _messaging.requestPermission(
// //       carPlay: true,
// //       criticalAlert: true,
// //       sound: true,
// //       announcement: true,
// //       badge: true,
// //       alert: true,
// //       provisional: true,
// //     );
// //
// //     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
// //       print('✅ User granted permission');
// //     } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
// //       print('❌ User denied permission');
// //     } else {
// //       print('⚠️ Permission not determined');
// //     }
// //
// //     // Optional: Get token for this device
// //     String? token = await _messaging.getToken();
// //     print("FCM Token: $token");
// //   }
// // }
