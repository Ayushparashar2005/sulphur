import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vibration/vibration.dart';

class AlarmService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings =
        InitializationSettings(android: androidInit);

    await _notificationsPlugin.initialize(initSettings);
  }

  Future<void> triggerAlarm() async {
    // Vibrate device
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 3000);
    }

    // Play alarm sound
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'alarm_channel',
      'Wake-Up Alarm',
      importance: Importance.high,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('alarm_sound'),
      playSound: true,
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
        0, "Wake Up!", "You're 5 minutes away from your stop!", details);
  }
}
