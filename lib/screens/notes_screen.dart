import 'package:flutter/material.dart';
import 'package:mm_notes/models/note_model.dart';
import 'package:mm_notes/screens/note_screen.dart';
import 'package:mm_notes/services/database_helper.dart';
import 'package:mm_notes/widgets/note_card_widget.dart';
import 'package:anim_search_bar/anim_search_bar.dart';

class NotesList extends StatefulWidget {
  const NotesList({super.key});

  @override
  State<NotesList> createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  bool showHidden = false;
  final searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          shadowColor: Colors.white,
          surfaceTintColor: Colors.purple,
          actions: [
            AnimSearchBar(
              width: 300,
              textController: searchTextController,
              onSuffixTap: () {
                setState(() {
                  searchTextController.clear();
                });
              }, onSubmitted: (String ) {  },
            ),
            // IconButton(onPressed: () {}, icon: Icon(Icons.search, color: Colors.grey.shade600)),
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: showHidden ? Text("Hide hidden notes") : Text("Show hidden notes"),
                  value: !showHidden,
                ),
              ],
              onSelected: (bool hidden) {
                setState(() {
                  showHidden = hidden;
                });
              },
            )
          ],
        title: const Text("Notes", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24))),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(context,
                MaterialPageRoute(builder: (context) => NoteScreen()));
            setState(() {});
          },
          child: const Icon(Icons.add)
        ),
        body: FutureBuilder<List<Note>?>(
          future: DatabaseHelper.getAllNotes(showHidden),
          builder: (context, AsyncSnapshot<List<Note>?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else if (snapshot.hasData) {
              if (snapshot.data != null) {
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) => NoteCard(
                    note: Note(
                      title: snapshot.data![index].title, 
                      description: snapshot.data![index].description,
                      timestamp: snapshot.data![index].timestamp,
                      hidden: snapshot.data![index].hidden
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => NoteScreen(note:snapshot.data![index]))
                      );
                      setState(() {});
                    },
                    onLongPress: () async {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                  'Delete the note ?'),
                              actions: [
                                ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                      MaterialStateProperty.all(Colors.red)),
                                  onPressed: () async {
                                    await DatabaseHelper.deleteNote(
                                        snapshot.data![index]);
                                    Navigator.pop(context);
                                    setState(() {});
                                  },
                                  child: const Text('Yes'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('No'),
                                ),
                              ],
                            );
                          });
                    },
                  )
                );
              }
              return const Center(child: Text("Data is missing !!!"));
            }
            return const Center(child: Text("No data !"));
          }
        )
      );
  }
}