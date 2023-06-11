import 'dart:async';

import 'package:assignment_4/StreamProvider.dart';
import 'package:assignment_4/enum/EventType.dart';
import 'package:assignment_4/model/Event.dart';
import 'package:assignment_4/repository/event_repository.dart';
import 'package:flutter/material.dart';

class HomeModel extends ChangeNotifier {
  final EventRepository _eventRepo = EventRepository();
  final Streams _streamProvider = Streams();

  Event? _lastFeed;
  Event? _lastSleep;
  Event? _lastToilet;

  DateTime? _now;

  late final Timer _timer;

  HomeModel() {
    getLatestEvents();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _now = DateTime.now();
      notifyListeners();
    });
    _streamProvider.latestStream.listen(getLatest);
  }

  Duration? get timeSinceFeed {
    if (_now == null || _lastFeed == null || _lastFeed!.endTime == null) return null;
    return _now!.difference(_lastFeed!.endTime!);
  }
  Duration? get timeSinceSleep {
    if (_now == null || _lastSleep == null || _lastSleep!.endTime == null) return null;
    return _now!.difference(_lastSleep!.endTime!);
  }
  Duration? get timeSinceToilet {
    if (_now == null || _lastToilet == null || _lastToilet!.time == null) return null;
    return _now!.difference(_lastToilet!.time!);
  }

  void getLatestEvents() async {
    _lastFeed = await _eventRepo.getLatest(EventType.FEED);
    _lastSleep = await _eventRepo.getLatest(EventType.SLEEP);
    _lastToilet = await _eventRepo.getLatest(EventType.TOILET);
    notifyListeners();
  }

  void getLatest(EventType type) async {
    print("RECEIVED");
    switch (type) {
      case EventType.FEED: _lastFeed = await _eventRepo.getLatest(EventType.FEED);
      case EventType.SLEEP: _lastSleep = await _eventRepo.getLatest(EventType.SLEEP);
      case EventType.TOILET: _lastToilet = await _eventRepo.getLatest(EventType.TOILET);
    }
    notifyListeners();
  }

  Duration? timeSince(EventType type) {
    switch (type) {
      case EventType.FEED: return timeSinceFeed;
      case EventType.SLEEP: return timeSinceSleep;
      case EventType.TOILET: return timeSinceToilet;
    }
  }
}