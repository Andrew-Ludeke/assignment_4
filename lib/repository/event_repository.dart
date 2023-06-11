import 'package:assignment_4/enum/EventType.dart';
import 'package:assignment_4/model/Event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventRepository {
  static final EventRepository _singleton = EventRepository._();

  EventRepository._() {
    db = FirebaseFirestore.instance;
    collection = db.collection('events');
  }

  factory EventRepository() {
    return _singleton;
  }

  late final FirebaseFirestore db;
  late final CollectionReference collection;

  Future<List<Event>> getForDay(DateTime today) async {
    DateTime tomorrow = DateTime(today.year, today.month, today.day + 1);

    QuerySnapshot snapshot = await collection
        .where('time', isGreaterThanOrEqualTo: today)
        .where('time', isLessThan: tomorrow)
        .get();

    List<Event> events = <Event>[];

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      Event event = Event.fromJson(doc.data() as Map<String, dynamic>);
      events.add(event);
    }

    return events;
  }

  Future<void> persist(Event event) async {
    DocumentReference docRef = collection.doc(event.id);
    event.id = docRef.id;
    return await docRef.set(event.toJson());
  }

  Future<Event> fetchById(String id) async {
    DocumentReference docRef = collection.doc(id);

    DocumentSnapshot snapshot = await docRef.get();

    Event event = Event.fromJson(snapshot.data() as Map<String, dynamic>);

    return event;
  }

  Future<void> delete(Event event) async {
    DocumentReference docRef = collection.doc(event.id);
    return await docRef.delete();
  }

  Future<Event?> getLatest(EventType type) async {
    QuerySnapshot snapshot = await collection
        .where('type', isEqualTo: type.name)
        .orderBy('time', descending: true)
        .limit(1)
        .get();

    QueryDocumentSnapshot doc = snapshot.docs.first;

    return Event.fromJson(doc.data() as Map<String, dynamic>);

    /*
    try {
      return Event.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
    */
  }
}