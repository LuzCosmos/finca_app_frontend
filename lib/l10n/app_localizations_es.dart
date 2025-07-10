// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get testMedium => 'Prueba en español';

  @override
  String get general_appTitle => 'Finca App';

  @override
  String get appTitle => 'Finca App';

  @override
  String get login_username => 'Usuario';

  @override
  String get login_usernameRequired => 'Ingrese su usuario';

  @override
  String get login_password => 'Contraseña';

  @override
  String get login_passwordRequired => 'Ingrese su contraseña';

  @override
  String get login_company => 'Compañía';

  @override
  String get login_login => 'Iniciar sesión';

  @override
  String get login_loginError =>
      'Error al iniciar sesión, por favor intente de nuevo';

  @override
  String get login_invalidCredentials =>
      'Credenciales incorrectas. Por favor, inténtelo de nuevo.';

  @override
  String get login_unexpectedError =>
      'Ocurrió un error inesperado. Intente más tarde.';

  @override
  String get home_title => 'Inicio';

  @override
  String get home_purchase => 'Compra';

  @override
  String get home_purchaseReception => 'Recepción de compra';

  @override
  String get home_massiveEvent => 'Evento masivo';

  @override
  String get home_sale => 'Venta';

  @override
  String get cattlePurchase => 'Compra de Ganado';

  @override
  String get cp_provider => 'Proveedor';

  @override
  String get cp_nit => 'NIT';

  @override
  String get cp_purchaseDate => 'Fecha de Compra';

  @override
  String get cp_addLot => 'Agregar Lote';

  @override
  String get cp_lot => 'Lote';

  @override
  String get cp_origin => 'Procedencia';

  @override
  String get cp_quantity => 'Cantidad';

  @override
  String get cp_age => 'Edad';

  @override
  String get cp_gender => 'Sexo';

  @override
  String get cp_avgWeight => 'Peso Promedio (kg)';

  @override
  String get cp_totalWeight => 'Peso Total';

  @override
  String get cp_pricePerKg => 'Valor por Kilo';

  @override
  String get cp_totalValue => 'Valor Total';

  @override
  String get cp_totalCattle => 'Total de Reses';

  @override
  String get cp_createPurchase => 'Crear Compra';

  @override
  String get cp_createProvider => 'Crear proveedor';

  @override
  String get cp_providerFound => 'Proveedor encontrado y cargado.';

  @override
  String get cp_providerWillBeCreated =>
      'Se creará un nuevo proveedor con este NIT.';

  @override
  String get cp_providerIsRequired => 'El nombre del proveedor is requested';

  @override
  String get cp_nitIsRequired => 'NIT is requested';

  @override
  String get cp_providerCreatedSuccessfully => 'Proveedor creado exitosamente';

  @override
  String get cp_providerNitAlreadyExists =>
      'Ya existe un proveedor con ese NIT';

  @override
  String get cp_providerCreationError => 'Error al crear proveedor';

  @override
  String get fieldRequired => 'Este campo es obligatorio';
}
