enum ToiletContents
{
  EMPTY(name: 'Empty'),
  WET(name: 'Wet'),
  DIRTY(name: 'Dirty'),
  WET_AND_DIRTY(name: 'Wet+Dirty');

  const ToiletContents({required this.name});

  final String name;
}