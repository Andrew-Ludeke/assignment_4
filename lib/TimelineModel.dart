import 'package:assignment_4/Enums/EventType.dart';
import 'package:assignment_4/Enums/FeedType.dart';
import 'package:assignment_4/Enums/ToiletContents.dart';
import 'package:assignment_4/Event.dart';
import 'package:flutter/material.dart';

class TimelineModel extends ChangeNotifier {

  final DateTime _today;
  late List<Event> _events;
  EventType? _filter;
  late List<EventListItem> _eventList;

  TimelineModel({required DateTime today}) : _today = today {
    _events = <Event>[
      Event(
        type: EventType.FEED,
        time: DateTime(2023, 6, 7, 12, 30, 12),
        duration: const Duration(minutes: 10).inMilliseconds,
        feedType: FeedType.BOTTLE,
      ),
      Event(
        type: EventType.SLEEP,
        time: DateTime(2023, 6, 7, 14, 12, 46),
        duration: const Duration(hours: 1, minutes: 23, seconds: 41).inMilliseconds,
      ),
      Event(
        type: EventType.TOILET,
        time: DateTime(2023, 6, 7, 17, 00, 00),
        duration: const Duration(minutes: 10).inMilliseconds,
        toiletContents: ToiletContents.WET_AND_DIRTY,
      ),
    ];
    _eventList = _events.map((e) => EventListItem(event: e, isSelected: false)).toList();
  }

  int _totalFeedDuration(FeedType type) => _events
      .where((event) => event.type == EventType.FEED && event.feedType == type)
      .map((event) => event.duration ?? 0)
      .fold(0, (value, element) => value + element);

  Duration totalFeedDuration(FeedType type) => Duration(milliseconds: _totalFeedDuration(type));

  int _totalSleepDuration() => _events
      .where((event) => event.type == EventType.SLEEP)
      .map((event) => event.duration ?? 0)
      .fold(0, (value, element) => value + element);

  Duration totalSleepDuration() => Duration(milliseconds: _totalSleepDuration());

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

  int get wet => _events
      .where((event) => event.toiletContents == ToiletContents.WET)
      .length;

  int get dirty => _events
      .where((event) => event.toiletContents == ToiletContents.DIRTY)
      .length;

  int get wetAndDirty => _events
      .where((event) => event.toiletContents == ToiletContents.WET_AND_DIRTY)
      .length;
}

class EventListItem {
  Event event;
  bool isSelected;

  EventListItem({required this.event, required this.isSelected});
}