import 'package:assignment_4/EditModel.dart';
import 'package:assignment_4/Enums/FeedType.dart';
import 'package:assignment_4/TimingContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditFeed extends StatefulWidget {
  const EditFeed({super.key});

  @override
  State<EditFeed> createState() => _EditFeedState();
}

class _EditFeedState extends State<EditFeed> {

  final TextStyle radioStyle = const TextStyle(fontSize: 9.0);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditModel>(
      create: (context) => EditModel(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const TimingContainer(),
            const Align(
              alignment: Alignment.bottomLeft,
              child: Text("Feed Type", style: TextStyle(fontSize: 24.0)),
            ),
            Row(
              children: [
                buildRadioButton("Left", FeedType.LEFT),
                buildRadioButton("Right", FeedType.RIGHT),
                buildRadioButton("Bottle", FeedType.BOTTLE),
              ],
            ),
            Expanded(
              child: Consumer<EditModel>(
                  builder: buildNotes
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <ElevatedButton>[
                ElevatedButton(
                    onPressed: null,
                    child: Text('Discard')
                ),
                ElevatedButton(
                    onPressed: null,
                    child: Text('Save')
                ),
              ],
            )
          ],
        ),
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
      decoration: const InputDecoration(hintText: "Notes"),
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
}
