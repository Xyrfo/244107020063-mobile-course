import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../routes.dart';

final localNotifications = FlutterLocalNotificationsPlugin();
String? pendingDeepLink;

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Background isolate tidak boleh mengakses BuildContext atau router.
  pendingDeepLink = routeFromMessage(message.data);
}

class PushService {
  PushService({FirebaseMessaging? messaging, FlutterLocalNotificationsPlugin? local})
      : _messaging = messaging ?? FirebaseMessaging.instance,
        _local = local ?? localNotifications;

  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _local;

  Future<void> initialize({required void Function(String route) onRoute}) async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await _initializeLocal(onRoute);
    await requestPermission();
    await _listenMessages(onRoute);
  }

  Future<AuthorizationStatus> requestPermission() async {
    final settings = await _messaging.requestPermission(alert: true, badge: true, sound: true);
    return settings.authorizationStatus;
  }

  Future<String?> getToken() => _messaging.getToken();

  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  Future<void> subscribeToCampusTopic() => _messaging.subscribeToTopic('pengumuman-kampus');

  Future<void> unsubscribeFromCampusTopic() => _messaging.unsubscribeFromTopic('pengumuman-kampus');

  Future<void> handleTerminated(void Function(String route) onRoute) async {
    final message = await _messaging.getInitialMessage();
    if (message != null) onRoute(routeFromMessage(message.data));
    if (pendingDeepLink != null) onRoute(pendingDeepLink!);
    pendingDeepLink = null;
  }

  Future<void> _initializeLocal(void Function(String route) onRoute) async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _local.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        final route = response.payload;
        if (route != null) onRoute(route);
      },
    );
  }

  Future<void> _listenMessages(void Function(String route) onRoute) async {
    FirebaseMessaging.onMessage.listen((message) async {
      const details = AndroidNotificationDetails(
        'pengumuman',
        'Pengumuman Kampus',
        channelDescription: 'Notifikasi pengumuman kampus',
        importance: Importance.high,
        priority: Priority.high,
      );
      await _local.show(
        message.hashCode,
        message.notification?.title ?? 'Pengumuman kampus',
        message.notification?.body ?? 'Ada pengumuman baru.',
        const NotificationDetails(android: details),
        payload: routeFromMessage(message.data),
      );
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      onRoute(routeFromMessage(message.data));
    });
  }
}
