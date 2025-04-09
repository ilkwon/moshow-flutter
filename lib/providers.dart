import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StoreProvider extends ChangeNotifier
{
  var name = 'John Kim';
  var follower = 0;
  bool friend = false;

  void changeName() {
    name = 'john park';
    notifyListeners();
  }

  void addFollower() {

    if (! friend) {
      follower++;
      friend = true;      
    } else {
      follower--;
      friend = false;
    }

    notifyListeners();
  }
  
  List<dynamic> profile = [];
  
  getProfileData() async* {
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/profile.json'));    
    profile = jsonDecode(result.body);

    notifyListeners();
  }  
}