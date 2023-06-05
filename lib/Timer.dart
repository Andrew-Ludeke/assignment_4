import 'package:flutter/material.dart';
import 'dart:async' as async;
import 'package:provider/provider.dart';
import 'package:assignment_4/EditModel.dart';


class Timer extends StatefulWidget {
  const Timer({super.key});

  @override
  State<Timer> createState() => _TimerState();
}

class _TimerState extends State<Timer> with AutomaticKeepAliveClientMixin<Timer> {

  late async.Timer timer;

  bool _wantKeepAlive = true;
  @override
  bool get wantKeepAlive => _wantKeepAlive;

  @override
  void initState() {
    super.initState();

    timer = async.Timer.periodic(const Duration(seconds: 1), (_) {});
    timer.cancel();
  }

  String format(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  void tick (EditModel model, async.Timer t) {
    model.endTime = DateTime.now();
  }

  void toggleTimer (EditModel model) {
    if (timer.isActive) {
      timer.cancel();
      model.endTime = DateTime.now();
    } else {
      model.time = DateTime.now();
      model.endTime = DateTime.now();
      timer = async.Timer.periodic(const Duration(seconds: 1), (t) => tick(model, t));
    }
  }

  @override
  Widget build(BuildContext context) {
    EditModel model = Provider.of<EditModel>(context, listen: true);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 32.0, bottom: 32.0),
          child: Text(
            format(
                model.endTime
                    ?.difference(model.time ?? model.endTime!)
                    ?? const Duration(seconds: 0)
            ),
            style: const TextStyle(fontSize: 26.0),
          ),
        ),
        ElevatedButton(
          onPressed: () => toggleTimer(model),
          child: const Text("Begin"),
        ),
      ],
    );
  }
}