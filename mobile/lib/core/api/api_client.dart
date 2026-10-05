import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../config/environment.dart';
import '../storage/token_storage.dart';

class ApiException implements Exception {
  ApiException(this.status, this.message);
  final int status;
  final String message;
  @override
  String toString() => message;
}

class ApiClient {
  ApiClient(this.storage);
  final TokenStorage storage;
  Future<dynamic> get(String path) => _send('GET', path);
  Future<dynamic> post(String path, [Object? body]) =>
      _send('POST', path, body);
  Future<dynamic> put(String path, [Object? body]) => _send('PUT', path, body);
  Future<Uint8List> bytes(String path) async {
    var token = await storage.access();
    var r = await http.get(Uri.parse('${Environment.apiBaseUrl}$path'),
        headers: {if (token != null) 'Authorization': 'Bearer $token'});
    if (r.statusCode >= 400) {
      throw ApiException(r.statusCode, 'No se pudo descargar el archivo');
    }
    return r.bodyBytes;
  }

  Future<dynamic> _send(String method, String path,
      [Object? body, bool retry = true]) async {
    var token = await storage.access();
    var req = http.Request(method, Uri.parse('${Environment.apiBaseUrl}$path'));
    req.headers['Content-Type'] = 'application/json';
    if (token != null) req.headers['Authorization'] = 'Bearer $token';
    if (body != null) req.body = jsonEncode(body);
    var streamed = await req.send();
    var response = await http.Response.fromStream(streamed);
    if (response.statusCode == 401 && retry && await _refresh()) {
      return _send(method, path, body, false);
    }
    if (response.statusCode >= 400) {
      String message = 'Error ${response.statusCode}';
      try {
        message = jsonDecode(response.body)['message'] ?? message;
      } catch (_) {}
      throw ApiException(response.statusCode, message);
    }
    return response.body.isEmpty
        ? null
        : jsonDecode(utf8.decode(response.bodyBytes));
  }

  Future<bool> _refresh() async {
    var refresh = await storage.refresh();
    if (refresh == null) return false;
    try {
      var r = await http.post(
          Uri.parse('${Environment.apiBaseUrl}/auth/refresh'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'refreshToken': refresh}));
      if (r.statusCode != 200) {
        await storage.clear();
        return false;
      }
      var j = jsonDecode(r.body);
      await storage.save(j['accessToken'], j['refreshToken']);
      return true;
    } catch (_) {
      return false;
    }
  }
}
