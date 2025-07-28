import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import 'package:finca_app_frontend/core/data/database/app_database_mobile.dart';
import 'package:finca_app_frontend/core/data/database/repositories/brand_repository.dart';

class BrandService {
  final BrandRepository repo;
  final String baseUrl;
  final Future<String> Function() getToken;
  final Future<bool> Function() hasNetwork;

  BrandService({
    required this.repo,
    required this.baseUrl,
    required this.getToken,
    required this.hasNetwork,
  });

  Future<void> createBrand({
    required String idTenant,
    required String name,
    String? imageUrl,
  }) async {
    final uuid = const Uuid().v4();
    final brand = BrandLocalCompanion.insert(
      id: uuid,
      idTenant: idTenant,
      name: name,
      imageUrl: Value(imageUrl),
      createdAt: Value(DateTime.now()),
      isSynced: const Value(false),
    );

    await repo.create(brand);

    if (await hasNetwork()) {
      final token = await getToken();
      final res = await http.post(
        Uri.parse('$baseUrl/brands/sync'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "brands": [
            {
              "id": brand.id.value,
              "idTenant": idTenant,
              "name": name,
              "imageUrl": imageUrl,
              "createdAt": DateTime.now().toIso8601String(),
            },
          ],
        }),
      );
      if (res.statusCode == 200) {
        await repo.markAsSynced(brand.id.value);
      }
    }
  }
}
