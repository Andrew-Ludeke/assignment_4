import 'dart:async';

import 'package:assignment_4/Event.dart';
import 'package:assignment_4/ManualEntry.dart';
import 'package:assignment_4/Timer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimingContainer extends StatefulWidget {
  const TimingContainer({super.key});

  //final TimingModel timingModel;

  @override
  State<TimingContainer> createState() => _TimingContainerState();
}

class _TimingContainerState extends State<TimingContainer> with TickerProviderStateMixin {

  late TabController tabController;

  Event event = Event();
  //TimingModel timingModel = TimingModel();

  @override
  initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TimingModel(),
      child: Column(
        children: <Widget>[
          TabBar(
            controller: tabController,
            tabs: const <Tab>[
              Tab(text: "Timer", icon: Icon(Icons.timer)),
              Tab(text: "Manual Entry", icon: Icon(Icons.text_fields)),
            ],
          ),
          SizedBox(
            height: 200,
            child: Consumer<TimingModel>(
              builder: buildTabView,
            ),
          ),
        ],
      ),
    );
  }

  TabBarView buildTabView(
      BuildContext context,
      TimingModel timingModel,
      _
  ) {
    return TabBarView(
            controller: tabController,
            children: const <Widget>[
              Timer(),
              ManualEntry(),
            ],
          );
  }
}

class TimingModel extends ChangeNotifier {

  final Event event = Event();

  DateTime? get time => event.time;
  DateTime? get endTime => event.endTime;

  setTime(DateTime? time) {
    event.time = time;
    print('time: ${event.time}');
    notifyListeners();
  }

  /*
  setDuration(int? duration) {
    event.duration = duration;
    notifyListeners();
  }
  */

  setEndTime(DateTime? end) {
    event.endTime = end;
    print('endTime: ${event.endTime}');
    notifyListeners();
  }
}