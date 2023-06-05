import 'package:assignment_4/Enums/FeedType.dart';
import 'package:flutter/material.dart';
import 'package:assignment_4/Event.dart';
import 'dart:async' as async;

class EditModel extends ChangeNotifier {

  final Event _event = Event();
  late async.Timer timer;

  EditModel() {
    timer = async.Timer.periodic(const Duration(seconds: 1), (_) {});
    timer.cancel();
  }

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
    notifyListeners();
  }

  void tick (async.Timer t) {
    endTime = DateTime.now();
  }

  void toggleTimer () {
    if (timer.isActive) {
      timer.cancel();
      endTime = DateTime.now();
    } else {
      time = DateTime.now();
      endTime = DateTime.now();
      timer = async.Timer.periodic(const Duration(seconds: 1), tick);
    }
  }

  bool get isTiming => timer.isActive;

  Future<bool> persist() async {
    return await Future<bool>.delayed(const Duration(seconds: 1), () => true);
  }
}