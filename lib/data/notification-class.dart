import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:thank_book/main.dart';
import 'package:thank_book/routes/notification-receiver.dart';
import 'package:thank_book/routes/thank-form.dart';
import 'package:http/http.dart' as http;

/* import ကတော့ လုပ်တာပဲ မို့လား ၊ ဒါပေမယ့် ဒီကောင်တွေက တစ်မျိုး static လည်း ကြေညာထားတာ မရှိပါပဲ ဟိုဘက် မှာ initizlize လုပ်ထားမှ ဒီဘက်မှာ သုံးလို့ရတာမျိုး , TimeZone noted */
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationClass {

  BuildContext context;
  NotificationClass(this.context){
    print("notificationClass constructor");
    _requestPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }

  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body)
              : null,
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        NotificationReceiver(receivedNotification.payload),
                  ),
                );
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      print("selectNotificationSubject "+payload);
      print("call NotificationReceiverRoute");
      await Navigator.push(
        context,
        MaterialPageRoute<void>(
            builder: (BuildContext context) => NotificationReceiver(payload)),
      );
    });
  }


  Future<void> ShowNotification({String title = 'plain title', String message = 'plain body', String payload = 'payload Item x'}) async{
    print("ShowNotification");
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        'channel id', 'channel name', 'channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker'
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, title, message, platformChannelSpecifics,
        payload: payload);
  }


  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory(); // path provider က စီမံပေးတာ
    final String filePath = '${directory.path}/$fileName';
    http.Response response;
    try{
      //final http.Response
      response = await http.get(url); // ထုံးစံအတိုင်း http module ပေါ့ဗျာ
    }
    catch(exp){
      print("http error in _downloadAndSaveFile "+exp.toString());
      return filePath;
    }
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  Future<void> _showBigPictureNotification() async {
    final String largeIconPath = await _downloadAndSaveFile(
        'http://via.placeholder.com/48x48', 'largeIcon');
    final String bigPicturePath = await _downloadAndSaveFile(
        'http://via.placeholder.com/400x800', 'bigPicture');
    final BigPictureStyleInformation bigPictureStyleInformation =
    BigPictureStyleInformation(
        FilePathAndroidBitmap(bigPicturePath),
        largeIcon: FilePathAndroidBitmap(largeIconPath),
        contentTitle: 'overridden <b>big</b> content title',
        htmlFormatContentTitle: true,
        summaryText: 'summary <i>text</i>',
        htmlFormatSummaryText: true);
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('2',
        'channel1_name', 'channel1_description',
        styleInformation: bigPictureStyleInformation);
    final NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        1, 'big text title', 'silent body', platformChannelSpecifics,
        payload: 'item x big Image');
  }


  /* zonedSchedule ဆိုတာက repeat ထပ်မယ် ဆိုတဲ့ သဘော */
  Future<void> scheduleDailyNotification(int notificationId,int hour,int minute,{String title = 'ကျေးဇူးတင်ကြမယ်', String message = 'ဒီနေ့ ဘယ်သူတွေကို ကျေးဇူးတင်ပါတယ် ပြောဖြစ်လဲ?'}) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        notificationId,
        title,
        message,
        _nextInstanceOfDayTime(hour,minute),
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'daily notification channel id',
              'daily notification channel name',
              'daily notification description'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'item x zonedScheduled notificatio'
    ); // matchDateTimeComponents ဆိုတာက daily/ weekly/ monthly or by time series...
    // DatetimeComponents.time ဆိုရင် အချိန်အပိုင်းအခြားနဲ့၊ dayOfWeekAndTime ဆိုရင် အပတ်စဉ် အချိန်နဲ့ :D
  }


  tz.TZDateTime _nextInstanceOfDayTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> cancelNotification(int notificationId) async {
    print("_cancelNotification");
    await flutterLocalNotificationsPlugin.cancel(notificationId);
  }


}