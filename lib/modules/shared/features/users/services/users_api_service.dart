import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:finca_app_frontend/core/services/basic_api_service.dart';
import '../models/user_model.dart';
import '../models/role_model.dart';

class UsersPageResult {
  final int page, limit, total;
  final List<UserModel> items;

  UsersPageResult({
    required this.page,
    required this.limit,
    required this.total,
    required this.items,
  });
}

class UsersApiService {
  final String baseUrl = '${BasicApiService.getApiBaseUrl()}/users';

  Future<UsersPageResult> list({
    required int page,
    required int limit,
    String? username,
    String? lastName,
  }) async {
    final uri = Uri.parse(baseUrl).replace(
      queryParameters: {
        'page': '$page',
        'limit': '$limit',
        if (username != null && username.isNotEmpty) 'username': username,
        if (lastName != null && lastName.isNotEmpty) 'lastName': lastName,
      },
    );

    late http.Response res;
    try {
      res = await BasicApiService.authorizedGet(uri);
    } catch (e) {
      if (e is SocketException || e is http.ClientException) {
        throw ApiException(
          ApiExceptionCode.serverConnectionError.name,
          e.toString(),
        );
      }
      throw ApiException(ApiExceptionCode.unknownError.name, e.toString());
    }

    if (res.statusCode >= 200 && res.statusCode < 300) {
      final decoded = jsonDecode(res.body);
      final rawList = (decoded['items'] as List? ?? const []);
      final items = rawList.map((e) => UserModel.fromJson(e)).toList();
      final total = int.tryParse('${decoded['total'] ?? 0}') ?? 0;

      return UsersPageResult(
        page: page,
        limit: limit,
        total: total,
        items: items,
      );
    } else {
      BasicApiService.manageNotSuccessResponseCode(res);
    }
  }

  Future<List<RoleModel>> getRoles() async {
    final uri = Uri.parse('$baseUrl/roles');

    late http.Response res;
    try {
      res = await BasicApiService.authorizedGet(uri);
    } catch (e) {
      if (e is SocketException || e is http.ClientException) {
        throw ApiException(
          ApiExceptionCode.serverConnectionError.name,
          e.toString(),
        );
      }
      throw ApiException(ApiExceptionCode.unknownError.name, e.toString());
    }

    if (res.statusCode == 200) {
      final List<dynamic> decoded = jsonDecode(res.body);
      return decoded.map((e) => RoleModel.fromJson(e)).toList();
    } else {
      BasicApiService.manageNotSuccessResponseCode(res);
    }
  }

  Future<void> create(Map<String, dynamic> data) async {
    final uri = Uri.parse(baseUrl);

    // Ensure roleIds is a list of strings
    if (data['roleIds'] is List &&
        (data['roleIds'] as List).isNotEmpty &&
        data['roleIds'][0] is String) {
      // already OK
    } else if (data['roleIds'] is List) {
      // if for some reason it's not string list, but should be handled by caller
    }

    late http.Response res;
    try {
      res = await BasicApiService.authorizedPost(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
    } catch (e) {
      if (e is SocketException || e is http.ClientException) {
        throw ApiException(
          ApiExceptionCode.serverConnectionError.name,
          e.toString(),
        );
      }
      throw ApiException(ApiExceptionCode.savingObjectError.name, e.toString());
    }

    if (res.statusCode != 201) {
      BasicApiService.manageNotSuccessResponseCode(res);
    }
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    final uri = Uri.parse('$baseUrl/$id');

    late http.Response res;
    try {
      res = await BasicApiService.authorizedPut(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
    } catch (e) {
      if (e is SocketException || e is http.ClientException) {
        throw ApiException(
          ApiExceptionCode.serverConnectionError.name,
          e.toString(),
        );
      }
      throw ApiException(ApiExceptionCode.savingObjectError.name, e.toString());
    }

    if (res.statusCode != 200) {
      BasicApiService.manageNotSuccessResponseCode(res);
    }
  }

  Future<void> delete(String id) async {
    final uri = Uri.parse('$baseUrl/$id');

    late http.Response res;
    try {
      res = await BasicApiService.authorizedDelete(uri);
    } catch (e) {
      if (e is SocketException || e is http.ClientException) {
        throw ApiException(
          ApiExceptionCode.serverConnectionError.name,
          e.toString(),
        );
      }
      throw ApiException(ApiExceptionCode.unknownError.name, e.toString());
    }

    if (res.statusCode != 200) {
      BasicApiService.manageNotSuccessResponseCode(res);
    }
  }
}
