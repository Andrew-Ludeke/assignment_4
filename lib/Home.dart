import 'package:flutter/material.dart';
import 'package:assignment_4/EditFeed.dart';
import 'package:assignment_4/EditSleep.dart';
import 'package:assignment_4/EditToilet.dart';
import 'package:assignment_4/RecordButton.dart';
import 'package:assignment_4/Navigation.dart';

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
              return const EditFeed();
            }));
          },
        ),
        RecordButton(
          title: "Sleep",
          message: "Time since last sleep event:",
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const EditSleep();
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