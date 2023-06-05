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
}
