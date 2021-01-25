import 'package:firebase_todo_app/domain/book_domain.dart';
import 'package:firebase_todo_app/presentation/add_book/add_book_page.dart';
import 'package:firebase_todo_app/presentation/book_list/bookListModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookListModel>(
        create: (_) => BookListModel()..fetchBooks(),
        child: Scaffold(
          appBar: AppBar(
            title: Text('本リスト'),
          ),
          body: Consumer<BookListModel>(
            builder: (context, model, child) {
              final books = model.books;
              final listTiles = books
                  .map(
                    (book) => ListTile(
                      title: Text(book.title),
                      leading: Image.network(book.imageURL),
                      trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            //todo:画面遷移
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddBookPage(
                                    book: book,
                                  ),
                                  fullscreenDialog: true,
                                ));
                          }),
                      onLongPress: () {
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                    title: Center(
                                      child: Text('${book.title}削除しますか？'),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            deleteBook(model, context, book);
                                          },
                                          child: Text('OK')),
                                    ]));
                      },
                    ),
                  )
                  .toList();
              return ListView(
                children: listTiles,
              );
            },
          ),
          floatingActionButton:
              Consumer<BookListModel>(builder: (context, model, child) {
            return FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddBookPage(),
                    fullscreenDialog: true,
                  ),
                );
                await model.fetchBooks();
              },
            );
          }),
        ));
  }

  Future deleteBook(
      BookListModel model, BuildContext context, BookDomain book) async {
    try {
      await model.deleteBook(book);
      await model.fetchBooks();
      await _showDialog(context, '削除しました');
    } catch (e) {
      // _showDialog(context, e.toString());
    }
  }

  Future _showDialog(BuildContext context, String title) {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
                title: Center(
                  child: Text(title),
                ),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: Text('OK')),
                ]));
  }
}
