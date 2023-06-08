import 'package:assignment_4/Enums/FeedType.dart';
import 'package:assignment_4/Enums/ToiletContents.dart';
import 'package:flutter/material.dart';
import 'package:assignment_4/Event.dart';
import 'dart:async' as async;

import 'package:image_picker/image_picker.dart';

class EditModel extends ChangeNotifier {

  late Event _event;
  late async.Timer _timer;
  XFile? _img;

  EditModel({Event? event}): _event = event ?? Event() {
    _timer = async.Timer.periodic(const Duration(seconds: 1), (_) {});
    _timer.cancel();
    _img = null;
  }

  DateTime? get time => _event.time;
  set time(DateTime? time) {
    DateTime? end = _event.endTime;
    _event.time = time;
    _event.endTime = end;
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

  ToiletContents? get toiletContents => _event.toiletContents;
  set toiletContents(ToiletContents? contents) {
    _event.toiletContents = contents;
    notifyListeners();
  }

  void tick (async.Timer t) {
    endTime = DateTime.now();
  }

  void toggleTimer () {
    if (_timer.isActive) {
      _timer.cancel();
      endTime = DateTime.now();
    } else {
      time = DateTime.now();
      endTime = DateTime.now();
      _timer = async.Timer.periodic(const Duration(seconds: 1), tick);
    }
  }

  bool get isTiming => _timer.isActive;

  Future<bool> persist() async {
    return await Future<bool>.delayed(const Duration(seconds: 1), () => true);
  }

  XFile? get img => _img;
  set img(XFile? value) {
    _img = value;
    notifyListeners();
  }

}