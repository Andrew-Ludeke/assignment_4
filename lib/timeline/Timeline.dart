import 'package:assignment_4/StreamProvider.dart';
import 'package:assignment_4/model/TimelineModel.dart';
import 'package:assignment_4/timeline/Daily.dart';
import 'package:assignment_4/Navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Timeline extends StatefulWidget {
  const Timeline({super.key});

  @override
  State<Timeline> createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  Widget build(BuildContext context) {
    return buildCalendar(context);
  }

  Widget buildCalendar(BuildContext context) {
    DateTime today = DateTime.now();
    today = DateTime(today.year, today.month, today.day);
    int nextMonth = (today.month + 1) % 12;
    int nextYear = nextMonth == 1 ? today.year + 1 : today.year;

    return CalendarDatePicker(
        initialDate: today,
        //firstDate: DateTime(today.year, today.month, 1),
        //lastDate: DateTime(nextYear, nextMonth, 1),
        firstDate: DateTime(1970, 1, 1),
        lastDate: DateTime(2999, 12, 1),
        onDateChanged: (value) async {
          await timelineKey.currentState!.push(MaterialPageRoute(builder: (context) {
            return ChangeNotifierProvider<TimelineModel>(
              create: (context) => TimelineModel(today: value),
              child: Daily(today: value),
            );
          }));

          if (!mounted) return;

          Streams().updateTimelineFlowTitle('Timeline');
        },
    );
  }

  int nextMonth(DateTime day) {
    return (day.month % 12) + 1;
  }

  int nextYear(DateTime day) {
    return nextMonth(day) == 1 ? day.year + 1 : day.year;
  }

  void getDate() {
    DateTime today = DateTime.now();
    int nextMonth = (today.month + 1) % 12 + 1;
    int nextYear = nextMonth == 1 ? today.year + 1 : today.year;

    Future<DateTime?> x = showDatePicker(
      context: context,
      initialDate: today,
      firstDate: DateTime(today.year, today.month, 1),
      lastDate: DateTime(nextYear, nextMonth, 0),
    );
  }
}
