import 'package:assignment_4/model/EditModel.dart';
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
              buildFunction: (context, model, _)
                => buildTextField(
                    context: context,
                    model: model,
                    getTime: (mdl) => mdl.time,
                    setTime: (mdl, value) => mdl.time = value,
                    hint: 'enter start time'
              ),
          ),
          TimeEntryRow(
            label: "End Time",
            buildFunction: (context, model, _)
              => buildTextField(
                  context: context,
                  model: model,
                  getTime: (model) => model.endTime,
                  setTime: (model, value) => model.endTime = value,
                  hint: 'enter end time'
            ),
          ),
        ],
      ),
    );
  }
}

TextField buildTextField(
    {
      required BuildContext context,
      required EditModel model,
      required DateTime? Function(EditModel) getTime,
      required void Function(EditModel, DateTime?) setTime,
      String? hint,
    }
    ) {
  TextEditingController controller = TextEditingController();

  DateTime? modelTime = getTime(model);

  if (modelTime != null) {
    controller.text = DateFormat.Hms().format(modelTime);
  }

  return TextField(
    controller: controller,
    readOnly: true,
    onTap: () async {
      TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(modelTime ?? DateTime.now())
      );

      if (pickedTime == null) return;

      DateTime now = DateTime.now();
      DateTime? date = DateTime(
        modelTime?.year ?? now.year,
        modelTime?.month ?? now.month,
        modelTime?.day ?? now.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      setTime(model, date);
    },
    decoration: const InputDecoration(hintText: 'enter end time'),
  );
}

class TimeEntryRow extends StatefulWidget {
  const TimeEntryRow({
    super.key, required this.label, required this.buildFunction, this.hint = '',
  });

  final String label;
  final String hint;
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
              builder: widget.buildFunction,
            ),
          ),
        ),
      ],
    );
  }
}