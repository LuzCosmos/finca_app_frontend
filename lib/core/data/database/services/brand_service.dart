import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import 'package:finca_app_frontend/core/data/database/app_database_mobile.dart';
import 'package:finca_app_frontend/core/data/database/repositories/brand_repository.dart';

class BrandService {
  final BrandRepository repo;

  BrandService({required this.repo});

  Future<void> createBrand({
    required String idTenant,
    required String name,
    required Uint8List imageBytes,
    required String imageMimeType,
  }) async {
    final uuid = const Uuid().v4();
    final brand = BrandLocalCompanion.insert(
      id: uuid,
      idTenant: idTenant,
      name: name,
      imageBytes: imageBytes,
      imageMimeType: imageMimeType,
      imageFileName: uuid,
      createdAt: Value(DateTime.now()),
      isSynced: const Value(false),
    );
    await repo.create(brand);
  }
}
