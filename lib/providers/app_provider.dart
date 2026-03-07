import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:moshow/common/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:moshow/common/api_client.dart';

class StoreProvider extends ChangeNotifier
{
  String? userId;

  // 앱시작시 호출
  Future<void> initUser() async {
    var prefs = await SharedPreferences.getInstance();
    final saveId = prefs.getString('user_id');
    
    if (saveId != null){
      userId = saveId;
      Shared.log('✅ 기존 user_id 로드: $userId');  // ← 추가
      notifyListeners();
      return;
    }

    // 없으면 게스트 생성 요청.
    final data = await  ApiClient.instance.post('/auth/guest', {});
    userId = data['user_id'] as String;

    await prefs.setString('user_id', userId!);
    Shared.log('✅ 새로운 user_id 발급: $userId');  // ← 추가
    notifyListeners();
  }

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