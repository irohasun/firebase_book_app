import 'package:flutter/material.dart';

class MainModel extends ChangeNotifier{
  String kboyText = 'KBOY';

  void ChangeKboyText(){
    kboyText = 'kboyさんかっこいい!!';
    notifyListeners();
}
}