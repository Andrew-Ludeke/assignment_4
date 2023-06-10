import 'dart:io';

import 'package:assignment_4/enum/EventType.dart';
import 'package:assignment_4/enum/FeedType.dart';
import 'package:assignment_4/model/Event.dart';
import 'package:assignment_4/repository/image_repository.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';


class DetailsModel extends ChangeNotifier {
  final ImageRepository _imgRepo = ImageRepository();
  late final Event _event;
  XFile? _imgFile = null;

  DetailsModel({required event}): _event = event;

  /*
  static Future<DetailsModel> create({required Event event}) async {
    DetailsModel model = DetailsModel._(event: event);
    if (model._event.imgUri == null) {
      model._imgFile = null;
    }
    else {
      model._imgFile = await model._imgRepo.fetch(model._event.imgUri!);
    }
    return model;
  }
  */

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
    if (_event.imgUri != null && _imgFile == null) {
      _imgFile = await _imgRepo.fetch(_event.imgUri!);
    }
    return _imgFile;
  }
}