import 'package:assignment_4/enum/EventType.dart';
import 'package:assignment_4/enum/FeedType.dart';
import 'package:assignment_4/enum/ToiletContents.dart';

class Event
{
  String? id;
  EventType? type;
  DateTime? time;
  String? notes;
  int? duration;                    // Dart ints are 64-bit, but not when compiling to JavaScript
  FeedType? feedType;
  ToiletContents? toiletContents;
  String? imgUri;

  DateTime? get endTime {
    if (duration == null) return null;
    return time?.add(Duration(milliseconds: duration!));
  }

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

  @override
  String toString() {
    return '''
    Event(
      id: ${id ?? 'None'},
      type: ${type ?? 'None'},
      time: ${time ?? 'None'},
      notes: ${notes ?? 'None'},
      duration: ${duration ?? 'None'},
      feedType: ${feedType ?? 'None'},
      toiletContents: ${toiletContents ?? 'None'},
      imgUri: ${imgUri ?? 'None'},
    )
    ''';
  }
}