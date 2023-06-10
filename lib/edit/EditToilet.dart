import 'dart:io';

import 'package:assignment_4/model/EditModel.dart';
import 'package:assignment_4/enum/ToiletContents.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditToilet extends StatefulWidget {
  const EditToilet({super.key, required this.navKey});

  final GlobalKey<NavigatorState> navKey;

  @override
  State<EditToilet> createState() => _EditToiletState();
}

class _EditToiletState extends State<EditToilet> {

  bool isVisible = false;
  void toggleVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TimeEntryRow(
            label: "Time",
            buildFunction: (context, model, _) => buildTextField(
                context: context,
                model: model,
                getTime: (mdl) => mdl.time,
                setTime: (mdl, value) => mdl.time = value,
                hint: 'enter time'
            ),
          ),
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: Consumer<EditModel>(
                    builder: (context, model, _) => FutureBuilder(
                      future: model.imgFile,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            XFile? img = snapshot.data;

                            if (img == null) {
                              return Image.asset(
                                'assets/images/placeholder.png',
                                height: 180,
                              );
                            }

                            return Image.file(
                              File(img.path),
                              height: 180,
                            );
                          } else {
                            return const SizedBox(
                              height: 180,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                        }
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: toggleVisibility,
                        child: const Icon(Icons.add),
                      ),
                      Visibility(
                        visible: isVisible,
                        child: Column(
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                Future<XFile?> pickImage() async {
                                  ImagePicker picker = ImagePicker();
                                  XFile? img = await picker.pickImage(source: ImageSource.gallery);
                                  return img;
                                }
                                EditModel model = Provider.of<EditModel>(context, listen: false);
                                model.imgFile = pickImage();
                              },
                              child: const Icon(Icons.folder),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                Future<XFile?> pickImage() async {
                                  ImagePicker picker = ImagePicker();
                                  return await picker.pickImage(source: ImageSource.camera);
                                }
                                EditModel model = Provider.of<EditModel>(context, listen: false);
                                model.imgFile = pickImage();
                              },
                              child: const Icon(Icons.camera),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                EditModel model = Provider.of<EditModel>(context, listen: false);
                                if (model.imgPath == null) {
                                  model.imgUri = null;
                                }
                                model.imgFile = Future.value(null);
                              },
                              child: const Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const Align(
            alignment: Alignment.bottomLeft,
            child: Text('Contents', style: TextStyle(fontSize: 24.0)),
          ),
          Row(
            children: [
              buildCheckBox(
                label: 'Wet',
                checkedWhen: (model) =>
                model.toiletContents == ToiletContents.WET
                    ||  model.toiletContents == ToiletContents.WET_AND_DIRTY,
                onChanged: (model, value) {
                  if (value == null) return;

                  switch(model.toiletContents) {
                    case ToiletContents.WET:
                      model.toiletContents = ToiletContents.EMPTY;
                    case ToiletContents.DIRTY:
                      model.toiletContents = ToiletContents.WET_AND_DIRTY;
                    case ToiletContents.WET_AND_DIRTY:
                      model.toiletContents = ToiletContents.DIRTY;
                    default:
                      model.toiletContents = ToiletContents.WET;
                  }
                },
              ),
              buildCheckBox(
                label: 'Dirty',
                checkedWhen: (model) =>
                model.toiletContents == ToiletContents.DIRTY
                    ||  model.toiletContents == ToiletContents.WET_AND_DIRTY,
                onChanged: (model, value) {
                  if (value == null) return;

                  switch(model.toiletContents) {
                    case ToiletContents.WET:
                      model.toiletContents = ToiletContents.WET_AND_DIRTY;
                    case ToiletContents.DIRTY:
                      model.toiletContents = ToiletContents.EMPTY;
                    case ToiletContents.WET_AND_DIRTY:
                      model.toiletContents = ToiletContents.WET;
                    default:
                      model.toiletContents = ToiletContents.DIRTY;
                  }
                },
              ),
            ],
          ),
          Expanded(
            child: Consumer<EditModel>(
                builder: buildNotes
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Consumer<EditModel>(
                builder: (context, model, _) => ElevatedButton(
                    onPressed: () => confirmDiscard(context),
                    child: const Text('Discard')
                ),
              ),
              Consumer<EditModel>(
                builder: (context, model, _) => ElevatedButton(
                    onPressed: () => confirmSave(context),
                    child: const Text('Save')
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<Image> buildImage(EditModel model) async {
    XFile? img = await model.imgFile;
    if (img == null) {
      return Image.asset(
        'assets/images/placeholder.png', height: 180,
      );
    }

    return Image.file(File(img.path));
  }

  Widget buildNotes(context, model, _) {
    TextEditingController notesController = TextEditingController();

    notesController.text = model.notes ?? '';
    notesController.selection = TextSelection.collapsed(
        offset: notesController.text.length
    );

    return TextField(
      controller: notesController,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      expands: true,
      decoration: const InputDecoration(hintText: 'Notes'),
      onChanged: (value) => model.notes = value,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
    );
  }

  static bool defaultCheckboxValue(EditModel model) => false;

  Expanded buildCheckBox({
    String label = '',
    bool Function(EditModel) checkedWhen = defaultCheckboxValue,
    void Function(EditModel, bool?)? onChanged
  }) {
    void defaultCheckboxOnChanged(EditModel model, bool? value) {}
    return Expanded(
      child: Consumer<EditModel>(
        builder: (context, model, _) {
          return CheckboxListTile(
            title: Text(label),
            value: checkedWhen(model),
            onChanged: (value) => (onChanged ?? defaultCheckboxOnChanged)(model, value),
          );
        },
      ),
    );
  }

  void confirmDiscard(BuildContext context) {
    TextButton confirmButton = TextButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
          widget.navKey.currentState?.pop(null);
        },
        child: const Text('Discard')
    );

    TextButton denyButton = TextButton(
        onPressed: () async {
          Navigator.of(context, rootNavigator: true).pop();
        },
        child: const Text('Cancel')
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Discard'),
        content: const Text('Are you sure you want to discard this session?'),
        actions: [
          confirmButton,
          denyButton,
        ],
      ),
    );
  }

  void confirmSave(BuildContext context) {
    EditModel model = Provider.of<EditModel>(context, listen: false);

    TextButton confirmButton = TextButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
          model.persist().then( (_) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Event saved!"),
              duration: Duration(seconds: 2),
            ));
            widget.navKey.currentState?.pop(model.event.copy());
          });
        },
        child: const Text('Save')
    );

    TextButton denyButton = TextButton(
        onPressed: () async {
          Navigator.of(context, rootNavigator: true).pop();
        },
        child: const Text('Cancel')
    );

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Discard'),
        content: const Text('Are you sure you want to discard this session?'),
        actions: [
          confirmButton,
          denyButton,
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
    decoration: const InputDecoration(hintText: 'enter time'),
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