import 'package:assignment_4/Utilities.dart';
import 'package:assignment_4/enum/EventType.dart';
import 'package:assignment_4/model/home_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecordButton extends StatefulWidget {
  const RecordButton(
      {super.key,
        required this.type,
        required this.message,
        required this.onPressed});

  final EventType type;
  final String message;
  final void Function()? onPressed;

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {
  int time = 0;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                widget.type.description,
                style: const TextStyle(fontSize: 28.0),
              ),
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Text(
                    widget.message,
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ),
                Consumer<HomeModel>(
                    builder: (context, model, _) {
                      return Text(
                        formatDuration(model.timeSince(widget.type)) ?? "N/A",
                        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      );
                    }
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
