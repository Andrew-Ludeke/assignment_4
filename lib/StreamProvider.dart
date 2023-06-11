import 'dart:async';

import 'package:assignment_4/enum/EventType.dart';

//StreamProvider streamProvider = StreamProvider();

class Streams {
  static final Streams _singleton = Streams._();

  Streams._();

  factory Streams() {
    return _singleton;
  }

  final StreamController<String> _pageTitle = StreamController<String>();
  final StreamController<String> _homeFlowTitle = StreamController<String>();
  final StreamController<String> _timelineFlowTitle = StreamController<String>();
  final StreamController<EventType> _latestStream = StreamController<EventType>();

  Stream<String> get pageTitle => _pageTitle.stream;
  Stream<String> get homeFlowTitle => _homeFlowTitle.stream;
  Stream<String> get timelineFlowTitle => _timelineFlowTitle.stream;
  Stream<EventType> get latestStream => _latestStream.stream;

  void emitEvent(EventType type) {
    _latestStream.sink.add(type);
  }

  void updatePageTitle(String title) {
    print('setting page title: $title');
    _pageTitle.sink.add(title);
  }

  void updateHomeFlowTitle(String title) {
    _homeFlowTitle.sink.add(title);
    updatePageTitle(title);
  }

  void updateTimelineFlowTitle(String title) {
    _timelineFlowTitle.sink.add(title);
    updatePageTitle(title);
  }

  dispose() {
    _pageTitle.close();
    _latestStream.close();
    _homeFlowTitle.close();
    _timelineFlowTitle.close();
  }
}