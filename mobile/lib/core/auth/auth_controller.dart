import 'package:flutter/foundation.dart';
import '../api/api_client.dart';
import '../storage/token_storage.dart';
import 'session.dart';

enum AuthStatus { restoring, authenticated, unauthenticated }

class AuthController extends ChangeNotifier {
  AuthController(this.api, this.storage);
  final ApiClient api;
  final TokenStorage storage;
  AuthStatus status = AuthStatus.restoring;
  SessionUser? user;
  Future<void> restore() async {
    if (await storage.refresh() == null) {
      status = AuthStatus.unauthenticated;
      notifyListeners();
      return;
    }
    try {
      user = SessionUser.fromJson(await api.get('/auth/me'));
      status = AuthStatus.authenticated;
    } catch (_) {
      await storage.clear();
      status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    var j = await api.post('/auth/login', {
      'email': email.trim().toLowerCase(),
      'password': password,
      'deviceName': 'FiberTrack mobile',
      'devicePlatform': defaultTargetPlatform.name
    });
    await storage.save(j['accessToken'], j['refreshToken']);
    user = SessionUser.fromJson(j['user']);
    status = AuthStatus.authenticated;
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      var token = await storage.refresh();
      if (token != null) {
        await api.post('/auth/logout', {'refreshToken': token});
      }
    } finally {
      await storage.clear();
      user = null;
      status = AuthStatus.unauthenticated;
      notifyListeners();
    }
  }

  bool has(String permission) => user?.has(permission) ?? false;
}
