import 'package:chatapp/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import './screens/chat_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.deepPurpleAccent,
        accentColorBrightness: Brightness.light,
        buttonTheme: Theme.of(context).buttonTheme.copyWith(
              buttonColor: Colors.deepPurpleAccent,
              textTheme: ButtonTextTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
        inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.deepPurpleAccent,
                ),
              ),
            ),
      ),
      home: AuthScreen(),
    );
  }
}
