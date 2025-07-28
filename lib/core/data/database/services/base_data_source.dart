abstract class IEntityDataSource<T> {
  Future<void> saveEntity(T entity);
  Future<T?> getEntityById(String id);
  Future<List<T>> getAllEntities();
  Future<void> deleteEntity(String id);
}
