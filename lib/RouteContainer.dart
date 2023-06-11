import 'package:flutter/material.dart';
import 'package:assignment_4/StreamProvider.dart';
import 'package:assignment_4/Navigation.dart';
import 'package:assignment_4/home/HomeFlow.dart';
import 'package:assignment_4/timeline/TimelineFlow.dart';

class RouteContainer extends StatefulWidget {
  const RouteContainer({super.key});

  @override
  State<RouteContainer> createState() => _RouteContainerState();
}

class _RouteContainerState extends State<RouteContainer> {

  //String pageTitle = 'Home';
  String homeTitle = 'Home';
  String timelineTitle = 'Timeline';

  @override
  void initState() {
    super.initState();

    Streams().homeFlowTitle.listen((title) => homeTitle = title);
    Streams().timelineFlowTitle.listen((title) => timelineTitle = title);

    selectTab(0);
  }

  int index = 0;

  selectTab(int i) {
    setState(() {
      index = i;
      switch (i) {
        case 0: Streams().updatePageTitle(homeTitle);
        case 1: Streams().updatePageTitle(timelineTitle);
        default: break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (index == 1) {
          setState(() {
            index = 0;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          //title: Text(pageTitle),
          title: StreamBuilder<String?>(
            stream: Streams().pageTitle,
            initialData: 'Home',
            builder: (context, snapshot) => Text(snapshot.data ?? 'Narnia'),
          ),
        ),
        body: Stack(
          children: <Widget>[
            Offstage(
              offstage: index != 0,
              child: HomeFlow(navKey: homeKey),
            ),
            Offstage(
              offstage: index != 1,
              child: const TimelineFlow(),
            ),
          ],
        ),
        //  body: gotoTab(index),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          onTap: (index) => selectTab(index),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.timeline),
              label: 'Timeline',
            ),
          ],
        ),
      ),
    );
  }
}
