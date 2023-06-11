import 'package:assignment_4/model/Event.dart';
import 'package:assignment_4/edit/ManualEntry.dart';
import 'package:assignment_4/edit/Timer.dart';
import 'package:assignment_4/model/EditModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimingContainer extends StatefulWidget {
  const TimingContainer({super.key, required this.isEditing});

  final bool isEditing;

  @override
  State<TimingContainer> createState() => _TimingContainerState();
}

class _TimingContainerState extends State<TimingContainer> with TickerProviderStateMixin {

  late TabController tabController;

  @override
  initState() {
    super.initState();
    tabController = TabController(
        length: 2,
        vsync: this,
        initialIndex: widget.isEditing ? 1 : 0
    );
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
        IgnorePointer(
          ignoring: widget.isEditing,
          child: TabBar(
            controller: tabController,
            unselectedLabelColor: widget.isEditing ? Colors.grey: Colors.black,
            tabs: const <Tab>[
              Tab(text: "Timer"),
              Tab(text: "Manual Entry"),
            ],
          ),
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