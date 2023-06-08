enum FeedType
{
  LEFT(name: "Left"),
  RIGHT(name: "Right"),
  BOTTLE(name: "Bottle");

  final String name;

  const FeedType({required this.name});
}