import 'package:calorie_app/widgets/calorie_screen.dart';
import 'package:flutter/material.dart';

/// A [StatelessWidget] subclass.
class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Calorie App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity),
        home: CalorieScreen(title: 'Calorie'));
  }
}