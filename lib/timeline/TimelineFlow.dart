import 'package:assignment_4/timeline/Timeline.dart';
import 'package:flutter/material.dart';
import 'package:assignment_4/Navigation.dart';

class TimelineFlowRoutes {
  static const String ROOT = '/';
  static const String DAILY = '/daily';
}

class TimelineFlow extends StatefulWidget {
  const TimelineFlow({super.key});

  @override
  State<TimelineFlow> createState() => _TimelineFlowState();
}

class _TimelineFlowState extends State<TimelineFlow> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isStackEmpty = !await timelineKey.currentState!.maybePop();
        if (!isStackEmpty) {
          return false;
        }
        return true;
      },
      child: Navigator(
        key: timelineKey,
        initialRoute: TimelineFlowRoutes.ROOT,
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
              builder: (context) => const Timeline()
          );
        },
      ),
    );
  }
}
