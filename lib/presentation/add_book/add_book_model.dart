import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_todo_app/domain/book_domain.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class AddBookModel extends ChangeNotifier {
  String bookTitle = '';
  String imageID = '';
  File imageFile;
  bool isLoading = false;

  startLoading() {
    isLoading = true;
  }

  endLoading() {
    isLoading = false;
  }

  Future showImagePicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    imageFile = File(pickedFile.path);
    notifyListeners();
  }

  Future addBooktoFirebase() async {
    if (bookTitle.isEmpty) {
      throw ('タイトルを入力してください!');
    }

    final imageURL = await uploadImage();

    await FirebaseFirestore.instance.collection('books').add(
      {
        'createdAt': Timestamp.now(),
        'title': bookTitle,
        'imageURL': imageURL,
      },
    );
  }

  Future updateBook(BookDomain book) async {
    final imageURL = await uploadImage();
    final document =
        FirebaseFirestore.instance.collection('books').doc(book.documentID);
    await document.update(
      {
        'updateAt': Timestamp.now(),
        'title': bookTitle,
        'imageURL': imageURL,
      },
    );
  }

  Future<String> uploadImage() async {
    final ref = FirebaseStorage.instance.ref();
    TaskSnapshot snapshot =
        await ref.child('books/$bookTitle').putFile(imageFile);
    final String downloadURL = await snapshot.ref.getDownloadURL();
    return downloadURL;
  }
}
