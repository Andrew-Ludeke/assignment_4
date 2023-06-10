import 'dart:io';

import 'package:assignment_4/model/Event.dart';
import 'package:assignment_4/widgets/DataLabel.dart';
import 'package:assignment_4/model/DetailsModel.dart';
import 'package:assignment_4/model/EditModel.dart';
import 'package:assignment_4/edit/EditToilet.dart';
import 'package:assignment_4/Navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

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
    return WillPopScope(
      onWillPop: () async {
        final DetailsModel model = Provider.of<DetailsModel>(context, listen: false);
        Event? event = model.isDirty ? model.event.copy() : null;
        timelineKey.currentState!.pop(event);
        //final bool isStackEmpty = !await timelineKey.currentState!.maybePop();
        return false;
        /*
        final bool isStackEmpty = !await timelineKey.currentState!.maybePop();
        if (!isStackEmpty) {
          return false;
        }
        return true;
        */
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            children: <Widget> [
              Align(
                alignment: Alignment.topRight,
                child: Consumer<DetailsModel>(
                  builder: (context, model, _) => TextButton(
                    onPressed: () async {
                      Event? newEvent = await timelineKey.currentState!.push(
                          MaterialPageRoute(
                              builder: (context) {
                                return ChangeNotifierProvider<EditModel>(
                                    create: (context) => EditModel(event: model.event.copy()),
                                    child: EditToilet(navKey: timelineKey)
                                );
                              }
                          )
                      );

                      if (!mounted) return;

                      if (newEvent != null) {
                        model.isDirty = true;
                        model.updateEvent(newEvent);
                      }
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
                builder:(context, model, _) => FutureBuilder(
                    future: model.imgFile,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        XFile? img = snapshot.data;

                        if (img == null) {
                          return Image.asset(
                            'assets/images/placeholder.png',
                            height: 180,
                          );
                        }

                        return Image.file(
                          File(img.path),
                          height: 180,
                        );
                      } else {
                        return const SizedBox(
                          height: 180,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                    }
                )
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
      ),
    );
  }
}
