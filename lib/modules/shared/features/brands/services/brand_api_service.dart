import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'dart:io';
import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:finca_app_frontend/core/services/basic_api_service.dart';
import 'package:finca_app_frontend/modules/shared/features/brands/models/brand_model.dart';

class BrandApiService {
  static Future<List<BrandModel>> getAllBrands() async {
    final token = await BasicApiService.getToken();
    final String baseUrl = BasicApiService.getApiBaseUrl();
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/brands'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> decoded = jsonDecode(response.body);
        return decoded.map((e) => BrandModel.fromJson(e)).toList();
      } else {
        BasicApiService.manageNotSuccessResponseCode(response);
      }
    } catch (e) {
      if (e is SocketException || e is http.ClientException) {
        throw ApiException(
          ApiExceptionCode.serverConnectionError.name,
          'Error al crear MassiveEvent: $e',
        );
      } else if (e is! ApiException) {
        throw ApiException(
          ApiExceptionCode.savingObjectError.name,
          'Error al crear MassiveEvent: $e',
        );
      }
      rethrow;
    }
  }

  static Future<BrandModel> createBrand({required BrandModel brand}) async {
    final token = await BasicApiService.getToken();
    final String baseUrl = BasicApiService.getApiBaseUrl();
    final uri = Uri.parse('$baseUrl/brands');
    final request =
        http.MultipartRequest('POST', uri)
          ..headers['Authorization'] = 'Bearer $token'
          ..fields['name'] = brand.name
          ..fields['id'] = brand.id
          ..files.add(
            http.MultipartFile.fromBytes(
              'image',
              brand.imageBytes!,
              filename: 'brand_image.jpg',
              contentType: MediaType.parse(brand.imageMimeType),
            ),
          );
    try {
      final response = await request.send();
      if (response.statusCode == 201) {
        final resp = await http.Response.fromStream(response);
        final data = jsonDecode(resp.body);
        final brand = BrandModel.fromJson(data);
        return brand;
      } else {
        BasicApiService.manageNotSuccessResponseCode(
          await http.Response.fromStream(response),
        );
      }
    } catch (e) {
      if (e is SocketException || e is http.ClientException) {
        throw ApiException(
          ApiExceptionCode.serverConnectionError.name,
          'Error al crear MassiveEvent: $e',
        );
      } else if (e is! ApiException) {
        throw ApiException(
          ApiExceptionCode.savingObjectError.name,
          'Error al crear MassiveEvent: $e',
        );
      }
      rethrow;
    }
  }
}
