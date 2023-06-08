enum EventType
{
  FEED(description: "Feed"),
  SLEEP(description: "Sleep"),
  TOILET(description: "Toilet");

  final String description;

  const EventType({required this.description});

  static EventType? fromJson(String? json) => json == null ? null : values.byName(json);
  String toJson() => name;
}