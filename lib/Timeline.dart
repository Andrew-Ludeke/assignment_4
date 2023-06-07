import 'package:assignment_4/Daily.dart';
import 'package:assignment_4/Navigation.dart';
import 'package:flutter/material.dart';


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
    int nextMonth = (today.month + 1) % 12;
    int nextYear = nextMonth == 1 ? today.year + 1 : today.year;

    return CalendarDatePicker(
        initialDate: today,
        firstDate: DateTime(today.year, today.month, 1),
        lastDate: DateTime(nextYear, nextMonth, 1),
        onDateChanged: (value) {
          timelineKey.currentState!.push(MaterialPageRoute(builder: (context) {
            return Daily(today: value);
          }));
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
