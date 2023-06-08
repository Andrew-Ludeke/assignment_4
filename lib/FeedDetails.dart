import 'package:assignment_4/Daily.dart';
import 'package:assignment_4/DataLabel.dart';
import 'package:assignment_4/DetailsModel.dart';
import 'package:assignment_4/EditFeed.dart';
import 'package:assignment_4/EditModel.dart';
import 'package:assignment_4/Navigation.dart';
import 'package:assignment_4/Utilities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedDetails extends StatefulWidget {
  const FeedDetails({super.key});

  @override
  State<FeedDetails> createState() => _FeedDetailsState();
}

class _FeedDetailsState extends State<FeedDetails> {

  TextStyle labelStyle = const TextStyle(
    fontSize: 24,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget> [
          Align(
            alignment: Alignment.topRight,
            child: Consumer<DetailsModel>(
              builder: (context, model, _) => TextButton(
                onPressed: () {
                  timelineKey.currentState!.push(
                      MaterialPageRoute(
                          builder: (context) {
                            return ChangeNotifierProvider<EditModel>(
                                create: (context) => EditModel(event: model.event),
                                child: const EditFeed()
                            );
                          }
                      )
                  );
                },
                child: const Icon(Icons.edit),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text('Start Time', style: labelStyle),
                    Text('End Time', style: labelStyle,),
                    Text('Duration', style: labelStyle,),
                    Text('Feed Type', style: labelStyle,),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DataLabel<DetailsModel>(
                    getValue: (model) => formatTime(model.event.time) ?? 'Error',
                    style: labelStyle,
                  ),
                  DataLabel<DetailsModel>(
                    getValue: (model) => formatTime(model.endTime) ?? 'Error',
                    style: labelStyle,
                  ),
                  DataLabel<DetailsModel>(
                    getValue: (model) => formatDuration(model.duration) ?? 'Error',
                    style: labelStyle,
                  ),
                  DataLabel<DetailsModel>(
                    getValue: (model) => model.feedType?.name ?? 'None',
                    style: labelStyle,
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: Consumer<DetailsModel>(
                  builder: (context, model, _) {
                    TextEditingController notesController = TextEditingController();
                    notesController.text = model.event.notes ?? '';

                    return const TextField(
                      enabled: false,
                      maxLines: null,
                      expands: true,
                      decoration: InputDecoration(hintText: 'No notes'),
                    );
                  }
              ),
            ),
          ),
        ]
      ),
    );
  }
}