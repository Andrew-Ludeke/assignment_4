import 'package:assignment_4/Event.dart';
import 'package:assignment_4/ManualEntry.dart';
import 'package:assignment_4/Timer.dart';
import 'package:assignment_4/EditModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimingContainer extends StatefulWidget {
  const TimingContainer({super.key});

  @override
  State<TimingContainer> createState() => _TimingContainerState();
}

class _TimingContainerState extends State<TimingContainer> with TickerProviderStateMixin {

  late TabController tabController;

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
    return Column(
      children: <Widget>[
        TabBar(
          controller: tabController,
          tabs: const <Tab>[
            Tab(text: "Timer"),//, icon: Icon(Icons.timer)),
            Tab(text: "Manual Entry"),//, icon: Icon(Icons.text_fields)),
          ],
        ),
        SizedBox(
          height: 160,
          child: TabBarView(
            controller: tabController,
            children: const <Widget>[
              Timer(),
              ManualEntry(),
            ],
          ),
        ),
      ],
    );
  }
}