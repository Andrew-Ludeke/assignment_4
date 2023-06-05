import 'package:assignment_4/Enums/FeedType.dart';
import 'package:flutter/material.dart';
import 'package:assignment_4/Event.dart';

class EditModel extends ChangeNotifier {

  final Event _event = Event();

  DateTime? get time => _event.time;
  set time(DateTime? time) {
    _event.time = time;
    notifyListeners();
  }

  DateTime? get endTime => _event.endTime;
  set endTime(DateTime? end) {
    _event.endTime = end;
    notifyListeners();
  }

  FeedType? get feedType => _event.feedType;
  set feedType(FeedType? type) {
    _event.feedType = type;
    notifyListeners();
  }

  String? get notes => _event.notes;
  set notes(String? notes) {
    _event.notes = notes;
    print(_event.notes);
    notifyListeners();
  }
}
