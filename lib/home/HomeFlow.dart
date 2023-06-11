import 'package:assignment_4/home/Home.dart';
import 'package:assignment_4/Navigation.dart';
import 'package:assignment_4/model/home_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return WillPopScope(
      onWillPop: () async {
        final bool isStackEmpty = !await homeKey.currentState!.maybePop();
        if (!isStackEmpty) {
          return false;
        }
        return true;
      },
      child: Navigator(
        key: widget.navKey,
        initialRoute: HomeFlowRoutes.ROOT,
        onGenerateRoute: (context) => MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (BuildContext context) => HomeModel(),
            child: const Home(title: "Home"),
          ),
        ),
      ),
    );
  }
}