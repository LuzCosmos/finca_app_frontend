import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:finca_app_frontend/core/services/basic_api_service.dart';
import 'package:finca_app_frontend/modules/web/features/cattle_purchase/models/purchase_list_item.dart';

class PurchasesPageResult {
  final int page, limit, total;
  final bool hasMore;
  final List<PurchaseListItemModel> items;

  PurchasesPageResult(
    this.page,
    this.limit,
    this.total,
    this.hasMore,
    this.items,
  );
}

class PurchasesApiService {
  final String baseUrl = '${BasicApiService.getApiBaseUrl()}/purchases';

  Future<void> createPurchase({
    required String idProvider,
    required DateTime purchaseDate,
    required List<Map<String, dynamic>> lots,
  }) async {
    final token = await BasicApiService.getToken();
    final url = Uri.parse(baseUrl);

    final body = jsonEncode({
      "idProvider": idProvider,
      "purchaseDate": purchaseDate.toIso8601String(),
      "lots": lots,
    });
    var response;
    try {
      response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: body,
      );
    } catch (e) {
      if (e is SocketException || e is http.ClientException) {
        throw ApiException(
          'serverConnectionError',
          'Error al crear MassiveEvent: $e',
        );
      }
      throw ApiException(
        'savingObjectError',
        'Error al crear MassiveEvent: $e',
      );
    }
    if (response.statusCode == 201) {
      return;
    } else {
      BasicApiService.manageNotSuccessResponseCode(response);
    }
  }

  Future<PurchasesPageResult> list({
    required int page,
    required int limit,
    String? from,
    String? to,
    String? provider,
    String status = 'all', // 'all'|'open'|'received'
  }) async {
    final token = await BasicApiService.getToken();
    final uri = Uri.parse(baseUrl).replace(
      queryParameters: {
        'page': '$page',
        'limit': '$limit',
        if (from != null && from.isNotEmpty) 'from': from,
        if (to != null && to.isNotEmpty) 'to': to,
        if (provider != null && provider.isNotEmpty) 'provider': provider,
        if (status.isNotEmpty) 'status': status,
      },
    );

    late http.Response res;
    try {
      res = await http.get(uri, headers: {'Authorization': 'Bearer $token'});
    } catch (e) {
      if (e is SocketException || e is http.ClientException) {
        throw ApiException(
          'serverConnectionError',
          'Error listando compras: $e',
        );
      }
      throw ApiException('readingObjectError', 'Error listando compras: $e');
    }

    if (res.statusCode >= 200 && res.statusCode < 300) {
      final decoded = jsonDecode(res.body);
      //debugPrint('Purchases list response: $decoded');
      if (decoded is! Map<String, dynamic>) {
        throw ApiException(
          'readingObjectError',
          'Formato de respuesta no soportado',
        );
      }
      final rawList = (decoded['items'] as List? ?? const []);
      final items =
          rawList
              .map(
                (e) =>
                    PurchaseListItemModel.fromJson(e as Map<String, dynamic>),
              )
              .toList();

      final outPage = int.tryParse('${decoded['page'] ?? 1}') ?? 1;
      final outLimit =
          int.tryParse('${decoded['limit'] ?? items.length}') ?? items.length;
      final outTotal =
          int.tryParse('${decoded['total'] ?? items.length}') ?? items.length;
      final outHasMore = decoded['hasMore'] == true;
      final result = PurchasesPageResult(
        outPage,
        outLimit,
        outTotal,
        outHasMore,
        items,
      );
      /*debugPrint(
        'PurchasesPageResult(page: ${result.page}, limit: ${result.limit}, '
        'total: ${result.total}, hasMore: ${result.hasMore}, '
        'items: ${result.items.length})',
      );*/
      return result;
    } else {
      BasicApiService.manageNotSuccessResponseCode(res);
    }
  }
}
