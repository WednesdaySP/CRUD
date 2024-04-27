import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crudfirebase/services/firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //firestore
  final FirestoreService firestoreService=FirestoreService();

  //text controller
  final TextEditingController textController=TextEditingController();


void handleFABPress(){
  openNoteBox(null);
}
  //open a dialogue box to add a note
  void openNoteBox(String? docID){
    showDialog(
      context: context, 
      builder: (context) => 
    AlertDialog(
      backgroundColor: Colors.grey[300],
      title: Text("Add a note", style: TextStyle(color: Colors.black),),
      //text user input
      content: TextField(
        controller: textController,
      ),
      actions: [
        ElevatedButton(
         
          onPressed: () {
          //add new note
          if(docID==null){
            firestoreService.addNote(textController.text,);
          }
          //update an existing note
          else{
            firestoreService.updateNote(docID, textController.text);
          }

          //clear the textController
          textController.clear();

          //close the box
          Navigator.pop(context);
        }, child: Text("Add",style: TextStyle(color: Colors.black),))
      ],
    ),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Align(
          alignment: Alignment.center,
          child: const Text("C R U D",style: TextStyle(color: Colors.white),)),
        backgroundColor: Color.fromARGB(255, 37, 37, 37),
      ),
      floatingActionButton: FloatingActionButton(
        hoverColor: Colors.grey,
        backgroundColor:Color.fromARGB(255, 37, 37, 37),
        onPressed:handleFABPress,
      child: Icon(Icons.add,color: Colors.white,),),

      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotesStream(), 
      builder: (context, snapshot) {
        //if we have data, get all the docs
        if(snapshot.hasData){
          List notesList =snapshot.data!.docs;

          //display as a list
          return  ListView.builder(
              itemCount: notesList.length,
              itemBuilder:(context, index) {
                
                //get each individual doc
                DocumentSnapshot document=notesList[index];
                String docID=document.id;
            
                //get note from each doc
                Map<String, dynamic>data=document.data()as Map<String, dynamic>;
                String noteText=data['notes'];
            
                //diaplay as a list tile
                return Container(
                  margin: EdgeInsets.all(15),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
                  title: Text(noteText),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children:[ 
                      
                      //update
                      IconButton(
                      onPressed: () => openNoteBox(docID), 
                      icon: const Icon(Icons.settings)),
                      
                      //delete
                      IconButton(icon: Icon(Icons.delete),
                      onPressed: () => firestoreService.deleteNote(docID),)]
            
               
                  ),
                ),
                );
              }, 
          );
          
        }
        else{
          return Text("No notes...");
        }
      },),
    );
  }
}