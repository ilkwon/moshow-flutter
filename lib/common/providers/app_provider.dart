
import 'package:flutter/material.dart';

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
  
}