import 'package:assignment_4/StreamProvider.dart';
import 'package:assignment_4/model/EditModel.dart';
import 'package:assignment_4/enum/FeedType.dart';
import 'package:assignment_4/edit/TimingContainer.dart';
import 'package:assignment_4/model/Event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditFeed extends StatefulWidget {
  const EditFeed({super.key, required this.navKey, this.isEditing = false});

  final GlobalKey<NavigatorState> navKey;
  final bool isEditing;

  @override
  State<EditFeed> createState() => _EditFeedState();
}

class _EditFeedState extends State<EditFeed> {

  final TextStyle radioStyle = const TextStyle(fontSize: 9.0);


  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      Streams().updateTimelineFlowTitle('Edit Feed');
    } else {
      Streams().updateHomeFlowTitle('Edit Feed');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TimingContainer(isEditing: widget.isEditing),
          const Align(
            alignment: Alignment.bottomLeft,
            child: Text('Feed Type', style: TextStyle(fontSize: 24.0)),
          ),
          Row(
            children: [
              buildRadioButton('Left', FeedType.LEFT),
              buildRadioButton('Right', FeedType.RIGHT),
              buildRadioButton('Bottle', FeedType.BOTTLE),
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

  Expanded buildRadioButton(String label, FeedType type) {
    return Expanded(
      child: Consumer<EditModel>(
        builder: (context, model, _) {
          return RadioListTile(
            title: Text(label, style: radioStyle),
            value: type,
            groupValue: model.feedType,
            onChanged: (type) => model.feedType = type,
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

          EditModel model = Provider.of<EditModel>(context, listen: false);

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
