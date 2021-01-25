import 'package:firebase_todo_app/domain/book_domain.dart';
import 'package:firebase_todo_app/presentation/add_book/add_book_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddBookPage extends StatelessWidget {
  final BookDomain book;

  //this.bookを{}で囲むと必須ではなくなる
  AddBookPage({this.book});

  @override
  Widget build(BuildContext context) {
    final bool isUpdate = book != null;
    final textEditingController = TextEditingController();

    if (isUpdate) {
      textEditingController.text = book.title;
    }

    return ChangeNotifierProvider<AddBookModel>(
        create: (_) => AddBookModel(),
        child: Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text(isUpdate ? '本を編集' : '本を追加'),
              ),
              body: Consumer<AddBookModel>(builder: (context, model, child) {
                return Column(
                  children: <Widget>[
                    SizedBox(
                      width: 100,
                      height: 160,
                      child: InkWell(
                        onTap: () async {
                          //TODOカメラロールを開く
                          await model.showImagePicker();
                        },
                        child: model.imageFile != null
                            ? Image.file(model.imageFile)
                            : Container(
                                color: Colors.grey,
                              ),
                      ),
                    ),
                    TextField(
                      controller: textEditingController,
                      onChanged: (text) {
                        model.bookTitle = text;
                      },
                    ),
                    RaisedButton(
                        child: Text(isUpdate ? '更新する' : '追加する'),
                        onPressed: () async {
                          model.startLoading();
                          if (isUpdate) {
                            await updateBook(model, context);
                          } else {
                            await addBook(model, context);
                          }
                          model.endLoading();
                        })
                  ],
                );
              }),
            ),
            Consumer<AddBookModel>(builder: (context, model, child) {
              return model.isLoading
                  ? Container(
                      color: Colors.grey.withOpacity(0.7),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : SizedBox();
            })
          ],
        ));
  }

  Future addBook(AddBookModel model, BuildContext context) async {
    try {
      await model.addBooktoFirebase();
      await showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                  title: Center(
                    child: Text('追加しました！'),
                  ),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: Text('OK')),
                  ]));
      Navigator.of(context).pop();
    } catch (e) {
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                  title: Center(
                    child: Text(e.toString()),
                  ),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: Text('OK')),
                  ]));
    }
  }

  Future updateBook(AddBookModel model, BuildContext context) async {
    try {
      await model.updateBook(book);
      await showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                  title: Center(
                    child: Text('更新しました！'),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ]));
      Navigator.of(context).pop();
    } catch (e) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Center(
            child: Text(e.toString()),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
    }
  }
}
