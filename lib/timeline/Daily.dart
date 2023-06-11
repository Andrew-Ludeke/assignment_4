import 'package:assignment_4/StreamProvider.dart';
import 'package:assignment_4/widgets/DataLabel.dart';
import 'package:assignment_4/edit/EditFeed.dart';
import 'package:assignment_4/edit/EditSleep.dart';
import 'package:assignment_4/edit/EditToilet.dart';
import 'package:assignment_4/model/DetailsModel.dart';
import 'package:assignment_4/enum/EventType.dart';
import 'package:assignment_4/enum/FeedType.dart';
import 'package:assignment_4/model/Event.dart';
import 'package:assignment_4/details/FeedDetails.dart';
import 'package:assignment_4/Navigation.dart';
import 'package:assignment_4/details/SleepDetails.dart';
import 'package:assignment_4/model/EditModel.dart';
import 'package:assignment_4/model/TimelineModel.dart';
import 'package:assignment_4/details/ToiletDetails.dart';
import 'package:assignment_4/Utilities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class Daily extends StatefulWidget {
  const Daily({super.key, required this.today});

  final DateTime today;

  @override
  State<Daily> createState() => _DailyState();
}

class _DailyState extends State<Daily> {
  bool isVisible = false;

  @override
  void initState() {
    super.initState();

    Streams().updateTimelineFlowTitle(formatDate(widget.today) ?? 'Daily Details');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Today\'s Summary', style: TextStyle(fontSize: 24.0)),
              Consumer<TimelineModel>(
                builder: (context, model, _) => TextButton(
                  onPressed: () {
                    Share.share(model.events.toString());
                  },
                  child: const Icon(Icons.share),
                ),
              ),
            ],
          ),
          Center(child: Padding(
            padding: const EdgeInsets.all(0.0),
              child: FutureBuilder(
                  future: (){
                    TimelineModel model = Provider.of<TimelineModel>(context, listen: false);
                    return model.eventList;
                  }(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(
                          child: CircularProgressIndicator()
                      );
                    }

                    return const DailyStats();
                  }
              )
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 32.0, bottom: 32.0),
                child: Consumer<TimelineModel>(
                    builder: (context, model, _) {
                      if (model.selected == 0) {
                        return const Text('Recorded Events', style: TextStyle(
                            fontSize: 24.0));
                      }
                      return Row(
                        children: <Widget>[
                          TextButton(
                            onPressed: () {
                              model.deselectAll();
                            },
                            child: const Icon(Icons.close),
                          ),
                          Text(
                              '${model.selected} Selected',
                              style: const TextStyle(fontSize: 24.0)
                          ),
                        ],
                      );
                    }
                ),
              ),
              Row(
                children: <Widget>[
                  TextButton(
                    onPressed: () => setState(() {
                      isVisible = !isVisible;
                    }),
                    child: const Icon(Icons.filter_alt),
                  ),
                  Consumer<TimelineModel>(
                    builder: (context, model, _) => TextButton(
                      onPressed: model.selected == 1
                      ? () async {
                        Event event = model.getSelectedEvent();

                        if (event.type == null) {
                          // TODO: Toast error
                          return;
                        }

                        model.deselectAll();

                        Event? newEvent = await timelineKey.currentState!.push(
                            MaterialPageRoute(
                                builder: (context) {
                                  return ChangeNotifierProvider<EditModel>(
                                      create: (context) => EditModel(event: event.copy()),
                                      builder: (context, _) {
                                        switch(event.type!) {
                                          case EventType.FEED: return EditFeed(navKey: timelineKey);
                                          case EventType.SLEEP: return EditSleep(navKey: timelineKey);
                                          case EventType.TOILET: return EditToilet(navKey: timelineKey);
                                        }
                                      }
                                  );
                                }
                            )
                        );

                        if (!mounted) return;

                        Streams().updateTimelineFlowTitle(formatDate(widget.today) ?? 'Daily Details');

                        if (newEvent != null) {
                          model.updateEvent(newEvent);
                        }
                      }
                      : null,
                      child: const Icon(Icons.edit),
                    ),
                  ),
                  Consumer<TimelineModel>(
                    builder: (context, model, _) => TextButton(
                      onPressed: model.selected > 0
                        ? () {
                          model.deleteSelection();
                        }
                        : null,
                      child: const Icon(Icons.delete),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Visibility(
            visible: isVisible,
            child: Expanded(
              child: Column(
                children: <Widget>[
                  buildRadioButton<TimelineModel, EventType?>(
                      label: 'Feed',
                      value: EventType.FEED,
                      groupValue: (model) => model.filter,
                      onChanged: (model, value) => model.filter = value
                  ),
                  buildRadioButton<TimelineModel, EventType?>(
                      label: 'Sleep',
                      value: EventType.SLEEP,
                      groupValue: (model) => model.filter,
                      onChanged: (model, value) => model.filter = value
                  ),
                  buildRadioButton<TimelineModel, EventType?>(
                      label: 'Toilet',
                      value: EventType.TOILET,
                      groupValue: (model) => model.filter,
                      onChanged: (model, value) => model.filter = value
                  ),
                  buildRadioButton<TimelineModel, EventType?>(
                      label: 'None',
                      value: null,
                      groupValue: (model) => model.filter,
                      onChanged: (model, value) => model.filter = value
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Consumer<TimelineModel>(
              builder: (context, model, _) => FutureBuilder(
                  future: model.eventList,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                      return const Center(child: Text("No events"));
                    } else if (snapshot.hasData) {
                      return ListView.builder(
                        itemBuilder: (context, index) => buildEventListItem(context, model, snapshot, index),
                        itemCount: snapshot.data!.length,
                      );
                    } else {
                      return const Center(child: Text("Error fetching events"));
                    }
                  }
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget? buildEventListItem(
    BuildContext context,
    TimelineModel model,
    AsyncSnapshot<List<EventListItem>> snapshot,
    int index
  ) {

    EventListItem item = snapshot.data![index];
    Event event = item.event;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: item.isSelected? const Color(0xffd3bbff): Colors.white,
        child: ListTile(
          tileColor: Colors.transparent,
          onTap: () async {
            if (model.selected == 0) {

              EventType? type = event.type;
              if (type == null) {
                // TODO: toast error
                return;
              }
              Event? newEvent = await timelineKey.currentState!.push(
                  MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider<DetailsModel>(
                          create: (context) => DetailsModel(event: event),
                          builder: (context, _) {
                            switch (type) {
                              case EventType.FEED: return const FeedDetails();
                              case EventType.SLEEP: return const SleepDetails();
                              case EventType.TOILET: return const ToiletDetails();
                            }
                          }
                      )
                  )
              );

              if (!mounted) return;

              Streams().updateTimelineFlowTitle(formatDate(widget.today) ?? 'Daily Details');

              if (newEvent != null) {
                model.updateEvent(newEvent);
              }
            } else {
              model.toggleSelect(item);
            }
          },
          onLongPress: () {
            model.toggleSelect(item);
          },
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(formatTime(event.time) ?? 'Error'),
              Text(event.type?.name ?? 'Error'),
              Text(formatInt(event.duration) ?? ''),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }

  Expanded buildRadioButton<T, U>({
    required String label,
    required U value,
    required U Function(T) groupValue,
    required void Function(T, U?)? onChanged,
    TextStyle? style,
  }) {
    return Expanded(
      child: Consumer<T>(
        builder: (context, model, _) {
          return RadioListTile(
            title: Text(label, style: style),
            value: value,
            groupValue: groupValue(model),
            onChanged: (value) {
              if (onChanged != null) {
                onChanged!(model, value);
              }
            }
          );
        },
      ),
    );
  }
}

class DailyStats extends StatefulWidget {
  const DailyStats({super.key});

  @override
  State<DailyStats> createState() => _DailyStatsState();
}

class _DailyStatsState extends State<DailyStats> {
  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FeedSummary(),
        SleepSummary(),
        ToiletSummary(),
      ],
    );
  }

}

class FeedSummary extends StatelessWidget {
  const FeedSummary({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('Feed', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        Row(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text('Left'),
                  Text('Right'),
                  Text('Bottle'),
                ],
              ),
            ),
            Column(
              children: <Widget>[
                DataLabel<TimelineModel>(getValue: (model) => (formatDuration(model.totalFeedDuration(FeedType.LEFT))) ?? '0m 0s'),
                DataLabel<TimelineModel>(getValue: (model) => (formatDuration(model.totalFeedDuration(FeedType.RIGHT))) ?? '0m 0s'),
                DataLabel<TimelineModel>(getValue: (model) => (formatDuration(model.totalFeedDuration(FeedType.BOTTLE))) ?? '0m 0s'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class SleepSummary extends StatelessWidget {
  const SleepSummary({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('Sleep', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        Row(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text('time'),
                ],
              ),
            ),
            Column(
              children: <Widget>[
                DataLabel<TimelineModel>(getValue: (model) => (formatDuration(model.totalSleepDuration()) ?? 'Error')),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class ToiletSummary extends StatelessWidget {
  const ToiletSummary({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text('Feed', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        Row(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text('Wet'),
                  Text('Dirty'),
                  Text('Both'),
                ],
              ),
            ),
            Column(
              children: <Widget>[
                DataLabel<TimelineModel>(getValue: (model) => model.wet.toString()),
                DataLabel<TimelineModel>(getValue: (model) => model.dirty.toString()),
                DataLabel<TimelineModel>(getValue: (model) => model.wetAndDirty.toString()),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
