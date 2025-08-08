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
  String get invalidValue => 'Valor inválido';

  @override
  String get delete => 'Eliminar';

  @override
  String get fixErrors => 'Por favor corrige los errores resaltados en rojo.';

  @override
  String get numberFormat => '#,##0.##';

  @override
  String get numberFormat_country => 'en_US';

  @override
  String get error_invalidData => 'Datos inválidos en el formulario.';

  @override
  String get error_forbidden => 'No tienes permiso para realizar esta acción.';

  @override
  String get error_conflict => 'Duplicidad en base de datos';

  @override
  String get error_server => 'Error interno del servidor. Intenta más tarde.';

  @override
  String get error_savingObject => 'Ocurrió un error inesperado al guardar';

  @override
  String error_notFound(Object object) {
    return '$object no encontrado';
  }

  @override
  String get error_unauthorized =>
      'Tu sesión ha expirado y necesitas iniciar sesión nuevamente.';

  @override
  String get error_serverConnection =>
      'No se pudo conectar con el servidor. Verifica tu conexión a internet o intenta más tarde.';

  @override
  String get error_generic => 'Ha ocurrido un error inesperado.';

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
  String get purchase_date => 'Fecha de Compra';

  @override
  String get purchase_dateRequired => 'Debes seleccionar una fecha de compra.';

  @override
  String get purchase_create => 'Crear Compra';

  @override
  String get purchase_saveSuccess => 'Compra guardada exitosamente.';

  @override
  String get purchase_saveError => 'Falló el guardado de compra.';

  @override
  String get cattlePurchase => 'Compra de Ganado';

  @override
  String get cp_error_noLots => 'Debe agregar al menos un lote';

  @override
  String get cp_error_providerRequired =>
      'Por favor seleccione o cree un proveedor.';

  @override
  String get provider => 'Proveedor';

  @override
  String get provider_nit => 'NIT';

  @override
  String get provider_create => 'Crear proveedor';

  @override
  String get provider_found => 'Proveedor encontrado y cargado.';

  @override
  String get provider_willBeCreated =>
      'Se creará un nuevo proveedor con este NIT.';

  @override
  String get provider_nameIsRequired => 'El nombre del proveedor es requerido.';

  @override
  String get provider_nitIsRequired => 'NIT es requerido.';

  @override
  String get provider_createdSuccessfully => 'Proveedor creado exitosamente';

  @override
  String get provider_nitAlreadyExists => 'Ya existe un proveedor con ese NIT';

  @override
  String get provider_creationError => 'Error al crear proveedor';

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
  String get lot_avgWeight => 'Peso Prom. (kg)';

  @override
  String get lot_pricePerKg => 'Vlr. por Kilo';

  @override
  String get lot_cattleCount => 'Cant.';

  @override
  String get lot_totalWeight => 'Peso Total';

  @override
  String get lot_totalValue => 'Valor Total';

  @override
  String get lot_pricePerHead => 'Precio Prom. por Res';

  @override
  String get lot_pricePerHeadRequired =>
      'Por favor ingrese el precio promedio por res.';

  @override
  String get lot_pricePerHeadInvalid =>
      'Ingrese un precio promedio por res válido.';

  @override
  String get lot_numberRequired => 'Por favor ingrese el número de lote.';

  @override
  String get lot_duplicateLotNumber =>
      'Dos o más lotes tienen el mismo número de lote.';

  @override
  String get lot_avgWeightRequired => 'Por favor ingrese el peso promedio(Kg).';

  @override
  String get lot_avgWeightInvalid => 'El peso promedio debe ser mayor a 0.';

  @override
  String get lot_pricePerKgRequired => 'Por favor ingrese el precio por kilo';

  @override
  String get lot_pricePerKgInvalid => 'Ingrese un precio por kilo válido';

  @override
  String get lot_cattleCountRequired =>
      'Por favor ingrese la cantidad de reses en el lote.';

  @override
  String get lot_cattleCountInvalid =>
      'La cantidad de reses en el lote debe ser mayor a 0.';

  @override
  String get lot_totalWeightRequired => 'Por favor ingrese el peso total.';

  @override
  String get lot_totalWeightInvalid => 'Ingrese un peso total válido';

  @override
  String get lot_countAvWeightPriceKgRequired =>
      'Cada lote debe tener cantidad de reses, peso promedio y precio por kg mayor que cero.';

  @override
  String get lots_summaryAverageTitle => 'Promedio';

  @override
  String get lots_summaryTotalTitle => 'Total';

  @override
  String get addAnimalTitle => 'Res';

  @override
  String get animalNumberLabel => 'Número de Animal';

  @override
  String get weightLabel => 'Peso (kg)';

  @override
  String get trackerLabel => 'Tracker';

  @override
  String get eartagLabel => 'Arete de oido';

  @override
  String get applyButton => 'Aplicar';

  @override
  String get eventConfigTitle => 'Configuración de Eventos';

  @override
  String get addEventDetail => 'Agregar Evento';

  @override
  String get activeDetails => 'Eventos activos:';

  @override
  String get noActiveDetails => 'Sin detalles activos';

  @override
  String get deactivateTooltip => 'Desactivar';

  @override
  String get historyTitle => 'Historial:';

  @override
  String get noHistory => 'Sin historial todavía';

  @override
  String get reactivateTooltip => 'Reactivar';

  @override
  String onlyOneType(Object type) {
    return 'Solo puede haber un evento de tipo $type en este Evento Masivo.';
  }

  @override
  String brandAlreadyExists(Object brand) {
    return 'Ya existe la marca \"$brand\" en este Evento Masivo.';
  }

  @override
  String reactivatedInfo(Object name) {
    return 'Se reactivó \"$name\".';
  }

  @override
  String get eventTypeWeight => 'Peso';

  @override
  String get eventTypeCastration => 'Castración';

  @override
  String get eventTypeTracker => 'Asignar Tracker';

  @override
  String get eventTypeEartag => 'Poner Arete';

  @override
  String get eventTypeMedication => 'Medicación';

  @override
  String get eventTypeBrand => 'Marcado';

  @override
  String get medicationName => 'Nombre';

  @override
  String get medicationDosage => 'Dosis';

  @override
  String get medicationRoute => 'Vía de aplicación';

  @override
  String get medicationLot => 'Lote de fabricación';

  @override
  String get selectBrand => 'Seleccione una marca';

  @override
  String get createNewBrand => 'Crear nueva marca';

  @override
  String get cancel => 'Cancelar';

  @override
  String get add => 'Agregar';

  @override
  String get createNewBrandTitle => 'Crear Nueva Brand';

  @override
  String get brandName => 'Nombre';

  @override
  String get selectImage => 'Seleccionar imagen';

  @override
  String get imageRequired => 'La imagen es obligatoria';

  @override
  String get create => 'Crear';

  @override
  String get noAnimals => 'Aún no se han agregado animales';

  @override
  String get tableAnimal => 'Animal';

  @override
  String get tableWeight => 'Peso';

  @override
  String get tableTracker => 'Identificador';

  @override
  String get tableStatus => 'Estado';

  @override
  String get simpleEventAdded => 'Detalle agregado correctamente';

  @override
  String get simpleEventError => 'Ocurrió un error al agregar el detalle';

  @override
  String simpleEventApplied(Object cattleNumber) {
    return 'Los eventos activos fueron aplicados a la res número $cattleNumber';
  }

  @override
  String get applyAtLeastOneSimpleEvent =>
      'Se debe de Aplicar al menos un evento.';

  @override
  String get eventsApplicationNotice =>
      'Todos los eventos han sido aplicados. Si alguno aparece sin aplicar, asegúrate de haber ingresado toda la información obligatoria.';
}
