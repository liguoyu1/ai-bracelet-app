import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../config/api_config.dart';
import '../models/models.dart';
import '../services/api_service.dart';

// Web localStorage — synchronous, no plugin needed
import 'dart:html' show window;

class _Storage {
  String? get(String key) => window.localStorage[key];
  void set(String key, String value) => window.localStorage[key] = value;
  void remove(String key) => window.localStorage.remove(key);
}

final _storage = _Storage();

class AuthProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  User? _user;
  String? _token;
  bool _loading = false;
  String? _error;
  bool _initialized = false;

  User? get user => _user;
  String? get token => _token;
  bool get loading => _loading;
  String? get error => _error;
  bool get initialized => _initialized;
  bool get isLoggedIn => _user != null && _token != null;
  bool get isAdmin => _user?.isAdmin ?? false;

  /// Load persisted session from SharedPreferences on app start.
  Future<void> init() async {
    if (_initialized) return;
    try {
      final savedToken = _storage.get('auth_token');
      final savedUser = _storage.get('auth_user');

      if (savedToken != null && savedUser != null) {
        _token = savedToken;
        _api.token = _token;
        _user = User.fromJson(jsonDecode(savedUser) as Map<String, dynamic>);
      }
    } catch (_) {
      // localStorage fail — just show login
    }
    _initialized = true;
    notifyListeners();
  }

  Future<bool> register(String email, String password, String name) async {
    _loading = true;
    _error = null;
    notifyListeners();

    final res = await _api.post(ApiConfig.register, body: {
      'email': email,
      'password': password,
      'display_name': name,
    });

    _loading = false;
    if (res.isOk && res.data != null) {
      _token = res.data['token'];
      _user = User.fromJson(res.data['user']);
      _api.token = _token;
      await _persistAuth();
      notifyListeners();
      return true;
    }
    _error = res.error ?? 'Registration failed';
    notifyListeners();
    return false;
  }

  Future<bool> login(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();

    final res = await _api.post(ApiConfig.login, body: {
      'email': email,
      'password': password,
    });

    _loading = false;
    if (res.isOk && res.data != null) {
      _token = res.data['token'];
      _user = User.fromJson(res.data['user']);
      _api.token = _token;
      await _persistAuth();
      notifyListeners();
      return true;
    }
    _error = res.error ?? 'Login failed';
    notifyListeners();
    return false;
  }

  Future<void> loadProfile() async {
    if (_token == null) return;
    final res = await _api.get(ApiConfig.me);
    if (res.isOk && res.data != null) {
      _user = User.fromJson(res.data);
      notifyListeners();
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    final res = await _api.put(ApiConfig.me, body: data);
    if (res.isOk) {
      await loadProfile();
    }
  }

  Future<void> logout() async {
    _user = null;
    _token = null;
    _api.token = null;
    await _clearPersistedAuth();
    notifyListeners();
  }

  Future<void> _persistAuth() async {
    _storage.set('auth_token', _token ?? '');
    _storage.set('auth_user', jsonEncode(_user?.toJson()));
  }

  Future<void> _clearPersistedAuth() async {
    _storage.remove('auth_token');
    _storage.remove('auth_user');
  }
}
