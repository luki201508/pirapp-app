import 'package:flutter/material.dart';
import 'package:pirapp/pages/courses.dart';
import 'package:pirapp/pages/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Arial'
      ),
      home: new Scaffold(
        resizeToAvoidBottomInset: true,
        body: new Login(),
      ),
    );
  }
}
