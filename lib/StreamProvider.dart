import 'dart:async';

StreamProvider streamProvider = StreamProvider();

class StreamProvider {
  StreamController<String> pageTitle = StreamController<String>();

  Stream<String> get pageTitleStream => pageTitle.stream;

  void updatePateTitle(String title) {
    pageTitle.sink.add(title);
  }

  dispose() {
    pageTitle.close();
  }
}