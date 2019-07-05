import 'package:flutter/material.dart';
import 'package:infids/page/home_page.dart';

void main() => runApp(Infids());

class Infids extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Infids',
      home: HomePage(),
    );
  }
}
