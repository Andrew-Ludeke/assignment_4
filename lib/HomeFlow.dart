import 'package:assignment_4/Home.dart';
import 'package:flutter/material.dart';

class HomeFlowRoutes {
  static const String ROOT = '/';
  static const String FEED = '/feed';
}

class HomeFlow extends StatefulWidget {
  const HomeFlow({super.key, required this.navKey});

  final GlobalKey<NavigatorState> navKey;

  @override
  State<HomeFlow> createState() => _HomeFlowState();
}

class _HomeFlowState extends State<HomeFlow> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: widget.navKey,
      initialRoute: HomeFlowRoutes.ROOT,
      onGenerateRoute: (context) => MaterialPageRoute(
          builder: (context) => const Home(title: "Home")
      ),
    );
  }
}