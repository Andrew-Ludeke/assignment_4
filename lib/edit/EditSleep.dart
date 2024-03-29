import 'package:assignment_4/StreamProvider.dart';
import 'package:assignment_4/model/EditModel.dart';
import 'package:assignment_4/edit/TimingContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditSleep extends StatefulWidget {
  const EditSleep({super.key, required this.navKey, this.isEditing = false});

  final GlobalKey<NavigatorState> navKey;
  final bool isEditing;

  @override
  State<EditSleep> createState() => _EditSleepState();
}

class _EditSleepState extends State<EditSleep> {

  final TextStyle radioStyle = const TextStyle(fontSize: 9.0);

  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    if (widget.isEditing) {
      Streams().updateTimelineFlowTitle("Edit Sleep");
    } else {
      Streams().updateHomeFlowTitle("Edit Sleep");
    }
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        if (isSaving) return false;
        confirmDiscard(context);
        return false;
      },
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TimingContainer(isEditing: widget.isEditing),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 64.0),
                    child: Consumer<EditModel>(
                        builder: buildNotes
                    ),
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
                          onPressed: model.validate().isEmpty
                              ? () => confirmSave(context, model)
                              : () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Error: please enter ${model.validate().join(', ')}."),
                                duration: const Duration(seconds: 2),
                          )),
                          child: const Text('Save')
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Offstage(
            offstage: !isSaving,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        ],
      ),
    );
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

  void confirmSave(BuildContext context, EditModel model) {

    TextButton confirmButton = TextButton(
        onPressed: () {
          setState(() {
            isSaving = true;
          });
          Navigator.of(context, rootNavigator: true).pop();
          model.persist().then( (_) {
            setState(() {
              isSaving = false;
            });
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
        title: const Text('Save'),
        content: const Text('Are you sure you want to save this session?'),
        actions: [
          confirmButton,
          denyButton,
        ],
      ),
    );
  }
}