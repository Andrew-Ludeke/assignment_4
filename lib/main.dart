import 'package:assignment_4/RouteContainer.dart';
import 'package:flutter/material.dart';
import 'package:assignment_4/Home.dart';

void main() {
  runApp(const BabyTrackerApp());
}

class BabyTrackerApp extends StatelessWidget {
  const BabyTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baby Tacker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: const Home(title: 'Flutter Demo Home.dart Page'),
      home: const RouteContainer()
    );
  }
}


