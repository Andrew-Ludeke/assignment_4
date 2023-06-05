import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:assignment_4/EditModel.dart';


class Timer extends StatefulWidget {
  const Timer({super.key});

  @override
  State<Timer> createState() => _TimerState();
}

class _TimerState extends State<Timer> {

  String format(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 32.0, bottom: 32.0),
          child: Consumer<EditModel>(
            builder: (context, model, _) => Text(
              format(
                  model.endTime
                      ?.difference(model.time ?? model.endTime!)
                      ?? const Duration(seconds: 0)
              ),
              style: const TextStyle(fontSize: 26.0),
            ),
          ),
        ),
        Consumer<EditModel>(
          builder: (context, model, _) => ElevatedButton(
            onPressed: model.toggleTimer,
            child: Text(!model.isTiming ? "Begin" : "Stop"),
          ),
        ),
      ],
    );
  }
}