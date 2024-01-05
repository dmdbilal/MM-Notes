import 'package:flutter/material.dart';

import '../models/note_model.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  const NoteCard(
      {Key? key,
        required this.note,
        required this.onTap,
        required this.onLongPress})
      : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        clipBehavior: Clip.hardEdge,
        elevation: 0,
        color: Color(0xfff7f7f7),
        child: InkWell(
            splashColor: Colors.purple.withAlpha(30),
            onTap: onTap,
            onLongPress: onLongPress,
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 75,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          note.timestamp,
                          style: TextStyle(color: Colors.grey.shade800),
                        )
                      ],
                    )
                  )
                )
        ),
      ),
    );
  }
}