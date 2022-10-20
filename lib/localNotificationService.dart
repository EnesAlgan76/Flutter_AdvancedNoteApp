import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class LocalNotificationService{
  LocalNotificationService();

  final localNotificationService = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async{
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidInitializationSettings =AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings,
    );
    await localNotificationService.initialize(settings);
  }
  Future<NotificationDetails> notificationDetails()async{
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          "channelId",
          "channelName",
          channelDescription: "description",
          importance: Importance.max,
          playSound: true,
        );
    return NotificationDetails(android: androidNotificationDetails);
  }
  Future<void> showNotification({required int id, required String title, required String body})async{
    final details = await notificationDetails();
    await localNotificationService.show(id, title, body, details);
  }
  Future<void> showScheduledNotification({required int id, required String title, required String body, required DateTime dateTime})async{
    final details = await notificationDetails();
    await localNotificationService.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(dateTime, tz.local),
        details,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true
    );
  }



  void onDidReceiveLocalNotification(int id, String? title, String? body, String? payload){
    print("id = ${id}");
  }



  void onSelectedNotification(String? payload){
    print("payload : ${payload}");
  }

}