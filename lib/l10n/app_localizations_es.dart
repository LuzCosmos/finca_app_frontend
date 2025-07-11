// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Finca App';

  @override
  String get fieldRequired => 'Este campo es obligatorio';

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
  String get purchaseLotCountError =>
      'La cantidad de reses en el lote debe ser mayor a 0.';

  @override
  String get cp_purchaseDate => 'Fecha de Compra';

  @override
  String get cp_createPurchase => 'Crear Compra';

  @override
  String get cp_errors_noLots => 'Debe agregar al menos un lote';

  @override
  String get cp_errors_cattleCountRequired =>
      'La cantidad de ganado debe ser mayor a 0';

  @override
  String get purchase_provider_required => 'Por favor seleccione un proveedor.';

  @override
  String get purchase_no_valid_lots => 'At least one valid lot is required.';

  @override
  String get purchase_save_success => 'Compra guardada exitosamente.';

  @override
  String get purchase_save_error => 'Falló el guardado de compra.';

  @override
  String get cp_provider => 'Proveedor';

  @override
  String get cp_nit => 'NIT';

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
  String get lotsTitle => 'Lotes';

  @override
  String get lot => 'Lote';

  @override
  String get addLot => 'Agregar lote';

  @override
  String get removeLot => 'Eliminar lote';

  @override
  String get lot_lotNumber => 'Número de lote';

  @override
  String get lot_origin => 'Procedencia';

  @override
  String get lot_age => 'Edad';

  @override
  String get lot_gender => 'Sexo';

  @override
  String get lot_avgWeight => 'Peso Promedio (kg)';

  @override
  String get lot_pricePerKg => 'Valor por Kilo';

  @override
  String get lot_cattleCount => 'Cantidad';

  @override
  String get lot_totalWeight => 'Peso Total';

  @override
  String get lot_totalValue => 'Valor Total';

  @override
  String get lot_cattleCountRequired =>
      'Por favor ingrese la cantidad de reses';

  @override
  String get lot_totalWeightRequired => 'Por favor ingrese el peso total';

  @override
  String get lot_pricePerKgRequired => 'Please enter the price per kilo';

  @override
  String get lot_cattleCountInvalid => 'Ingrese una cantidad válida de reses';

  @override
  String get lot_totalWeightInvalid => 'Ingrese un peso válido';

  @override
  String get lot_pricePerKgInvalid => 'Enter a valid price per kilo';

  @override
  String get lotRequired => 'Por favor ingrese el número de lote';
}
