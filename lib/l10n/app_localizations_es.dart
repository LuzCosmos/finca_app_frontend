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
  String get users => 'Usuarios';

  @override
  String get usersList => 'Lista de Usuarios';

  @override
  String get createUser => 'Crear Usuario';

  @override
  String get editUser => 'Editar Usuario';

  @override
  String get deleteUser => 'Eliminar Usuario';

  @override
  String get userCreatedSuccess => 'Usuario creado exitosamente';

  @override
  String get userUpdatedSuccess => 'Usuario actualizado exitosamente';

  @override
  String get userDeletedSuccess => 'Usuario eliminado exitosamente';

  @override
  String get userDeleteConfirmTitle => 'Eliminar Usuario';

  @override
  String get userDeleteConfirmBody =>
      '¿Estás seguro de que deseas eliminar este usuario? Esta acción no se puede deshacer.';

  @override
  String get selectRole => 'Seleccionar Rol';

  @override
  String get role => 'Rol';

  @override
  String get confirmPassword => 'Confirmar Contraseña';

  @override
  String get passwordMismatch => 'Las contraseñas no coinciden';

  @override
  String get noUsersFound => 'No se encontraron usuarios';

  @override
  String get firstName => 'Nombre';

  @override
  String get lastName => 'Apellido';

  @override
  String get email => 'Correo Electrónico';

  @override
  String get username => 'Nombre de Usuario';

  @override
  String get password => 'Contraseña';

  @override
  String get search => 'Buscar';

  @override
  String get optional => 'Opcional';

  @override
  String get fieldRequired => 'Este campo es obligatorio';

  @override
  String get invalidValue => 'Valor inválido';

  @override
  String get save => 'Guardar';

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
  String get error_readingObject => 'Ocurrió un error inesperado al leer.';

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
  String get error_eartagExist => 'Número de Eartag ya existe para otra res.';

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
  String get home_reception => 'Recepción';

  @override
  String get cattle => 'Res';

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
  String get purchase_totalWeightKg => 'Peso total (Kg)';

  @override
  String get purchase_totalCattle => 'Reses totales';

  @override
  String get noPurchasesFound => 'Compra no encontrada';

  @override
  String get purchaseStatusOpen => 'Abierta';

  @override
  String get purchaseStatusReceived => 'Recibida';

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
  String get accept => 'Aceptar';

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
  String get purchaseReceptionTitle => 'Recepción de compra';

  @override
  String get purchaseBatchesTitle => 'Lotes de la compra';

  @override
  String get withoutLot => 'Sin lote';

  @override
  String get cattleOfSelection => 'Reses de la selección';

  @override
  String get simpleEventsTitle => 'Eventos simples';

  @override
  String get selectAnimalHint => 'Selecciona una res para ver sus eventos';

  @override
  String get appliedEvents => 'Aplicados';

  @override
  String get availableEvents => 'Disponibles';

  @override
  String get assignLot => 'Asignar lote';

  @override
  String get receivedOk => 'Res recibida';

  @override
  String get cattleNumber => 'Número';

  @override
  String get weightKg => 'Peso (kg)';

  @override
  String get color => 'Color';

  @override
  String get characteristics => 'Características';

  @override
  String get eartag => 'Arete';

  @override
  String get trackerId => 'Tracker';

  @override
  String get addCattle => 'Agregar res';

  @override
  String get cattle_exists_error => 'El número ya existe (Activa/Perdida)';

  @override
  String get eartag_exists_error => 'El arete ya existe (Activa/Perdida)';

  @override
  String cattleCountLabel(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reses',
      one: '1 res',
      zero: '0 reses',
    );
    return '$_temp0';
  }

  @override
  String purchaseCountLabel(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reses',
      one: '1 res',
      zero: '0 reses',
    );
    return '$_temp0';
  }

  @override
  String get receptionDate => 'Fecha de recepción';

  @override
  String get initialCattleNumber => 'Número res inicial';

  @override
  String get numberInUse => 'Este número ya está en uso';

  @override
  String get hasHorns => 'Tiene cachos';

  @override
  String get age => 'Edad';

  @override
  String get gender => 'Género';

  @override
  String get isCastrated => 'Está castrado';

  @override
  String get comments => 'Comentarios';

  @override
  String get receiveCattle => 'Recibir res';

  @override
  String get purchasedAvgWeight => 'Peso Prom. Comprado (kg)';

  @override
  String get receivedAvgWeight => 'Peso Prom. Recibido (kg)';

  @override
  String get unassignedCattle => 'Reses sin lote identificado';

  @override
  String get assignLotTitle => 'Asignar Lote';

  @override
  String get selectLot => 'Seleccionar Lote';

  @override
  String get providerName => 'Proveedor';

  @override
  String get eventsApplied => 'Eventos Aplicados';

  @override
  String get noEventsApplied => 'Sin eventos aplicados';

  @override
  String get receivedCount => 'Recibidos';

  @override
  String get purchasedCount => 'Comprados';

  @override
  String get actions => 'Acciones';

  @override
  String get from => 'Desde';

  @override
  String get to => 'Hasta';

  @override
  String get all => 'Todas';

  @override
  String get pending => 'Pendientes';

  @override
  String get received => 'Recibidas';

  @override
  String get receiveAction => 'Recibir';

  @override
  String get rowsPerPage => 'Filas por página';

  @override
  String get page => 'Página';

  @override
  String get results => 'resultados';

  @override
  String get previous => 'Anterior';

  @override
  String get next => 'Siguiente';

  @override
  String get receivedCattle => 'Cant. recibida';

  @override
  String get refresh => 'Actualizar';

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

  @override
  String get provider_selectOrCreate => 'Seleccionar o crear proveedor';

  @override
  String get provider_searchByName => 'Buscar por nombre...';

  @override
  String get provider_createNew => 'Crear Nuevo';

  @override
  String provider_providerName(Object providerTypeLabel) {
    return 'Nombre $providerTypeLabel';
  }

  @override
  String get provider_address => 'Dirección';

  @override
  String get provider_contactPersonName => 'Nombre de Contacto';

  @override
  String get provider_phone1 => 'Teléfono 1';

  @override
  String get provider_phone2 => 'Teléfono 2 (Opcional)';

  @override
  String get provider_email => 'Correo Electrónico';

  @override
  String get provider_buyer => 'Comprador';

  @override
  String get provider_transporter => 'Transportista';

  @override
  String get provider_providerType => 'Tipo';

  @override
  String get provider_creating => 'Creando...';

  @override
  String provider_createdSuccess(Object providerTypeLabel) {
    return '$providerTypeLabel creado exitosamente';
  }

  @override
  String provider_createError(Object providerTypeLabel) {
    return 'Error al crear $providerTypeLabel';
  }

  @override
  String get provider_nitLengthError =>
      'El NIT debe tener entre 5 y 20 caracteres';

  @override
  String get provider_nameLengthError =>
      'El nombre debe tener entre 3 y 50 caracteres';

  @override
  String get cattle_validation_validating => 'Validando ganado...';

  @override
  String get cattle_validation_invalid => 'Número de ganado inválido';

  @override
  String get cattle_validation_notFound => 'Res no encontrada';

  @override
  String get cattle_validation_notActive => 'El ganado no está ACTIVO';

  @override
  String get cattle_validation_sold => 'Esta res ya ha sido vendida';

  @override
  String get cattle_validation_dead => 'Esta res está marcada como muerta';

  @override
  String get cattle_validation_lost => 'Esta res está marcada como perdida';

  @override
  String get cattle_number => 'Número de Res';

  @override
  String get cattle_weight => 'Peso (kg)';

  @override
  String get cattle_addButton => 'Agregar';

  @override
  String get cattle_weightUnderMin => 'Peso Debajo del Mínimo';

  @override
  String cattle_weightUnderMinMessage(Object measured, Object min) {
    return 'El peso medido ($measured kg) está por debajo del peso mínimo ($min kg). Este ganado recibirá el peso mínimo para el cálculo de precio.';
  }

  @override
  String get cattle_approveQuestion => '¿Desea aprobar o rechazar este ganado?';

  @override
  String get cattle_approve => 'Aprobar';

  @override
  String get cattle_reject => 'Rechazar';

  @override
  String get cattle_approved_title => 'Ganado Aprobado';

  @override
  String get cattle_rejected_title => 'Ganado Rechazado';

  @override
  String cattle_approved_count(Object count) {
    return 'Aprobados ($count)';
  }

  @override
  String cattle_rejected_count(Object count) {
    return 'Rechazados ($count)';
  }

  @override
  String get cattle_noApproved => 'No hay ganado aprobado aún';

  @override
  String get cattle_noRejected => 'No hay ganado rechazado';

  @override
  String get cattle_remove => 'Eliminar';

  @override
  String get cattle_rejectionReason => 'Peso insuficiente';

  @override
  String get sale_confirm_title => 'Confirmar Creación de Venta';

  @override
  String sale_confirm_message(Object count) {
    return 'Los siguientes $count ganados aprobados serán marcados como VENDIDOS:';
  }

  @override
  String get sale_confirm_warning =>
      'Esta acción no se puede deshacer. ¿Continuar?';

  @override
  String get sale_confirm_proceed => 'Confirmar y Crear Venta';

  @override
  String get sale_creating => 'Creando venta...';

  @override
  String get sale_created => 'Venta creada exitosamente';

  @override
  String get sale_createError => 'Error al crear venta';

  @override
  String get user_editUser => 'Editar Usuario';

  @override
  String get user_logout => 'Cerrar Sesión';

  @override
  String get user_editUserPageTitle => 'Editar Usuario';

  @override
  String get user_editUserPageMessage =>
      'Esta funcionalidad está en desarrollo';

  @override
  String get newSale => 'Nueva Venta';

  @override
  String get saleSavedSuccess => 'Venta guardada exitosamente';

  @override
  String get cattleFoundPending =>
      'Ganado encontrado (Implementación pendiente)';

  @override
  String get minWeightKg => 'Peso Mín. (Kg)';

  @override
  String get scanEnterNumber => 'Escanear/Ingresar Número';

  @override
  String get salesDashboard => 'Tablero de Ventas';

  @override
  String get noOfflineSales =>
      'No hay ventas fuera de línea pendientes de sincronización.';

  @override
  String saleWithDate(String date) {
    return 'Venta $date';
  }

  @override
  String totalWithAmount(String amount) {
    return 'Total: $amount';
  }

  @override
  String get label_measuredWeight => 'Peso Medido';

  @override
  String get label_minimumWeight => 'Peso Mínimo';

  @override
  String get label_totalCattle => 'Total Reses';

  @override
  String get allPurchasedCattleReceived =>
      'Todos los animales comprados han sido recibidos';

  @override
  String get lotAssignedSuccessfully => 'Lote asignado exitosamente';

  @override
  String get error_enterCattleNumberWeight =>
      'Por favor ingrese el número de ganado y el peso';

  @override
  String get error_enterValidWeight => 'Por favor ingrese un peso válido';

  @override
  String get error_addApprovedCattle =>
      'Por favor agregue al menos un ganado aprobado';

  @override
  String get sale_info => 'Información de Venta';

  @override
  String get pricing_config => 'Configuración de Precios';

  @override
  String get hint_enterScanId => 'Ingresar o escanear ID';

  @override
  String get label_validating => 'Validando...';

  @override
  String get warning_set_min_weight =>
      'Por favor configure un peso mínimo en la configuración anterior antes de agregar ganado';

  @override
  String get label_summary => 'Resumen';

  @override
  String get error_invalid_number => 'Número inválido';

  @override
  String get error_invalid_price => 'Precio inválido';

  @override
  String get label_notes_optional => 'Notas (Opcional)';

  @override
  String get label_transporter_optional => 'Transportista (Opcional)';

  @override
  String get label_buyer_required => 'Comprador *';

  @override
  String get error_buyer_required => 'Comprador es requerido';

  @override
  String get label_price_per_kg_required => 'Precio / Kg *';

  @override
  String get label_cattle_management => 'Gestión de Ganado';

  @override
  String get tracker_removed => 'Rastreador Removido';

  @override
  String get user_usernameLengthError =>
      'El nombre de usuario debe tener entre 5 y 50 caracteres';

  @override
  String get user_firstNameLengthError =>
      'El nombre debe tener como máximo 50 caracteres';

  @override
  String get user_lastNameLengthError =>
      'El apellido debe tener como máximo 50 caracteres';

  @override
  String get user_passwordLengthError =>
      'La contraseña debe tener entre 8 y 50 caracteres';

  @override
  String get searchTracker => 'Buscar tracker...';

  @override
  String get trackerNotFound => 'Tracker no encontrado';

  @override
  String get trackerNotSelected => 'Tracker no seleccionado';

  @override
  String get colSystemNumber => 'No. Sistema';

  @override
  String get colBrandColor => 'Color';

  @override
  String get colCharacteristics => 'Características';

  @override
  String get colHorns => 'Cachos';

  @override
  String get colCastrated => 'Castrado';

  @override
  String get colReceivedAt => 'Received At';

  @override
  String get colReceivedWeight => 'Peso Recibido';

  @override
  String get colPurchaseWeight => 'Peso Compra (kg)';

  @override
  String get colReceivedDate => 'Fecha Recibido';

  @override
  String get colComments => 'Comentarios';

  @override
  String get colPurchasePrice => 'Precio Compra';

  @override
  String get colPurchaseCommission => 'Comisión';

  @override
  String get colStatus => 'Estado';

  @override
  String get colWeightHistory => 'Hist. Peso';

  @override
  String get colMedicationHistory => 'Hist. Medicamentos';

  @override
  String get colSaleWeight => 'Peso Venta';

  @override
  String get colSalePrice => 'Precio Venta';

  @override
  String get colAge => 'Edad';

  @override
  String get colGender => 'Género';

  @override
  String get colLastWeight => 'último Peso';

  @override
  String get masterListTitle => 'Lista Maestra de Ganado';

  @override
  String get addCattleRow => 'Agregar Res';

  @override
  String get colorBlack => 'Negro';

  @override
  String get colorWhite => 'Blanco';

  @override
  String get colorBrown => 'Café';

  @override
  String get colorBlackBrown => 'Negro-Café';

  @override
  String get colorLightBrown => 'Café Claro';

  @override
  String get colorGrey => 'Gris';

  @override
  String get charBlackBelly => 'Barriga Negra';

  @override
  String get charWhiteBelly => 'Barriga Blanca';

  @override
  String get charBrownBelly => 'Barriga Café';

  @override
  String get charLightBrownBelly => 'Barriga Café Clara';

  @override
  String get charGreyBelly => 'Barriga Gris';

  @override
  String get charBlackHead => 'Cabeza Negra';

  @override
  String get charWhiteHead => 'Cabeza Blanca';

  @override
  String get charBrownHead => 'Cabeza Café';

  @override
  String get charLightBrownHead => 'Cabeza Café Clara';

  @override
  String get charGreyHead => 'Cabeza Gris';

  @override
  String get charBlackHalfHead => 'Media Cabeza Negra';

  @override
  String get charWhiteHalfHead => 'Media Cabeza Blanca';

  @override
  String get charBrownHalfHead => 'Media Cabeza Café';

  @override
  String get charLightBrownHalfHead => 'Media Cabeza Café Clara';

  @override
  String get charGreyHalfHead => 'Media Cabeza Gris';

  @override
  String get charBlackLegs => 'Patas Negras';

  @override
  String get charWhiteLegs => 'Patas Blancas';

  @override
  String get charBrownLegs => 'Patas Café';

  @override
  String get charLightBrownLegs => 'Patas Café Claras';

  @override
  String get charGreyLegs => 'Patas Grises';

  @override
  String get charBlackFeet => 'Pies Negros';

  @override
  String get charWhiteFeet => 'Pies Blancos';

  @override
  String get charBrownFeet => 'Pies Café';

  @override
  String get charLightBrownFeet => 'Pies Café Claros';

  @override
  String get charGreyFeet => 'Pies Grises';

  @override
  String get charBlackSpots => 'Manchas Negras';

  @override
  String get charBrownSpots => 'Manchas Café';

  @override
  String get charLightBrownSpots => 'Manchas Café Claras';

  @override
  String get charGreySpots => 'Manchas Grises';

  @override
  String get charBlackPattern => 'Patrón Negro';

  @override
  String get charBrownPattern => 'Patrón Café';

  @override
  String get genderMale => 'Macho';

  @override
  String get genderFemale => 'Hembra';

  @override
  String get statusActive => 'Activo';

  @override
  String get statusSold => 'Vendido';

  @override
  String get statusDead => 'Muerto';

  @override
  String get statusLost => 'Perdido';

  @override
  String get noData => 'No hay datos disponibles';

  @override
  String get recordedBy => 'Registrado por';

  @override
  String get close => 'Cerrar';

  @override
  String get dosage => 'Dosis';

  @override
  String get route => 'Vía';

  @override
  String get appliedBy => 'Aplicado por';

  @override
  String get addMedication => 'Agregar Medicación';

  @override
  String get date => 'Fecha';
}
