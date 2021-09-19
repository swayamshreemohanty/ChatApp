import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('/chats/2sb3wZBNumh1IkD9v49e/messages')
              //this snapshots() is used to update the flutter app with the recent change in the Cloud Firestore
              .snapshots(),
          builder: (ctx, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            //to fetch the Async data in form of QuerySnapshot
            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                ),
              );
            }
            final document = streamSnapshot.data!.docs;
            return ListView.builder(
              itemCount: document.length,
              itemBuilder: (ctx, index) {
                return Container(
                  padding: EdgeInsets.all(8),
                  child: Text("${document[index]["text"]}"),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {},
        ));
  }
}
