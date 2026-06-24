import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiService {
  String? _token;
  String? _lang;

  static final ApiService _instance = ApiService._();
  factory ApiService() => _instance;
  ApiService._();

  set token(String? t) => _token = t;
  set lang(String? l) => _lang = l;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
        if (_lang != null) 'Accept-Language': _lang!,
      };

  Uri _uri(String path, {Map<String, String>? query}) {
    final q = <String, String>{};
    if (_lang != null) q['lang'] = _lang!;
    if (query != null) q.addAll(query);
    var uri = Uri.parse('${ApiConfig.baseUrl}$path');
    if (q.isNotEmpty) {
      uri = uri.replace(queryParameters: q);
    }
    return uri;
  }

  Future<ApiResponse> get(String path, {Map<String, String>? query}) async {
    final uri = _uri(path, query: query);
    final res = await http.get(uri, headers: _headers);
    return _parse(res);
  }

  Future<ApiResponse> post(String path, {Map<String, dynamic>? body}) async {
    final uri = _uri(path);
    final res = await http.post(uri, headers: _headers, body: jsonEncode(body));
    return _parse(res);
  }

  Future<ApiResponse> put(String path, {Map<String, dynamic>? body}) async {
    final uri = _uri(path);
    final res = await http.put(uri, headers: _headers, body: jsonEncode(body));
    return _parse(res);
  }

  Future<ApiResponse> delete(String path) async {
    final uri = _uri(path);
    final res = await http.delete(uri, headers: _headers);
    return _parse(res);
  }

  Future<ApiResponse> uploadFile(String path, File file) async {
    final uri = _uri(path);
    final req = http.MultipartRequest('POST', uri)
      ..headers.addAll({
        if (_token != null) 'Authorization': 'Bearer $_token',
        if (_lang != null) 'Accept-Language': _lang!,
      })
      ..files.add(await http.MultipartFile.fromPath('file', file.path));
    final streamed = await req.send();
    final res = await http.Response.fromStream(streamed);
    return _parse(res);
  }

  ApiResponse _parse(http.Response res) {
    try {
      final body = jsonDecode(res.body);
      return ApiResponse(
        statusCode: res.statusCode,
        success: body['success'] ?? false,
        data: body['data'],
        error: body['error'],
        total: body['total'],
      );
    } catch (_) {
      return ApiResponse(
        statusCode: res.statusCode,
        success: res.statusCode < 400,
        data: res.body,
        error: res.statusCode >= 400 ? res.body : null,
      );
    }
  }
}

class ApiResponse {
  final int statusCode;
  final bool success;
  final dynamic data;
  final String? error;
  final int? total;

  ApiResponse({
    required this.statusCode,
    required this.success,
    this.data,
    this.error,
    this.total,
  });

  bool get isOk => success && statusCode < 400;
}
