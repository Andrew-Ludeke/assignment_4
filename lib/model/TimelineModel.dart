import 'package:assignment_4/StreamProvider.dart';
import 'package:assignment_4/enum/EventType.dart';
import 'package:assignment_4/enum/FeedType.dart';
import 'package:assignment_4/enum/ToiletContents.dart';
import 'package:assignment_4/model/Event.dart';
import 'package:assignment_4/repository/event_repository.dart';
import 'package:flutter/material.dart';

class TimelineModel extends ChangeNotifier {

  final DateTime _today;
  late List<Event> _events;
  EventType? _filter;
  late List<EventListItem> _eventList;
  final EventRepository _eventRepo = EventRepository();

  TimelineModel({required DateTime today}) : _today = today {
    _events = <Event>[];
    _eventList = <EventListItem>[];
    getEventList().then((_) => calculateEventList());
  }

  void calculateEventList() {
    _eventList.clear();
    eventList = _events.map((e) => EventListItem(event: e, isSelected: false)).toList();
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

  /*
  List<EventListItem> get eventList => _eventList
      .where((item) => _filter == null ? true : item.event.type == _filter)
      .toList();
  */

  Future<List<EventListItem>> get eventList async {
    print("\n\nGETTING LIST\n\n");
    /*
    if (_events.isEmpty) {
      print("\n\nFETCHING LIST FROM DATABASE\n\n");
      await getEventList();
      calculateEventList();
    }
    */

    return _eventList
        .where((item) => _filter == null ? true : item.event.type == _filter)
        .toList();
  }


  set eventList(value) {
    _eventList = value;
    notifyListeners();
  }

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

  void deselectAll() {
    for (EventListItem item in _eventList) {
      item.isSelected = false;
    }
    notifyListeners();
  }

  void deleteSelection() async {
    List<EventListItem> toDelete = _eventList
        .where((item) => item.isSelected)
        .toList();

    bool didDeleteFeed = false;
    bool didDeleteSleep = false;
    bool didDeleteToilet = false;

    for (EventListItem item in toDelete) {
      Event event = item.event;
      if (!_eventList.remove(item)) continue;
      if (!_events.remove(event)) continue;

      switch (event.type) {
        case EventType.FEED: didDeleteFeed = true;
        case EventType.SLEEP: didDeleteSleep = true;
        case EventType.TOILET: didDeleteToilet = true;
        default: break;
      }
      await deleteEvent(event);
    }
    if (didDeleteFeed) Streams().emitEvent(EventType.FEED);
    if (didDeleteSleep) Streams().emitEvent(EventType.SLEEP);
    if (didDeleteToilet) Streams().emitEvent(EventType.TOILET);

    notifyListeners();
  }

  Future<void> deleteEvent(Event event) async {
    return await _eventRepo.delete(event);
  }

  Future<void> getEventList() async {
    _events = await _eventRepo.getForDay(_today);
    notifyListeners();
  }

  void updateEvent(Event newEvent) async {
    if (newEvent.id != null) {
      int index = _events.indexWhere((e) => e.id == newEvent.id);
      _events[index] = newEvent;
      calculateEventList();
      //notifyListeners();
    }
  }

  Event getSelectedEvent() {
    return _eventList
        .where((item) => item.isSelected)
        .first
        .event;
  }
}

class EventListItem {
  Event event;
  bool isSelected;

  EventListItem({required this.event, required this.isSelected});
}