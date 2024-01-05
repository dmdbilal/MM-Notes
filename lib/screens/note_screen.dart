// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:mm_notes/models/note_model.dart';
import 'package:mm_notes/services/database_helper.dart';
import 'package:intl/intl.dart';
import 'package:mm_notes/util/Date.dart';
import 'package:mm_notes/widgets/hide_btn_widget.dart';

class NoteScreen extends StatefulWidget {
  final Note? note;

  NoteScreen({Key? key, this.note}) : super(key: key);

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  late final titleController;
  late final descController;
  bool hideNote = false;
  late Note? note;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descController = TextEditingController();

    note = widget.note;
    if (note != null) {
      titleController.text = note!.title;
      descController.text = note!.description;
      hideNote = note!.hidden == 1;
    }
  }

  @override
  Widget build(BuildContext context) { 
    
    // String time = DateFormat.jm(DateTime.now()).toString();
    // String date = DateFormat.MMMd(DateTime.now()).toString();
    String time = DateFormat("jm").format(DateTime.now()).toString();
    String date = DateFormat("MMMM d").format(DateTime.now()).toString();
    String day = DateFormat("E").format(DateTime.now()).toString();
    String datetime = '$date $time $day';

    Date dateObj = Date(date: date, time: time, day: day);


    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.done), 
              onPressed: () async {
                final title = titleController.value.text;
                final description = descController.value.text;

                if (title.isEmpty || description.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Empty Fields !"),
                  ));
                  return;
                }

                final Note model = Note(
                  title: title, description: description, timestamp:datetime, hidden: hideNote ? 1 : 0, id: note?.id);
                if (note == null) {
                  await DatabaseHelper.addNote(model);
                } else {
                  await DatabaseHelper.updateNote(model);
                }

                Navigator.pop(context);
              }
            ),
            HideButton(
              initialVisibility: hideNote, 
              onVisibilityChanged: (visibility) {
                setState(() {
                  hideNote = visibility;
                });
            },)
          ]
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 16, 0),
          child: Column(children: [
            
            /* Title */
            TextField(
              controller: titleController,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Input title"
              ),
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next, // Moves to the description textfield.
            ),
            
            /* Data & Time */
            Row(
              children: [
                Text(datetime, style: TextStyle(fontSize: 12, color: Colors.grey),),
              ],
            ),

            /* Description */
            TextField(
              controller: descController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Enter message"
              ),
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done // Closes the keyboard after clicking the enter.
            )

          ])
        )
    );
  }
}