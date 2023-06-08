import 'dart:io';

import 'package:assignment_4/timeline/Daily.dart';
import 'package:assignment_4/widgets/DataLabel.dart';
import 'package:assignment_4/model/DetailsModel.dart';
import 'package:assignment_4/model/EditModel.dart';
import 'package:assignment_4/edit/EditToilet.dart';
import 'package:assignment_4/Navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Utilities.dart';

class ToiletDetails extends StatefulWidget {
  const ToiletDetails({super.key});

  @override
  State<ToiletDetails> createState() => _ToiletDetailsState();
}

class _ToiletDetailsState extends State<ToiletDetails> {

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
                                  child: const EditToilet()
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
                      Text('Contents', style: labelStyle,),
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
                      getValue: (model) => (model.event.toiletContents?.name ?? 'None'),
                      style: labelStyle,
                    ),
                  ],
                ),
              ],
            ),
            Consumer<DetailsModel>(
              builder: (context, model, _) {
                    File? img = model.imgFile;
                    if (img == null) {
                      return Image.asset(
                        'assets/images/placeholder.png', height: 180,
                      );
                    }

                    return Image.file(File(img.path));
              },
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
