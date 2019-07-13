import 'package:flutter/material.dart';
import 'package:infids/page/home_page.dart';

void main() => runApp(Infids());

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
