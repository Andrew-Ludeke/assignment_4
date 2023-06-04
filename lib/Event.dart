import 'package:assignment_4/Enums/EventType.dart';
import 'package:assignment_4/Enums/FeedType.dart';
import 'package:assignment_4/Enums/ToiletContents.dart';

class Event
{
  String? id;
  EventType? type;
  DateTime? time;
  String? notes;
  int? duration;                    // Dart ints are 64-bit, but only 54-bit when compiling to JavaScript
  FeedType? feedType;
  ToiletContents? toiletContents;
  String? imgUri;

  DateTime? get endTime => time?.add(Duration(milliseconds: duration ?? 0));
  set endTime (DateTime? end) {
    if (time == null) {
      duration == null;
    } else {
      duration = end?.difference(time!).inMilliseconds;
    }
  }

  Event({
    this.id,
    this.type,
    this.time,
    this.notes,
    this.duration,
    this.feedType,
    this.toiletContents,
    this.imgUri
  });
}