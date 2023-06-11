import 'dart:io';

import 'package:assignment_4/StreamProvider.dart';
import 'package:assignment_4/enum/EventType.dart';
import 'package:assignment_4/enum/FeedType.dart';
import 'package:assignment_4/enum/ToiletContents.dart';
import 'package:assignment_4/repository/event_repository.dart';
import 'package:assignment_4/repository/image_repository.dart';
import 'package:flutter/material.dart';
import 'package:assignment_4/model/Event.dart';
import 'dart:async' as async;

import 'package:image_picker/image_picker.dart';

class EditModel extends ChangeNotifier {

  late Event _event;
  late async.Timer _timer;
  XFile? _imgFile;
  final EventRepository _eventRepo = EventRepository();
  final ImageRepository _imgRepo = ImageRepository();
  bool isNewImage = false;
  String? _imgPath = null;

  EditModel({Event? event}): _event = event ?? Event() {
    _timer = async.Timer.periodic(const Duration(seconds: 1), (_) {});
    _timer.cancel();
    _imgFile = null;
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

  String? get imgUri => _event.imgUri;
  set imgUri(String? uri) {
    _event.imgUri = uri;
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

  Future<void> persist() async {
    if (_imgPath != null && _imgFile != null) {
      _event.imgUri = await _imgRepo.persist(_imgFile!);
    }

    await _eventRepo.persist(_event);
    Streams().emitEvent(_event.type!);
  }

  Future<XFile?> get imgFile async {
    if (_imgPath != null) {
      _imgFile = XFile(imgPath!);
    } else if (_event.imgUri != null && _imgFile == null) {
      _imgFile = await _imgRepo.fetch(_event.imgUri!);
    }
    return _imgFile;
  }
  set imgFile(Future<XFile?> value) {
    value.then((val) {
      _imgFile = val;
      if (val == null) {
        _imgPath = null;
      } else {
        _imgPath = val.path;
      }
      notifyListeners();
    });
  }

  String? get imgPath => _imgPath;
  set imgPath(String? value) {
    _imgPath = value;
    notifyListeners();
  }

  Event get event => _event;

  List<String> validate() {
    List<String> missing = <String> [];

    switch (_event.type) {
      case EventType.FEED:
        if (time == null) missing.add('start time');
        if (endTime == null) missing.add('end time');
        if (feedType == null) missing.add('feed type');
      case EventType.SLEEP:
        if (time == null) missing.add('start time');
        if (endTime == null) missing.add('end time');
      case EventType.TOILET:
        if (time == null) missing.add('start time');
      default: break;
    }

    return missing;
  }
}