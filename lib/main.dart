import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:infids/page/home_page.dart';
import 'package:infids/util/service.dart';

Service service;
final navigatorKey = GlobalKey<NavigatorState>();

void headlessTask() async {
  print('Starting headless task');
  service = Service.getInstance();
  service.checkUpdate();
}

void main() {
  runApp(Infids());

  service = Service.getInstance();

  BackgroundFetch.registerHeadlessTask(headlessTask);
}

class Infids extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromRGBO(1, 23, 46, 1),
      ),
      title: 'Infids',
      home: HomePage(),
    );
  }
}
