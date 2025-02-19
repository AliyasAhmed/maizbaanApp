import 'package:flutter/material.dart';
import 'package:my_flutter_app/agentdetails.dart';
import 'login_screen.dart';
import 'home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Maizbaan AI',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: HomeScreen(), // Show HomeScreen initially
      // home: AgentDetailsPage(),
    );
  }
}
