import 'package:cloud_firestore/cloud_firestore.dart';

class BookDomain {
  BookDomain(DocumentSnapshot doc) {
    documentID = doc.id;
    title = doc['title'];
    imageURL = doc['imageURL'];
  }
  String title;
  String documentID;
  String imageURL;
}
