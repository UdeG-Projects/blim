import 'package:blim/src/screens/DemoListaReproduccionScreen.dart';
import 'package:blim/src/screens/DemoUsuariosScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLIM',
      home: DemoListasReproduccionScreen(),
    );
  }
}
