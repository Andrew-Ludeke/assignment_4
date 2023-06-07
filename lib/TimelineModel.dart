import 'package:assignment_4/Enums/EventType.dart';
import 'package:assignment_4/Enums/FeedType.dart';
import 'package:assignment_4/Event.dart';
import 'package:flutter/material.dart';

class TimelineModel extends ChangeNotifier {

  final DateTime _today;
  late List<Event> _events;
  EventType? _filter;
  //late Map<Event, bool> _eventList;
  //List<EventListItem> _eventList = <EventListItem>[];
  late List<EventListItem> _eventList;

  TimelineModel({required DateTime today}) : _today = today {
    _events = <Event>[
      Event(
          time: DateTime(2023, 6, 7, 12, 30, 12),
          type: EventType.FEED,
          duration: const Duration(minutes: 10).inMilliseconds
      ),
      Event(
          time: DateTime(2023, 6, 7, 14, 12, 46),
          type: EventType.SLEEP,
          duration: const Duration(hours: 1, minutes: 23, seconds: 41).inMilliseconds
      ),
    ];
    //_eventList = <EventListItem>[];
    //_events.map((e) => _eventList.add(EventListItem(event: e, isSelected: false)));
    _eventList = _events.map((e) => EventListItem(event: e, isSelected: false)).toList();
  }

  Duration totalFeedTime(FeedType type) {
    return const Duration(minutes: 10, seconds: 5);
  }

  Duration totalSleepDuration() {
    return const Duration(hours: 2, minutes: 33, seconds: 16);
  }

  get filter => _filter;
  set filter(value) {
    _filter = value;
    notifyListeners();
  }

  List<EventListItem> get eventList => _eventList
      .where((item) => _filter == null ? true : item.event.type == _filter)
      .toList();
  /*
  List<Event> get eventList => _events
      .where((element) => _filter == null ? true : element.type == _filter)
      .toList();
   */
  int get selected => _eventList
      .where((item) => item.isSelected)
      .length;

  void toggleSelect(EventListItem item) {
    item.isSelected = !item.isSelected;
    notifyListeners();
  }

  List<Event> get events => _events;
}

class EventListItem {
  Event event;
  bool isSelected;

  EventListItem({required this.event, required this.isSelected});
}