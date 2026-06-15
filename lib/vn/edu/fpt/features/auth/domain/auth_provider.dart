import 'package:flutter/material.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/token_storage.dart';
import '../data/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final _repo = AuthRepository();

  bool _isLoggedIn = false;
  bool _loading = false;
  String? _error;
  String? _fullName;
  String? _role;
  String? _username;

  bool get isLoggedIn => _isLoggedIn;
  bool get loading => _loading;
  String? get error => _error;
  String? get fullName => _fullName;
  String? get role => _role;
  String? get username => _username;

  Future<void> checkAuth() async {
    _isLoggedIn = await TokenStorage.hasToken();
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final result = await _repo.login(username, password);
      _fullName = result.fullName;
      _role = result.role;
      _username = result.username;
      _isLoggedIn = true;
      return true;
    } catch (e) {
      _error = parseErrorMessage(e);
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _repo.logout();
    _isLoggedIn = false;
    _fullName = null;
    _role = null;
    _username = null;
    notifyListeners();
  }
}
