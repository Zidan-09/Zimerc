// lib/services/session.dart
import 'package:shared_preferences/shared_preferences.dart';

enum UserType { ambulant, owner, employee }

class Session {
  static final Session _i = Session._();
  factory Session() => _i;
  Session._();

  static const _kToken = 'token';
  static const _kUserId = 'user_id';
  static const _kUserType = 'user_type';

  String? token;
  String? userId;
  UserType userType = UserType.ambulant;

  /// Carrega sessão do SharedPreferences (chame no start do app)
  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString(_kToken);
    userId = prefs.getString(_kUserId);
    final ut = prefs.getString(_kUserType);
    if (ut != null) userType = _fromString(ut);
  }

  /// Define sessão a partir do retorno do login.
  /// Chame isso quando o login for bem sucedido.
  Future<void> setFromLogin({
    required String tokenValue,
    String? userIdValue,
    String? userTypeValue,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    token = tokenValue;
    await prefs.setString(_kToken, tokenValue);

    if (userIdValue != null) {
      userId = userIdValue;
      await prefs.setString(_kUserId, userIdValue);
    }

    if (userTypeValue != null) {
      userType = _fromString(userTypeValue);
      await prefs.setString(_kUserType, userTypeValue);
    }
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kToken);
    await prefs.remove(_kUserId);
    await prefs.remove(_kUserType);
    token = null;
    userId = null;
    userType = UserType.ambulant;
  }

  bool get isAmbulant => userType == UserType.ambulant;
  bool get isOwner => userType == UserType.owner;
  bool get isEmployee => userType == UserType.employee;

  UserType _fromString(String s) {
    final lower = s.toLowerCase();
    if (lower.contains('ambul')) return UserType.ambulant;
    if (lower.contains('owner')) return UserType.owner;
    if (lower.contains('employee')) return UserType.employee;
    return UserType.ambulant;
  }
}