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
  String get yes => 'Si';

  @override
  String get no => 'No';

  @override
  String get numberFormat => '#,##0.##';

  @override
  String get numberFormat_country => 'en_US';

  @override
  String get fixErrors => 'Por favor corrige los errores resaltados en rojo.';

  @override
  String get error_savingObject => 'Ocurrió un error inesperado al guardar.';

  @override
  String get error_badRequest =>
      'La solicitud no es válida. Revisa los datos e inténtalo de nuevo.';

  @override
  String get error_unauthorized =>
      'Tu sesión ha expirado o no tienes acceso. Inicia sesión nuevamente.';

  @override
  String get error_forbidden => 'No tienes permiso para realizar esta acción.';

  @override
  String error_notFound(Object object) {
    return 'No se encontró $object.';
  }

  @override
  String get error_methodNotAllowed =>
      'Esta acción no está permitida en este momento.';

  @override
  String get error_conflict => 'El registro ya existe.';

  @override
  String get error_preconditionFailed =>
      'No se cumplen las condiciones para realizar esta acción.';

  @override
  String get error_unprocessableEntity =>
      'Algunos datos no son válidos. Por favor corrígelos e inténtalo de nuevo.';

  @override
  String get error_locked =>
      'El recurso está bloqueado por otra operación en curso. Intenta nuevamente más tarde.';

  @override
  String get error_tooManyRequests =>
      'Has hecho demasiadas solicitudes. Intenta de nuevo más tarde.';

  @override
  String get error_serverConnection =>
      'No se pudo conectar con el servidor. Verifica tu conexión a internet o inténtalo más tarde.';

  @override
  String get error_server => 'Error interno del servidor. Intenta más tarde.';

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
  String get eventDate => 'Fecha de Evento';

  @override
  String get eventFinish => 'Terminar';

  @override
  String get addEventDetail => 'Agregar Evento';

  @override
  String get activeDetails => 'Eventos activos:';

  @override
  String get noActiveDetails => 'Sin detalles activos';

  @override
  String get deactivateTooltip => 'Desactivar';

  @override
  String get inactiveTitle => 'Inactivos:';

  @override
  String get noInactive => 'Sin eventos inactivos.';

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
  String get tableEartag => 'Arete';

  @override
  String get tableBrand => 'Marca';

  @override
  String get tableMedication => 'Medicación';

  @override
  String get tableCastration => 'Castrado';

  @override
  String get tableSynced => 'Sincronizado';

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

  @override
  String get error_noSimpleEventsApplied =>
      'No se puede cerrar el evento masivo porque no se ha aplicado ningún evento simple a ningún animal.';

  @override
  String get error_massiveEventAlreadyClosed =>
      'Este evento masivo ya está cerrado y no puede modificarse.';

  @override
  String get event_finishSuccess =>
      'El evento masivo se finalizó correctamente.';

  @override
  String get sales_title => 'Ventas';

  @override
  String get sales_addSale => 'Agregar Venta';

  @override
  String get sales_searchPlaceholder => 'Buscar ventas...';

  @override
  String get sales_dateRange => 'Rango de Fechas';

  @override
  String get sales_clearFilters => 'Limpiar Filtros';

  @override
  String get sales_rowsPerPage => 'Filas por página:';

  @override
  String get sales_refresh => 'Actualizar';

  @override
  String get sales_noData => 'No hay datos de ventas disponibles';

  @override
  String get sales_noDataFiltered =>
      'No se encontraron ventas con los filtros actuales';

  @override
  String get sales_tryAdjustFilters => 'Intenta ajustar tus filtros';

  @override
  String get sales_createFirstSale => 'Crea tu primera venta para comenzar';

  @override
  String get sales_date => 'Fecha';

  @override
  String get sales_buyer => 'Comprador';

  @override
  String get sales_items => 'Artículos';

  @override
  String get sales_weight => 'Peso (kg)';

  @override
  String get sales_amount => 'Monto';

  @override
  String get sales_actions => 'Acciones';

  @override
  String get sales_viewDetails => 'Ver Detalles';

  @override
  String get sales_edit => 'Editar';

  @override
  String get sales_page => 'Página';

  @override
  String get sales_of => 'de';

  @override
  String get sales_showing => 'Mostrando';

  @override
  String get sales_editSale => 'Editar Venta';

  @override
  String get sales_saleDetails => 'Detalles de Venta';

  @override
  String get sales_transactionDate => 'Fecha de Transacción';

  @override
  String get sales_totalAmount => 'Monto Total';

  @override
  String get sales_totalWeight => 'Peso Total';

  @override
  String get sales_animals => 'Animales';

  @override
  String get sales_notes => 'Notas';

  @override
  String get sales_cattleList => 'Lista de Ganado';

  @override
  String get sales_noDetails => 'No hay detalles disponibles.';

  @override
  String get sales_cattleId => 'ID de Ganado';

  @override
  String get sales_price => 'Precio';

  @override
  String get sales_close => 'Cerrar';

  @override
  String get sales_cancel => 'Cancelar';

  @override
  String get sales_save => 'Guardar';

  @override
  String get sales_errorLoading => 'Error al cargar ventas';

  @override
  String get sales_retry => 'Reintentar';

  @override
  String get sales_previousPage => 'Página Anterior';

  @override
  String get sales_nextPage => 'Página Siguiente';
}
