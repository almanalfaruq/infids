import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:infids/model/post.dart';
import 'package:infids/page/home_page.dart';
import 'package:infids/provider/web_scraper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Service {
  WebScraper _webScraper = WebScraper();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final navigatorKey = GlobalKey<NavigatorState>();

  BuildContext context;

  static Service _service;

  static Service getInstance() {
    if (_service == null) {
      _service = Service();
    }
    return _service;
  }

  Service() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: _onSelectNotification);
  }

  Future<void> initPlatformState() async {
    BackgroundFetch.configure(
        BackgroundFetchConfig(
            minimumFetchInterval: 15,
            stopOnTerminate: false,
            enableHeadless: true,
            startOnBoot: true), () async {
      checkUpdate();
    }).then((int status) {
      print('[BackgroundFetch] SUCCESS: $status');
    }).catchError((e) {
      print('[BackgroundFetch] ERROR: $e');
    });
  }

  void checkUpdate() async {
    print('Start checking an update');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Post> posts = await _webScraper.getPostsFromWebsite();
    int oldPostId = prefs.getInt('id');
    if (posts.length > 0 && oldPostId != null) {
      if (posts[0].id != oldPostId) {
        print('There\'s a difference');
        prefs.setInt('id', posts[0].id);
        print('Sending notification');
        _sendNotification();
      }
    }
    print('Finish checking an update');
    BackgroundFetch.finish();
  }

  void _sendNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(2006, 'Pengumuman',
        'Terdapat update dari web akademik', platformChannelSpecifics);
  }

  Future _onSelectNotification(String payload) async {
    await navigatorKey.currentState?.push(MaterialPageRoute(builder: (context) => HomePage()));
  }
}
