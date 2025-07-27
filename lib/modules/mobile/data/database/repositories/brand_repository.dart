import 'package:finca_app_frontend/modules/mobile/data/database/app_database_mobile.dart';
import 'package:finca_app_frontend/modules/mobile/data/database/daos/brand_dao.dart';

class BrandRepository {
  final BrandDao _dao;

  BrandRepository(this._dao);

  /// Crear un nuevo brand offline
  Future<int> create(BrandLocalCompanion brand) {
    return _dao.insert(brand);
  }

  /// Obtener todos los brands del tenant actual
  Future<List<Brand>> getAll(String idTentant) {
    return _dao.getAll(idTentant);
  }

  /// Eliminar un brand específico (por ejemplo, descartado antes de sincronizar)
  Future<void> deleteBrand(String id) {
    return _dao.deleteBrand(id);
  }

  /// Marcar como sincronizado después de enviarlo al backend
  Future<void> markAsSynced(String id) {
    return _dao.markAsSynced(id);
  }
}
