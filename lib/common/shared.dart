import 'package:logger/logger.dart';

class Shared{

  const Shared._(); // private constructor.
  //-------------------------------------------------------------------------
  // Logger instance. static build
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,       // 호출 스택 생략
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,      
    ),
  );
  //-------------------------------------------------------------------------
  static bool hasValue(dynamic value) {
    if (value == null) return false;
    if (value is String && value.trim().isEmpty) return false;
    if (value is List && value.isEmpty) return false;
    if (value is Map && value.isEmpty) return false;
      return true;
  }
  //-------------------------------------------------------------------------
  static void log(Object? object, [bool useLog = false]) {
    if (useLog)
    {
      _logger.i(object); // info 레벨로 출력
    } else {
      print(object);
    }
  }
  
  //-------------------------------------------------------------------------
}