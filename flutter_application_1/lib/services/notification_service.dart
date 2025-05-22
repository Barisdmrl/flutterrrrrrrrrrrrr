import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

/// Bildirim türleri
enum NotificationType {
  message,
  newProduct,
  offerReceived,
  offerAccepted,
  offerRejected,
  swapCompleted,
  productInterest,
  system,
}

/// Uygulama içinde bildirimleri yönetmek için servis sınıfı
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  
  factory NotificationService() {
    return _instance;
  }
  
  NotificationService._internal();
  
  Future<void> initialize(BuildContext context) async {
    try {
      // Initialize timezone data for scheduled notifications
      tz_data.initializeTimeZones();
      
      // Android initialization settings
      final AndroidInitializationSettings androidSettings = 
          AndroidInitializationSettings('@mipmap/ic_launcher');
      
      // iOS initialization settings
      final DarwinInitializationSettings iOSSettings = 
          DarwinInitializationSettings(
            requestSoundPermission: true,
            requestBadgePermission: true,
            requestAlertPermission: true,
          );
      
      // Initialize settings for both platforms
      final InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iOSSettings,
      );
      
      // Initialize the plugin with settings
      await _notificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );
      
      // Create notification channels for Android
      await _createNotificationChannels(context);
      
      // Request permissions
      await _requestPermissions();
      
      debugPrint('Notification service initialized successfully');
    } catch (e) {
      debugPrint('Error initializing notification service: $e');
    }
  }
  
  Future<void> _requestPermissions() async {
    try {
      // Request permissions for iOS
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
          
      // Request permissions for Android (for Android 13+)
      // Note: for Flutter Local Notifications 19.1.0+, we need to use requestNotificationsPermission
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    } catch (e) {
      debugPrint('Error requesting notification permissions: $e');
    }
  }
  
  Future<void> _createNotificationChannels(BuildContext context) async {
    try {
      // Only required for Android 8.0+
      if (Theme.of(context).platform == TargetPlatform.android) {
        // Create channels for different notification types
        await _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(
              const AndroidNotificationChannel(
                'messages_channel', // id
                'Messages', // name
                description: 'Notifications for new messages', // description
                importance: Importance.high,
              ),
            );
        
        await _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(
              const AndroidNotificationChannel(
                'products_channel', // id
                'New Products', // name
                description: 'Notifications for new products', // description
                importance: Importance.high,
              ),
            );
        
        await _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(
              const AndroidNotificationChannel(
                'offers_channel', // id
                'Swap Offers', // name
                description: 'Notifications for swap offers', // description
                importance: Importance.high,
              ),
            );
            
        await _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(
              const AndroidNotificationChannel(
                'system_channel', // id
                'System', // name
                description: 'System notifications', // description
                importance: Importance.high,
              ),
            );
      }
    } catch (e) {
      debugPrint('Error creating notification channels: $e');
    }
  }
  
  // Handle notification taps
  void _onNotificationTapped(NotificationResponse response) {
    try {
      final String? payload = response.payload;
      debugPrint('Notification tapped with payload: $payload');
      
      if (payload != null && payload.isNotEmpty) {
        // Parse the payload and navigate accordingly
        final Map<String, dynamic> data = _parsePayload(payload);
        _handleNotificationNavigation(data);
      }
    } catch (e) {
      debugPrint('Error handling notification tap: $e');
    }
  }
  
  Map<String, dynamic> _parsePayload(String payload) {
    try {
      // Simple parsing based on comma-separated values
      final List<String> pairs = payload.split(',');
      final Map<String, dynamic> result = {};
      
      for (final pair in pairs) {
        final List<String> keyValue = pair.split(':');
        if (keyValue.length == 2) {
          result[keyValue[0].trim()] = keyValue[1].trim();
        }
      }
      
      return result;
    } catch (e) {
      debugPrint('Error parsing notification payload: $e');
      return {};
    }
  }
  
  void _handleNotificationNavigation(Map<String, dynamic> data) {
    // Implementation would depend on your app's navigation system
    // This is where you would navigate to the appropriate screen based on the notification type
    
    // For example:
    final String? type = data['type'];
    final String? id = data['id'];
    
    if (type == 'message' && id != null) {
      // Navigate to chat screen with the given ID
      // Navigator.pushNamed(context, '/chat', arguments: id);
      debugPrint('Should navigate to chat with ID: $id');
    } else if (type == 'product' && id != null) {
      // Navigate to product details
      // Navigator.pushNamed(context, '/product', arguments: id);
      debugPrint('Should navigate to product with ID: $id');
    } else if (type == 'offer' && id != null) {
      // Navigate to offer details
      // Navigator.pushNamed(context, '/offer', arguments: id);
      debugPrint('Should navigate to offer with ID: $id');
    }
  }
  
  // Get channel name based on notification type
  String _getChannelName(NotificationType type) {
    switch (type) {
      case NotificationType.message:
        return 'Messages';
      case NotificationType.newProduct:
        return 'New Products';
      case NotificationType.offerReceived:
      case NotificationType.offerAccepted:
      case NotificationType.offerRejected:
      case NotificationType.swapCompleted:
        return 'Swap Offers';
      case NotificationType.productInterest:
        return 'Product Interest';
      case NotificationType.system:
        return 'System';
    }
  }
  
  // Get channel ID based on notification type
  String _getChannelId(NotificationType type) {
    switch (type) {
      case NotificationType.message:
        return 'messages_channel';
      case NotificationType.newProduct:
      case NotificationType.productInterest:
        return 'products_channel';
      case NotificationType.offerReceived:
      case NotificationType.offerAccepted:
      case NotificationType.offerRejected:
      case NotificationType.swapCompleted:
        return 'offers_channel';
      case NotificationType.system:
        return 'system_channel';
    }
  }
  
  // Show a local notification immediately
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    NotificationType type = NotificationType.message,
  }) async {
    try {
      // Get channel ID based on notification type
      String channelId = _getChannelId(type);
      
      // Configure notification details
      final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        channelId,
        _getChannelName(type),
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );
      
      final DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );
      
      final NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iOSDetails,
      );
      
      // Show the notification
      await _notificationsPlugin.show(
        id,
        title,
        body,
        notificationDetails,
        payload: payload,
      );
      
      debugPrint('Notification shown successfully');
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }
  
  // Schedule a notification for a future time
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
    NotificationType type = NotificationType.message,
  }) async {
    try {
      // Get channel ID based on notification type
      String channelId = _getChannelId(type);
      
      // Configure notification details
      final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        channelId,
        _getChannelName(type),
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      );
      
      final DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );
      
      final NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iOSDetails,
      );
      
      // Convert DateTime to TZDateTime
      final tz.TZDateTime tzDateTime = tz.TZDateTime.from(scheduledDate, tz.local);
      
      // Schedule the notification
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzDateTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
      );
      
      debugPrint('Notification scheduled successfully for $scheduledDate');
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
    }
  }
  
  // Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    try {
      await _notificationsPlugin.cancel(id);
      debugPrint('Notification with ID $id cancelled');
    } catch (e) {
      debugPrint('Error cancelling notification: $e');
    }
  }
  
  // Cancel all notifications
  Future<void> cancelAllNotifications() async {
    try {
      await _notificationsPlugin.cancelAll();
      debugPrint('All notifications cancelled');
    } catch (e) {
      debugPrint('Error cancelling all notifications: $e');
    }
  }
}

// Global variable for debug context - set this in your main.dart
BuildContext? debugBuildContext; 