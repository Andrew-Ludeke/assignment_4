import 'package:assignment_4/EditModel.dart';
import 'package:assignment_4/Event.dart';
import 'package:flutter/material.dart';
import 'package:assignment_4/EditFeed.dart';
import 'package:assignment_4/EditSleep.dart';
import 'package:assignment_4/EditToilet.dart';
import 'package:assignment_4/RecordButton.dart';
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
          title: "Feed",
          message: "Time since last feed event:",
          onPressed: () {
            homeKey.currentState!.push(MaterialPageRoute(builder: (context) {
              return ChangeNotifierProvider<EditModel>(
                create: (context) => EditModel(event: Event()),
                child: const EditFeed()
              );
            }));
          },
        ),
        RecordButton(
          title: "Sleep",
          message: "Time since last sleep event:",
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ChangeNotifierProvider<EditModel>(
                  create: (context) => EditModel(event: Event()),
                  child: const EditSleep()
              );
            }));
          },
        ),
        RecordButton(
          title: "Toilet",
          message: "Time since last toilet event:",
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const EditToilet();
            }));
          },
        ),
      ],
    );
  }
}