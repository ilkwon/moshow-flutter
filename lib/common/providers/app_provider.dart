
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moshow/common/shared.dart';
import 'package:moshow/common/api_client.dart';

class StoreProvider extends ChangeNotifier
{
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'auth_token';

  String? userId;
  String? token;

  // 앱시작시 호출
  Future<void> initUser() async {
    final savedToken = await _storage.read(key: _tokenKey);
    Shared.log('저장된 토큰: $savedToken');
    
    if (savedToken != null){
      token = savedToken;
      
      // 토큰에서 user_id 추출
      final jwt = JWT.decode(savedToken);
      userId = jwt.payload['user_id'] as String;
      Shared.log('✅ 기존 토큰에서 user_id 복원: $userId');

      notifyListeners();
      return;
    }

    // 없으면 게스트 생성 요청.
    final data = await  ApiClient.instance.post('/auth/guest', {});
    userId = data['user_id'] as String;
    token = data['token'] as String;

    await _storage.write(key: _tokenKey, value: token);
    Shared.log('✅ 새로운 user_id 발급: $token');
    notifyListeners();
  }
  
}