import 'package:assignment_4/EditModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ManualEntry extends StatefulWidget {
  const ManualEntry({super.key});

  @override
  State<ManualEntry> createState() => _ManualEntryState();
}

class _ManualEntryState extends State<ManualEntry> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: Column(
        children: <Widget>[
          TimeEntryRow(
              label: "Start Time",
              buildFunction: buildStartTextField,
          ),
          TimeEntryRow(
            label: "End Time",
            buildFunction: buildEndTextField,
          ),
        ],
      ),
    );
  }

  TextField buildStartTextField(BuildContext context, EditModel model, _) {

    TextEditingController controller = TextEditingController();

    // controller.text = DateFormat.Hms().format(model.time ?? DateTime.now());
    if (model.time != null) {
      controller.text = DateFormat.Hms().format(model.time!);
    }

    return TextField(
      controller: controller,
      readOnly: true,
      onTap: () async {
        TimeOfDay? time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(model.time ?? DateTime.now())
        );

        if (time == null) return;

        DateTime now = DateTime.now();
        DateTime? date = DateTime(
          model.time?.year ?? now.year,
          model.time?.month ?? now.month,
          model.time?.day ?? now.day,
          time.hour,
          time.minute,
        );
        model.time = date;
      },
      decoration: const InputDecoration(hintText: 'enter start time'),
    );
  }

  TextField buildEndTextField(BuildContext context, EditModel model, _) {
    TextEditingController controller = TextEditingController();
    //controller.text = DateFormat.Hms().format(model.endTime ?? DateTime.now());

    if (model.endTime != null) {
      controller.text = DateFormat.Hms().format(model.endTime ?? DateTime.now());
    }

    return TextField(
      controller: controller,
      readOnly: true,
      onTap: () async {
        TimeOfDay? time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(model.endTime ?? DateTime.now())
        );

        if (time == null) return;

        DateTime now = DateTime.now();
        DateTime? date = DateTime(
          model.endTime?.year ?? now.year,
          model.endTime?.month ?? now.month,
          model.endTime?.day ?? now.day,
          time.hour,
          time.minute,
        );

        model.endTime = date;
      },
      decoration: const InputDecoration(hintText: 'enter end time'),
    );
  }
}

class TimeEntryRow extends StatefulWidget {
  const TimeEntryRow({
    super.key, required this.label, required this.buildFunction,
  });

  final String label;
  final Widget Function(BuildContext, EditModel, Widget?) buildFunction;

  @override
  State<TimeEntryRow> createState() => _TimeEntryRowState();
}

class _TimeEntryRowState extends State<TimeEntryRow> {

  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          widget.label,
          textAlign: TextAlign.right,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32.0, right: 32.0),
          child: SizedBox(
              width: 200,
            child: Consumer<EditModel>(
              builder: widget.buildFunction,//buildStartTextField,
            ),
          ),
        ),
      ],
    );
  }
}