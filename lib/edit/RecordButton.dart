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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(widget.type.description),
          Row(
            children: <Widget>[
              Text(widget.message),
              Consumer<HomeModel>(
                  builder: (context, model, _) {
                    return Text(formatDuration(model.timeSince(widget.type)) ?? "N/A");
                  }
              ),
            ],
          ),
        ],
      ),
    );
  }
}
