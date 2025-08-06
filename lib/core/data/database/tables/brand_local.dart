import 'package:drift/drift.dart';

@DataClassName('Brand')
class BrandLocal extends Table {
  TextColumn get id => text()();
  TextColumn get idTenant => text()();
  TextColumn get name => text()();
  // Imagen como binario
  BlobColumn get imageBytes => blob()();
  // Tipo MIME (image/png, image/jpeg, etc.)
  TextColumn get imageMimeType => text()();
  TextColumn get imageFileName => text()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
