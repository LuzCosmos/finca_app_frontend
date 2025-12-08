import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;
  final Map<String, String> defaultHeaders;

  ApiService({required this.baseUrl, this.defaultHeaders = const {}});

  Future<http.Response> get(String path, {Map<String, String>? headers}) {
    return http.get(
      Uri.parse('$baseUrl$path'),
      headers: {...defaultHeaders, ...?headers},
    );
  }

  Future<http.Response> post(
    String path,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) {
    return http.post(
      Uri.parse('$baseUrl$path'),
      headers: {
        ...defaultHeaders,
        ...?headers,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> patch(
    String path,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) {
    return http.patch(
      Uri.parse('$baseUrl$path'),
      headers: {
        ...defaultHeaders,
        ...?headers,
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
  }
}
