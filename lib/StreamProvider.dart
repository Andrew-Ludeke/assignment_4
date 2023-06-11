import 'dart:async';

import 'package:assignment_4/enum/EventType.dart';

//StreamProvider streamProvider = StreamProvider();

class Streams {
  static final Streams _singleton = Streams._();

  Streams._();

  factory Streams() {
    return _singleton;
  }

  StreamController<String> pageTitle = StreamController<String>();
  StreamController<EventType> _latestStream = StreamController<EventType>();

  Stream<String> get pageTitleStream => pageTitle.stream;
  Stream<EventType> get latestStream => _latestStream.stream;

  void emitEvent(EventType type) {
    print("EMITTED");
    _latestStream.sink.add(type);
  }

  void updatePateTitle(String title) {
    pageTitle.sink.add(title);
  }

  dispose() {
    pageTitle.close();
  }
}