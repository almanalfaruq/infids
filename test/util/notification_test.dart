import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:platform/platform.dart';

class MockMethodChannel extends Mock implements MethodChannel {}

void main() {
  MockMethodChannel mockChannel;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  const id = 0;
  const title = 'Pengumuman';
  const body = 'Terdapat update dari web akademik';
  const payload = 'update';

  group('ios', () {
    setUp(() {
      mockChannel = MockMethodChannel();
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin.private(
          mockChannel, FakePlatform(operatingSystem: 'ios'));
    });

    test('initialise plugin on iOS', () async {
      const IOSInitializationSettings initializationSettingsIOS =
          IOSInitializationSettings();
      const InitializationSettings initializationSettings =
          InitializationSettings(null, initializationSettingsIOS);
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);
      verify(mockChannel.invokeMethod(
          'initialize', initializationSettingsIOS.toMap()));
    });

    test('show notification on iOS', () async {
      IOSNotificationDetails iOSPlatformChannelSpecifics =
          IOSNotificationDetails();
      NotificationDetails platformChannelSpecifics =
          NotificationDetails(null, iOSPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin
          .show(0, title, body, platformChannelSpecifics, payload: payload);
      verify(mockChannel.invokeMethod('show', <String, dynamic>{
        'id': id,
        'title': title,
        'body': body,
        'platformSpecifics': iOSPlatformChannelSpecifics.toMap(),
        'payload': payload
      }));
    });

    test('delete notification on ios', () async {
      await flutterLocalNotificationsPlugin.cancel(id);
      verify(mockChannel.invokeMethod('cancel', id));
    });
  });

  group('android', () {
    setUp(() {
      mockChannel = MockMethodChannel();
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin.private(
          mockChannel, FakePlatform(operatingSystem: 'android'));
    });

    test('initialise plugin on Android', () async {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('app_icon');
      const InitializationSettings initializationSettings =
          InitializationSettings(initializationSettingsAndroid, null);
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);
      verify(mockChannel.invokeMethod(
          'initialize', initializationSettingsAndroid.toMap()));
    });

    test('show notification on Android', () async {
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails('your channel id', 'your channel name',
              'your channel description',
              importance: Importance.Max, priority: Priority.High);

      NotificationDetails platformChannelSpecifics =
          NotificationDetails(androidPlatformChannelSpecifics, null);

      await flutterLocalNotificationsPlugin
          .show(0, title, body, platformChannelSpecifics, payload: payload);
      verify(mockChannel.invokeMethod('show', <String, dynamic>{
        'id': id,
        'title': title,
        'body': body,
        'platformSpecifics': androidPlatformChannelSpecifics.toMap(),
        'payload': payload
      }));
    });

    test('delete notification on android', () async {
      await flutterLocalNotificationsPlugin.cancel(id);
      verify(mockChannel.invokeMethod('cancel', id));
    });
  });
}
