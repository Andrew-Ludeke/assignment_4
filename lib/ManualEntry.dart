import 'package:flutter/material.dart';

class ManualEntry extends StatefulWidget {
  const ManualEntry({super.key});

  @override
  State<ManualEntry> createState() => _ManualEntryState();
}

class _ManualEntryState extends State<ManualEntry> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        TimeEntryRow(label: "Start Time", hint: 'enter start time'),
        TimeEntryRow(label: "End Time", hint: 'enter end time'),
      ],
    );
  }
}

class TimeEntryRow extends StatefulWidget {
  const TimeEntryRow({
    super.key, required this.label, required this.hint,
  });

  final String label;
  final String hint;

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
            child: TextField(
              controller: controller,
              decoration: InputDecoration(hintText: widget.hint),
            ),
          ),
        ),
      ],
    );
  }
}
