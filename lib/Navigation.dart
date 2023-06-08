import 'package:flutter/material.dart';
import 'package:assignment_4/home/HomeFlow.dart';
import 'package:assignment_4/home/Home.dart';
import 'package:assignment_4/timeline/Timeline.dart';

final GlobalKey<NavigatorState> homeKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> timelineKey = GlobalKey<NavigatorState>();

HomeNav homeNav = const HomeNav();
TimelineNav timelineNav = const TimelineNav();

class HomeNav extends StatefulWidget {
    const HomeNav({super.key});

    @override
    State<HomeNav> createState() => _HomeNavState();
}

class _HomeNavState extends State<HomeNav> with AutomaticKeepAliveClientMixin<HomeNav> {
    @override
    bool get wantKeepAlive => true;

    @override
    Widget build(BuildContext context) {
        super.build(context);
        return Navigator(
            key: homeKey,
            initialRoute: HomeFlowRoutes.ROOT,
            onGenerateRoute: (context) => MaterialPageRoute(
                builder: (context) => const Home(title: "Home")
            ),
        );
    }
}


class TimelineNav extends StatefulWidget {
    const TimelineNav({super.key});

    @override
    State<TimelineNav> createState() => _TimelineNavState();
}

class _TimelineNavState extends State<TimelineNav> {
    @override
    Widget build(BuildContext context) {
        return Navigator(
            onGenerateRoute: (context) => MaterialPageRoute(
                builder: (context) => const Timeline()
            )
        );
    }
}


/*
Navigator homeNav = Navigator(
    onGenerateRoute: (context) => MaterialPageRoute(
        builder: (context) => const Home(title: "Home")
    )
);

Navigator timelineNav = Navigator(
    onGenerateRoute: (context) => MaterialPageRoute(
        builder: (context) => const Timeline()
    )
);
*/
