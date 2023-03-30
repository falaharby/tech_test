import 'package:flutter/material.dart';
import 'package:tech_test/style/app_colors.dart';
import 'package:tech_test/view/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tech Test',
      theme: ThemeData(
        primaryColor: AppColors.mainColor,
      ),
      home: const HomePage(),
    );
  }
}
