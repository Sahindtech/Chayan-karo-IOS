import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// -----------------------------------------------------------------------------
// BACKGROUND HANDLER (Top-level)
// -----------------------------------------------------------------------------
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Background message ID: ${message.messageId}");
}

class NotificationService {
  // Singleton Pattern
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  final AndroidNotificationChannel _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel_v2', 
    'High Importance Notifications', 
    description: 'This channel is used for important notifications.',
    importance: Importance.max, 
    playSound: true,
  );

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      // 1. Request Permissions (This triggers the Apple Pop-up!)
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission');

        // 🔥 FIX: Removed the "Free Account Escape Hatch" here.
        // We let Firebase handle the APNs token automatically in the background.
        print("APNS TOKEN: ${await _firebaseMessaging.getAPNSToken()}");

        // 2. Get the FCM Token
        String? token = await _firebaseMessaging.getToken();
        print("========================================");
        print("FCM TOKEN: $token");
        print("========================================");
        
        // 3. Setup Local Notifications (For foreground pop-ups)
        await _setupLocalNotifications();

        // 4. Register Background Handler
        FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

        // 5. Handle Foreground Messages (When app is open)
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          // iOS 10+ handles foreground presentation automatically if configured properly,
          // but flutter_local_notifications ensures it shows up customized.
          _showForegroundNotification(message);
        });

        // 6. Handle Taps
        FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
        
        // 7. Check if app was opened from terminated state
        final initialMessage = await _firebaseMessaging.getInitialMessage();
        if (initialMessage != null) {
          _handleNotificationTap(initialMessage);
        }

      } else {
        print("User declined notification permissions.");
      }
      
      _isInitialized = true;
      
    } catch (e) {
      print("🚨 CRITICAL ERROR in NotificationService init: $e");
      _isInitialized = true; 
    }
  }

  Future<void> _setupLocalNotifications() async {
    if (Platform.isAndroid) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(_androidChannel);
    }

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // IMPORTANT: Request permissions for local notifications on iOS
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
    );

    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print("Foreground Local Notification Tapped: ${response.payload}");
      },
    );
    
    // 🔥 NEW FIX: Force iOS to show foreground notifications natively
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true, 
      badge: true, 
      sound: true,
    );
  }

  void _showForegroundNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;

    if (notification != null) {
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: '@mipmap/ic_launcher',
            importance: Importance.max, 
            priority: Priority.high,    
            playSound: true,
          ),
          // iOS settings for the local notification package
          iOS: const DarwinNotificationDetails(
             presentAlert: true,
             presentBadge: true,
             presentSound: true,
          ),
        ),
        payload: message.data.toString(),
      );
    }
  }

  void _handleNotificationTap(RemoteMessage message) {
    print("Notification Tapped. Payload: ${message.data}");
  }

  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }
}