import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';
import 'package:infids/page/home_page.dart';
import 'package:infids/util/service.dart';

void main() {
  runApp(Infids());

  Service service = Service.getInstance();

  BackgroundFetch.registerHeadlessTask(service.checkUpdate);
}

class Infids extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromRGBO(1, 23, 46, 1),
      ),
      title: 'Infids',
      home: HomePage(),
    );
  }
}
