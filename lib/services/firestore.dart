import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService{

  //get collection of notes
  final CollectionReference notes=FirebaseFirestore.instance.collection('notes');

  //CREATE: add a new note
  Future<void> addNote(String note){
    return notes.add({//for multiple parameters
      'notes':note,
      'timestamp':Timestamp.now(),
    });
  }

  //READ: get notes from database
  //using stream to get continues set of data and read it
  Stream<QuerySnapshot<Object?>>getNotesStream(){
    final notesStream=notes.orderBy('timestamp',descending: true).snapshots();
    return notesStream;
  }

  //UPDATE: update notes given a doc id
  Future<void>updateNote(String docId, String newNote){
    return notes.doc(docId).update({
      'note':newNote,
      'timestamp':Timestamp.now(),
    });
  }


  //DELETE: delete notes given a doc id
  Future<void>deleteNote(String docID){
    return notes.doc(docID).delete();
  }
}