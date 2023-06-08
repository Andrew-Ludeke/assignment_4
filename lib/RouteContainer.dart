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

  String pageTitle ='Home';
  int index = 0;

  selectTab(int i) {
    setState(() {
      index = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: StreamBuilder<String?>(
          stream: streamProvider.pageTitleStream,
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
    );
  }
}
