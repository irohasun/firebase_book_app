import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_todo_app/domain/book_domain.dart';
import 'package:flutter/cupertino.dart';

class BookListModel extends ChangeNotifier {
  List<BookDomain> books = [];

  Future fetchBooks() async {
    final documents =
        await FirebaseFirestore.instance.collection('books').get();
    final books = documents.docs.map((doc) => BookDomain(doc)).toList();
    this.books = books;
    notifyListeners();
  }

  Future deleteBook(BookDomain book) async {
    await FirebaseFirestore.instance
        .collection('books')
        .doc(book.documentID)
        .delete();
  }
}
