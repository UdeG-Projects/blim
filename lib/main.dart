import 'package:blim/src/providers/AppLogic.dart';
import 'package:blim/src/screens/account/screen.dart';
import 'package:blim/src/screens/home/screen.dart';
import 'package:blim/src/screens/lists/screen.dart';
import 'package:blim/src/screens/login/screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => AppLogic())],
      builder: (_, __) => MaterialApp(
        title: 'Blim',
        theme: ThemeData(
          fontFamily: 'Nunito',
          colorScheme: ColorScheme.light(
            secondary: Colors.red,
            primary: Color(0xff03D3EE),
          ),
        ),
        initialRoute: HomeScreen.routeName,
        routes: {
          HomeScreen.routeName: (_) => HomeScreen(),
          LoginScreen.routeName: (_) => LoginScreen(),
          MyAccountScreen.routeName: (_) => MyAccountScreen(),
          MyListsScreen.routeName: (_) => MyListsScreen(),
        },
      ),
    );
  }
}
