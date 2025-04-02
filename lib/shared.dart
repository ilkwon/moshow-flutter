class Shared{

  const Shared._(); // private constructor.

  //-------------------------------------------------------------------------
  static bool hasValue(dynamic value) {
    if (value == null) return false;
    if (value is String && value.trim().isEmpty) return false;
    if (value is List && value.isEmpty) return false;
    if (value is Map && value.isEmpty) return false;
      return true;
  }
}