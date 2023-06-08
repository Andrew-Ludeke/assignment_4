import 'package:flutter/material.dart';

class RecordButton extends StatefulWidget {
  const RecordButton(
      {super.key,
        required this.title,
        required this.message,
        required this.onPressed});

  final String title;
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
          Text(widget.title),
          Row(
            children: <Widget>[Text(widget.message), Text("$time")],
          ),
        ],
      ),
    );
  }
}
