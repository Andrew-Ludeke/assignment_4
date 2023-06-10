import 'dart:io';

import 'package:assignment_4/enum/EventType.dart';
import 'package:assignment_4/enum/FeedType.dart';
import 'package:assignment_4/model/Event.dart';
import 'package:assignment_4/repository/event_repository.dart';
import 'package:assignment_4/repository/image_repository.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';


class DetailsModel extends ChangeNotifier {
  final EventRepository _eventRepo = EventRepository();
  final ImageRepository _imgRepo = ImageRepository();
  late Event _event;
  XFile? _imgFile = null;
  bool isDirty = false;

  DetailsModel({required event}): _event = event;

  Event get event => _event;

  EventType? get type => _event.type;
  DateTime? get time => _event.time;
  DateTime? get endTime => _event.endTime;
  Duration? get duration {
    int? d = _event.duration;
    if (d == null) return null;
    return Duration(milliseconds: d);
  }
  FeedType? get feedType => _event.feedType;

  Future<XFile?> get imgFile async {
    if (_event.imgUri != null) {
      _imgFile = await _imgRepo.fetch(_event.imgUri!);
    }
    return _imgFile;
  }

  void updateEvent(Event newEvent) {
    _event = newEvent;
    notifyListeners();
  }
}