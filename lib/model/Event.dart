import 'package:assignment_4/enum/EventType.dart';
import 'package:assignment_4/enum/FeedType.dart';
import 'package:assignment_4/enum/ToiletContents.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  Event.fromJson(Map<String, dynamic> json):
        id = json['id'],
        type = EventType.fromJson(json['type']),
        time = json['time'] == null ? null : DateTime.parse(json['time'].toDate().toString()),
        notes = json['notes'],
        duration = json['duration'],
        feedType = FeedType.fromJson(json['feedType']),
        toiletContents = ToiletContents.fromJson(json['toiletContents']),
        imgUri = json['imgUri'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type?.toJson(),
    'time': time == null ? null : Timestamp.fromDate(time!),
    'notes': notes,
    'duration': duration,
    'feedType': feedType?.toJson(),
    'toiletContents': toiletContents?.toJson(),
    'imgUri': imgUri,
  };

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