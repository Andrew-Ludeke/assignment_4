enum FeedType
{
  LEFT(description: "Left"),
  RIGHT(description: "Right"),
  BOTTLE(description: "Bottle");

  final String description;

  const FeedType({required this.description});

  static FeedType? fromJson(String? json) => json == null ? null : values.byName(json);
  String toJson() => name;
}