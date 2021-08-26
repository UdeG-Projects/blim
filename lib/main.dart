import 'package:blim/src/screens/DemoScreen.dart';
import 'package:blim/src/screens/DemoScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLIM',
      home: DemoScreen(),
    );
  }
}
