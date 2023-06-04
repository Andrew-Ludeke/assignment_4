import 'package:assignment_4/Event.dart';
import 'package:assignment_4/TimingContainer.dart';
import 'package:flutter/material.dart';
import 'dart:async' as async;
import 'package:provider/provider.dart';


class Timer extends StatefulWidget {
  const Timer({super.key});

  @override
  State<Timer> createState() => _TimerState();
}

class _TimerState extends State<Timer> with AutomaticKeepAliveClientMixin<Timer> {

  bool isTiming = false;

  late async.Timer timer;

  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  //DateTime start = DateTime.now();
  //DateTime now = DateTime.now();

  //late Event event;
  //late TimingModel model;

  @override
  void initState() {
    super.initState();

    timer = async.Timer.periodic(const Duration(seconds: 1), (_) {});
    timer.cancel();

    //model = Provider.of<TimingModel>(context, listen: false);
    //model = TimingModel();
  }


  void time() async {
    while (isTiming) {
      //await Future
    }
  }

  /*
  void toggleTimer () {
    if (timer.isActive) {
      isTiming = false;
      if (timer.isActive) timer.cancel();
    } else {
      //isTiming = true;
      model.setTime(DateTime.now());
      model.setEndTime(DateTime.now());
      /*
      setState(() {
        start = DateTime.now();
        now = DateTime.now();
      });
      */
      timer = async.Timer.periodic(const Duration(seconds: 1), tick);
    }
  }
  */

  /*
  void tick (async.Timer t) {
    /*
    setState(() {
      now = DateTime.now();
    });
    */
    model.setEndTime(DateTime.now());
  }
  */

  void tick (TimingModel model, async.Timer t) {
    model.setEndTime(DateTime.now());
  }

  void toggleTimer (TimingModel model) {
    if (timer.isActive) {
      timer.cancel();
      model.setEndTime(DateTime.now());
    } else {
      model.setTime(DateTime.now());
      model.setEndTime(DateTime.now());
      timer = async.Timer.periodic(const Duration(seconds: 1), (t) => tick(model, t));
    }
  }


  bool _wantKeepAlive = true;

  @override
  bool get wantKeepAlive => _wantKeepAlive;

  @override
  Widget build(BuildContext context) {
    TimingModel model = Provider.of<TimingModel>(context, listen: true);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 32.0, bottom: 32.0),
          child: Text(
            //format(now.difference(start)),
            format(
                model.endTime
                    ?.difference(model.time ?? model.endTime!)
                    ?? const Duration(seconds: 0)
            ),
            style: const TextStyle(fontSize: 26.0),
          ),
        ),
        ElevatedButton(
          //onPressed: toggleTimer,
          onPressed: () => toggleTimer(model),
          child: const Text("Begin"),
        ),
      ],
    );
  }
}
