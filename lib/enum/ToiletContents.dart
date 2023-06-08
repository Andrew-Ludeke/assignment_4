enum ToiletContents
{
  EMPTY(description: 'Empty'),
  WET(description: 'Wet'),
  DIRTY(description: 'Dirty'),
  WET_AND_DIRTY(description: 'Wet+Dirty');

  const ToiletContents({required this.description});

  final String description;

  static ToiletContents? fromJson(String? json) => json == null ? null : values.byName(json);
  String toJson() => name;
}