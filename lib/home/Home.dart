import 'package:assignment_4/StreamProvider.dart';
import 'package:assignment_4/enum/EventType.dart';
import 'package:assignment_4/model/EditModel.dart';
import 'package:assignment_4/model/Event.dart';
import 'package:flutter/material.dart';
import 'package:assignment_4/edit/EditFeed.dart';
import 'package:assignment_4/edit/EditSleep.dart';
import 'package:assignment_4/edit/EditToilet.dart';
import 'package:assignment_4/home/RecordButton.dart';
import 'package:assignment_4/Navigation.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.title});

  final String title;

  @override
  State<Home> createState() =>  _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RecordButton(
          type: EventType.FEED,
          message: "Time since last:",
          onPressed: () async {
            await homeKey.currentState!.push(MaterialPageRoute(builder: (context) {
              return ChangeNotifierProvider<EditModel>(
                create: (context) => EditModel(event: Event(type: EventType.FEED)),
                child: EditFeed(navKey: homeKey)
              );
            }));

            if (!mounted) return;

            Streams().updateHomeFlowTitle("Home");
          },
        ),
        const SizedBox(height: 75.0),
        RecordButton(
          type: EventType.SLEEP,
          message: "Time since last:",
          onPressed: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ChangeNotifierProvider<EditModel>(
                  create: (context) => EditModel(event: Event(type: EventType.SLEEP)),
                  child: EditSleep(navKey: homeKey)
              );
            }));

            if (!mounted) return;

            Streams().updateHomeFlowTitle("Home");
          },
        ),
        const SizedBox(height: 75.0),
        RecordButton(
          type: EventType.TOILET,
          message: "Time since last:",
          onPressed: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ChangeNotifierProvider<EditModel>(
                  create: (context) => EditModel(event: Event(type: EventType.TOILET)),
                  child: EditToilet(navKey: homeKey)
              );
            }));

            if (!mounted) return;

            Streams().updateHomeFlowTitle("Home");
          },
        ),
      ],
    );
  }
}