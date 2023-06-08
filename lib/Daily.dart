import 'package:assignment_4/DataLabel.dart';
import 'package:assignment_4/DetailsModel.dart';
import 'package:assignment_4/Enums/EventType.dart';
import 'package:assignment_4/Enums/FeedType.dart';
import 'package:assignment_4/Event.dart';
import 'package:assignment_4/FeedDetails.dart';
import 'package:assignment_4/Navigation.dart';
import 'package:assignment_4/SleepDetails.dart';
import 'package:assignment_4/TimelineModel.dart';
import 'package:assignment_4/ToiletDetails.dart';
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
  bool selectionMode = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TimelineModel>(
      create: (context) => TimelineModel(today: widget.today),
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
          const Center(child: Padding(
            padding: EdgeInsets.all(0.0),
            child: DailyStats(),
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text('Recorded Events', style: TextStyle(fontSize: 24.0)),
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
                      ? () {
                          // TODO: Navigate edit
                      }
                      : null,
                      child: const Icon(Icons.edit),
                    ),
                  ),
                  Consumer<TimelineModel>(
                    builder: (context, model, _) => TextButton(
                      onPressed: model.selected > 0
                        ? () {
                          // TODO: Delete selection
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
                //mainAxisAlignment: MainAxisAlignment.end,
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
              builder: (context, model, _) => ListView.builder(
                itemBuilder: (context, index) => buildEventListItem(context, model, index),
                itemCount: model.eventList.length,
              ),
            ),
          ),
        ],
      )
    );
  }

  Widget? buildEventListItem(BuildContext context, TimelineModel model, int index) {
    //Event event = model.eventList[index];
    EventListItem item = model.eventList[index];
    Event event = item.event;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        tileColor: item.isSelected? Colors.black12 : Colors.white12,
        onTap: () {
          if (model.selected == 0) {
            switch(event.type) {
              case EventType.FEED:
                timelineKey.currentState!.push(
                    MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider<DetailsModel>(
                            create: (context) => DetailsModel(event: event),
                            child: const FeedDetails()
                        )
                    )
                );
              case EventType.SLEEP:
                timelineKey.currentState!.push(
                    MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider<DetailsModel>(
                            create: (context) => DetailsModel(event: event),
                            child: const SleepDetails()
                        )
                    )
                );
              case EventType.TOILET:
              timelineKey.currentState!.push(
                  MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider<DetailsModel>(
                          create: (context) => DetailsModel(event: event),
                          child: const ToiletDetails()
                      )
                  )
              );
              default:
                // TODO: Display "data corrupt" toast
                break;
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
    );
  }

  Expanded buildRadioButton<T, U>({
    required String label,
    required U value,
    required U Function(T) groupValue,
    required void Function(T, U?)? onChanged
  }) {

    const TextStyle radioStyle = TextStyle();//TextStyle(fontSize: 9.0);

    return Expanded(
      child: Consumer<T>(
        builder: (context, model, _) {
          return RadioListTile(
            title: Text(label, style: radioStyle),
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
