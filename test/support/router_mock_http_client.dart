import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const _kEmptyPaged =
    '{"items":[],"total":0,"page":1,"limit":10,"hasMore":false}';

/// Respuestas JSON mínimas para rutas que cargan listas al montar (evita `FormatException` en tests de router).
http.Client createRouterMockHttpClient() {
  return MockClient((request) async {
    final path = request.url.path;
    if (path.contains('auth/refresh')) {
      return http.Response('', 401);
    }
    if (request.method != 'GET') {
      return http.Response('{}', 200);
    }
    if (path.contains('/roles')) {
      return http.Response('[]', 200);
    }
    if (path.contains('/users') ||
        path.contains('/purchases') ||
        path.contains('/sales') ||
        path.contains('/cattle')) {
      return http.Response(_kEmptyPaged, 200);
    }
    return http.Response('[]', 200);
  });
}

Future<T> runWithRouterMockHttp<T>(Future<T> Function() body) {
  return http.runWithClient(body, createRouterMockHttpClient);
}
