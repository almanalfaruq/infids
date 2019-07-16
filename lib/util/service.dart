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

  Future<void> initPlatformState(BuildContext context) async {
    this.context = context;
    // Configure BackgroundFetch.
    BackgroundFetch.configure(
        BackgroundFetchConfig(
            minimumFetchInterval: 15,
            stopOnTerminate: false,
            enableHeadless: true), () async {
      checkUpdate();
    }).then((int status) {
      print('[BackgroundFetch] SUCCESS: $status');
    }).catchError((e) {
      print('[BackgroundFetch] ERROR: $e');
    });
  }

  void checkUpdate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Post> posts = await _webScraper.getPostsFromWebsite();
    int oldPostId = prefs.getInt('id');
    if (posts.length > 0 && oldPostId != null) {
      if (posts[0].id != oldPostId) {
        prefs.setInt('id', posts[0].id);
        _sendNotification();
      }
    }
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
    if (context != null) {
      await Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }
}
