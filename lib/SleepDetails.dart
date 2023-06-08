import 'package:assignment_4/Daily.dart';
import 'package:assignment_4/DataLabel.dart';
import 'package:assignment_4/DetailsModel.dart';
import 'package:assignment_4/EditModel.dart';
import 'package:assignment_4/EditSleep.dart';
import 'package:assignment_4/Navigation.dart';
import 'package:assignment_4/Utilities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SleepDetails extends StatefulWidget {
  const SleepDetails({super.key});

  @override
  State<SleepDetails> createState() => _SleepDetailsState();
}

class _SleepDetailsState extends State<SleepDetails> {

  TextStyle labelStyle = const TextStyle(
    fontSize: 24,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
          children: <Widget> [
            Padding(
              padding: const EdgeInsets.only(top: 16.0, right: 16.0, bottom: 32.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Consumer<DetailsModel>(
                  builder: (context, model, _) => TextButton(
                    onPressed: () {
                      timelineKey.currentState!.push(
                          MaterialPageRoute(
                              builder: (context) {
                                return ChangeNotifierProvider<EditModel>(
                                    create: (context) => EditModel(event: model.event),
                                    child: const EditSleep()
                                );
                              }
                          )
                      );
                    },
                    child: const Icon(Icons.edit),
                  ),
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
                      getValue: (model) => formatTime(model.event.endTime) ?? 'Error',
                      style: labelStyle,
                    ),
                    DataLabel<DetailsModel>(
                      getValue: (model) => formatDuration(model.duration) ?? 'Error',
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
