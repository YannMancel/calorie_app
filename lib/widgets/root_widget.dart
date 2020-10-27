import 'package:calorie_app/widgets/calorie_widget.dart';
import 'package:flutter/material.dart';

/// Root widget which extends to {StatelessWidget}.
class RootApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Calorie App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity),
        home: CalorieCalculator(title: 'Calorie'));
  }
}