import 'dart:ui';
import 'package:flutter/material.dart';
import '../views/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Recipe',
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
