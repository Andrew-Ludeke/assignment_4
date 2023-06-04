import 'package:assignment_4/Enums/FeedType.dart';
import 'package:assignment_4/Event.dart';
import 'package:assignment_4/TimingContainer.dart';
import 'package:flutter/material.dart';
import 'package:assignment_4/Navigation.dart';

class EditFeed extends StatefulWidget {
  const EditFeed({super.key});

  @override
  State<EditFeed> createState() => _EditFeedState();
}

class _EditFeedState extends State<EditFeed> {

  Event event = Event();

  final TextStyle radioStyle = const TextStyle(fontSize: 9.0);

  void setFeedType(FeedType? type) {
    setState(() {
      event.feedType = type;
    });
  }

  TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const TimingContainer(),
            const Align(
              alignment: Alignment.bottomLeft,
              child: Text("Feed Type", style: TextStyle(fontSize: 24.0)),
            ),
            Row(
              children: [
                buildRadioButton("Left", FeedType.LEFT),
                buildRadioButton("Right", FeedType.RIGHT),
                buildRadioButton("Bottle", FeedType.BOTTLE),
              ],
            ),
            Expanded(
              child: TextField(
                controller: notesController,
                keyboardType: TextInputType.multiline,
                expands: true,
                maxLines: null,
                decoration: const InputDecoration(hintText: "Notes"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded buildRadioButton(String label, FeedType type) {
    return Expanded(
      child: RadioListTile(
        title: Text(label, style: radioStyle),
        value: type,
        groupValue: event.feedType,
        onChanged: setFeedType
      ),
    );
  }
}
