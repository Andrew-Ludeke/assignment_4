import 'dart:io';

import 'package:assignment_4/enum/EventType.dart';
import 'package:assignment_4/enum/FeedType.dart';
import 'package:assignment_4/Event.dart';
import 'package:flutter/material.dart';


class DetailsModel extends ChangeNotifier {
  final Event _event;
  final File? imgFile;

  DetailsModel({required event, this.imgFile}): _event = event;

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
}