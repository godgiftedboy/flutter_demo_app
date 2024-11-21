import 'package:flutter/material.dart';
import 'package:ui_stuffs/sqflite_demo/db_helper.dart';
import 'package:ui_stuffs/sqflite_demo/note_detail_view.dart';
import 'package:ui_stuffs/sqflite_demo/note_model.dart';

class DatabasePage extends StatefulWidget {
  const DatabasePage({super.key});

  @override
  State<DatabasePage> createState() => _DatabasePageState();
}

class _DatabasePageState extends State<DatabasePage> {
  NoteDatabase noteDatabase = NoteDatabase.instance;

  List<NoteModel> notes = [];

  @override
  void initState() {
    super.initState();

    refreshNotes();
  }

  @override
  dispose() {
    //close the database
    noteDatabase.close();
    super.dispose();
  }

  ///Gets all the notes from the database and updates the state
  refreshNotes() {
    noteDatabase.readAll().then((value) {
      setState(() {
        notes = value;
      });
    });
  }

  ///Navigates to the NoteDetailsView and refreshes the notes after the navigation
  goToNoteDetailsView({int? id}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteDetailsView(noteId: id)),
    );
    refreshNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade300,
      appBar: AppBar(
        title: Text("DB"),
      ),
      body: Center(
        child: notes.isEmpty
            ? const Text(
                'No Notes yet',
                style: TextStyle(color: Colors.white),
              )
            : ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return GestureDetector(
                    onTap: () => goToNoteDetailsView(id: note.id),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                note.createdTime.toString().split(' ')[0],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    note.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        noteDatabase.update(note.copy(
                                            isFavorite: !note.isFavorite));
                                        refreshNotes();
                                      });
                                    },
                                    icon: Icon(note.isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border_outlined),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    noteDatabase.deleteTable();
                                  },
                                  child: const Text("Delete"))
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: goToNoteDetailsView,
        tooltip: 'Create Note',
        child: const Icon(Icons.add),
      ),
    );
  }
}
