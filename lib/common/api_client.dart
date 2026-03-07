// lib/common/api_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'define.dart';

class ApiClient {
  // 싱글톤 - 앱 전체에서 하나의 instance만 사용.
  static final ApiClient instance = ApiClient._internal();
  ApiClient._internal();

  // 공용헤더 - 모든 API 요청에 공통적으로 포함되는 헤더.
  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    // 'Authorization': 'Bearer $token'
  };

  // GET 요청
  Future<dynamic> get(String path) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}$path');
    final response = await http.get(url, headers: _headers);
    return _processResponse(response);
  }
  
  // POST 요청
  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final url = Uri.parse('${AppConfig.apiBaseUrl}$path');
    final response = await http.post(url, headers: _headers, body: json.encode(body));
    
    return _processResponse(response);
  }

  // 응답처리
  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);  // Json 문자열 -> Dart 객체 (Map/List)
    } else {
      throw Exception('API 오류: ${response.statusCode} ${response.reasonPhrase}');
    }
  }
}
