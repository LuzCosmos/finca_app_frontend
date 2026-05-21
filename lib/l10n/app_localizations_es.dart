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
  String get create => 'Crear';

  @override
  String createSomething(Object object) {
    return 'Crear $object';
  }

  @override
  String createNewSomething(Object object) {
    return 'Crear nuevo $object';
  }

  @override
  String get add => 'Agregar';

  @override
  String addSomething(Object object) {
    return 'Agregar $object';
  }

  @override
  String get edit => 'Editar';

  @override
  String editSomething(Object object) {
    return 'Editar $object';
  }

  @override
  String get update => 'Actualizar';

  @override
  String updateSomething(Object object) {
    return 'Actualizar $object';
  }

  @override
  String get refresh => 'Actualizar';

  @override
  String get delete => 'Eliminar';

  @override
  String deleteSomething(Object object) {
    return 'Eliminar $object';
  }

  @override
  String get remove => 'Remover';

  @override
  String removeSomething(Object object) {
    return 'Remover $object';
  }

  @override
  String get save => 'Guardar';

  @override
  String saveSomething(Object object) {
    return 'Guardar $object';
  }

  @override
  String get select => 'Seleccionar';

  @override
  String selectSomething(Object object) {
    return 'Seleccionar $object';
  }

  @override
  String get assign => 'Asignar';

  @override
  String assignSomething(Object object) {
    return 'Asignar $object';
  }

  @override
  String get apply => 'Aplicar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get finish => 'Terminar';

  @override
  String get close => 'Cerrar';

  @override
  String get accept => 'Aceptar';

  @override
  String get open => 'Abierto';

  @override
  String get view => 'Ver';

  @override
  String get search => 'Buscar';

  @override
  String get filter => 'Filtrar';

  @override
  String get receive => 'Recibir';

  @override
  String get approve => 'Aprobar';

  @override
  String get reject => 'Rechazar';

  @override
  String get retry => 'Reintentar';

  @override
  String get sort => 'Ordenar';

  @override
  String get export => 'Exportar';

  @override
  String get import => 'Importar';

  @override
  String get print => 'Imprimir';

  @override
  String get download => 'Descargar';

  @override
  String get upload => 'Subir';

  @override
  String get optional => 'Opcional';

  @override
  String get actions => 'Acciones';

  @override
  String get from => 'Desde';

  @override
  String get to => 'Hasta';

  @override
  String get l10n_of => 'de';

  @override
  String get page => 'Página';

  @override
  String get results => 'resultados';

  @override
  String get previous => 'Anterior';

  @override
  String get next => 'Siguiente';

  @override
  String get rowsPerPage => 'Filas por página';

  @override
  String get fieldRequired => 'Este campo es obligatorio.';

  @override
  String get invalidValue => 'Valor inválido.';

  @override
  String get all => 'Todas';

  @override
  String get yes => 'Si';

  @override
  String get no => 'No';

  @override
  String get notApplied => 'No aplicado';

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
  String get error_cattleIsNotActive => 'La res no está activa.';

  @override
  String get error_soldCattleMissingSaleDetail =>
      'La res vendida debe tener un detalle de venta asociado.';

  @override
  String get error_saleFieldsOnlyForSoldCattle =>
      'El precio y peso de venta solo pueden actualizarse para reses en estado VENDIDO.';

  @override
  String get error_invalidSalePrice => 'Precio de venta inválido.';

  @override
  String get error_invalidSaleWeight => 'Peso de venta inválido.';

  @override
  String error_savingField(Object error) {
    return 'Error al guardar: $error';
  }

  @override
  String get noData => 'No hay datos disponibles';

  @override
  String noDataSomething(Object object) {
    return 'No hay datos de $object disponibles';
  }

  @override
  String noDataFiltered(Object object) {
    return 'No se encontraron $object con los filtros actuales';
  }

  @override
  String get tryAdjustFilters => 'Intenta ajustar tus filtros';

  @override
  String get clearFilters => 'Limpiar Filtros';

  @override
  String get home_title => 'Inicio';

  @override
  String get onlineFeatureRequiresConnection =>
      'Esta función requiere conexión a internet.';

  @override
  String get dashboard_title => 'Dashboard';

  @override
  String get dashboard_welcome => 'Resumen de la finca';

  @override
  String get dashboard_description =>
      'Consulta el mapa de ganado y los reportes disponibles para tu usuario.';

  @override
  String get dashboard_cattleMapTitle => 'Mapa de ganado';

  @override
  String get dashboard_cattleMapSubtitle =>
      'Última ubicación reportada por cada res con rastreador.';

  @override
  String get dashboard_reportsTitle => 'Reportes generales';

  @override
  String get dashboard_reportsSubtitle =>
      'Resumen de inventario, cuido y ganancia diaria promedio.';

  @override
  String get dashboard_reportsPending =>
      'Los widgets de reportes reutilizables se mostrarán aquí conforme se implementen. Cada reporte conserva su propio filtro de acceso.';

  @override
  String get reports_general_loadError => 'No se pudieron cargar los reportes.';

  @override
  String get reports_onFeed_title => 'Reses en cuido';

  @override
  String get reports_onFeed_empty => 'No hay reses activas ni vendidas.';

  @override
  String get reports_onFeed_legend =>
      'En cuido = con fecha de inicio de alimentación registrada.';

  @override
  String reports_onFeed_onFeed(int count) {
    return 'En cuido: $count';
  }

  @override
  String reports_onFeed_active(int count) {
    return 'Activas: $count';
  }

  @override
  String reports_onFeed_sold(int count) {
    return 'Vendidas: $count';
  }

  @override
  String reports_onFeed_total(int count) {
    return 'Total: $count';
  }

  @override
  String get reports_byStatus_title => 'Reses por estado';

  @override
  String get reports_byStatus_empty => 'No hay reses registradas.';

  @override
  String reports_byStatus_total(int count) {
    return 'Total: $count';
  }

  @override
  String get reports_status_active => 'Activas';

  @override
  String get reports_status_sold => 'Vendidas';

  @override
  String get reports_status_dead => 'Muertas';

  @override
  String get reports_status_lost => 'Perdidas';

  @override
  String get reports_adg_title => 'Ganancia diaria promedio';

  @override
  String get reports_adg_subtitle => 'Promedio de finca (kg/día)';

  @override
  String get reports_adg_empty =>
      'No hay datos para calcular la ganancia diaria promedio.';

  @override
  String reports_adg_value(String value) {
    return '$value kg/día';
  }

  @override
  String get date => 'Fecha';

  @override
  String dateSomething(Object object) {
    return 'Fecha de $object';
  }

  @override
  String get username => 'Usuario';

  @override
  String get user => 'Usuario';

  @override
  String get users => 'Usuarios';

  @override
  String listSomething(Object object) {
    return 'Lista de $object';
  }

  @override
  String get cattle => 'Res';

  @override
  String get cattles => 'Reses';

  @override
  String get animal => 'Animal';

  @override
  String get animals => 'Animales';

  @override
  String get lot => 'Lote';

  @override
  String get lots => 'Lotes';

  @override
  String get withoutLot => 'Sin lote';

  @override
  String get purchase => 'Compra';

  @override
  String get purchases => 'Compras';

  @override
  String get cattlePurchase => 'Compra de Ganado';

  @override
  String get massiveEvent => 'Evento masivo';

  @override
  String get massiveEvents => 'Eventos masivos';

  @override
  String get massiveEventsListTitle => 'Eventos masivos';

  @override
  String get massiveEventsListEmpty => 'No hay eventos masivos que mostrar.';

  @override
  String get massiveEvents_createFirstEvent =>
      'Crea tu primer evento masivo para comenzar';

  @override
  String get massiveEventsListLoadError =>
      'No se pudo cargar la lista de eventos masivos.';

  @override
  String get massiveEventsListOffline =>
      'Sin conexión. Solo se muestran los datos disponibles en el dispositivo.';

  @override
  String get massiveEventsListFiltersTitle => 'Filtros';

  @override
  String get massiveEventsNoListPermission =>
      'No tiene permiso para ver el historial. Puede crear un evento nuevo.';

  @override
  String get massiveEventsSearchName => 'Nombre';

  @override
  String get massiveEventsNoMatchesFilter =>
      'Ningún evento masivo coincide con los filtros actuales.';

  @override
  String get massiveEventsColumnEventDate => 'Fecha evento';

  @override
  String get massiveEventsColumnName => 'Nombre Evento';

  @override
  String get massiveEventNameRequired =>
      'El nombre del evento masivo es obligatorio';

  @override
  String get massiveEventNameMaxLength =>
      'El nombre no puede superar 100 caracteres';

  @override
  String get massiveEventsColumnUpdatedAt => 'Última modificación';

  @override
  String get massiveEventsColumnCreatedAt => 'Fecha creación';

  @override
  String get massiveEventsColumnCreatedBy => 'Creado por';

  @override
  String get massiveEventsStatusClosedLabel => 'Cerrado';

  @override
  String get massiveEventsDetailInternalId => 'Identificador';

  @override
  String get massiveEventsDateShortcutToday => 'Hoy';

  @override
  String get massiveEventsDateShortcutThisWeek => 'Esta semana';

  @override
  String get massiveEventsListUnprocessableEntityHint =>
      'Revise los filtros o los datos enviados. Si el evento está vinculado a una recepción de compra, la operación puede no ser válida en el servidor.';

  @override
  String get massiveEventsEdit => 'Editar';

  @override
  String get massiveEventCloseValidationTitle => 'Corrija antes de finalizar';

  @override
  String get massiveEventCloseValidationIntro => 'Revise las siguientes filas:';

  @override
  String massiveEventValidationMissingWeight(String animalNumber) {
    return 'Animal $animalNumber: el peso es obligatorio antes de finalizar.';
  }

  @override
  String massiveEventValidationInvalidWeight(String animalNumber) {
    return 'Animal $animalNumber: el peso está fuera del rango permitido.';
  }

  @override
  String get massiveEventLoadSessionError =>
      'No se pudo cargar este evento masivo. Compruebe la conexión o inténtelo de nuevo.';

  @override
  String get massiveEventClosedReadOnly =>
      'Este evento masivo está cerrado: puede revisarlo pero no modificarlo.';

  @override
  String get massiveEventNoPreviousWeight => 'Sin peso previo';

  @override
  String get massiveEventPreviousWeightShort => 'Peso ant.';

  @override
  String get massiveEventDeltaPctShort => 'Δ%';

  @override
  String get massiveEventWeightSummaryTitle => 'Peso en esta sesión';

  @override
  String massiveEventWeightSummaryStats(
    int count,
    String mean,
    String min,
    String max,
  ) {
    return 'Animales con peso: $count · Media: $mean · Mín: $min · Máx: $max';
  }

  @override
  String get massiveEventWeightSummaryEmpty =>
      'Aún no hay pesos registrados en esta sesión.';

  @override
  String get dialogOk => 'Aceptar';

  @override
  String get event => 'Evento';

  @override
  String get events => 'Eventos';

  @override
  String get sale => 'Venta';

  @override
  String get sales => 'Ventas';

  @override
  String get role => 'Rol';

  @override
  String get roles => 'Roles';

  @override
  String get brand => 'Marca';

  @override
  String get brands => 'Marcas';

  @override
  String get provider => 'Proveedor';

  @override
  String get providers => 'Proveedores';

  @override
  String get buyer => 'Comprador';

  @override
  String get buyers => 'Compradores';

  @override
  String get transporter => 'Transportista';

  @override
  String get transporters => 'Transportistas';

  @override
  String get purchaseReception => 'Recepción de compra';

  @override
  String get reception => 'Recepción';

  @override
  String get cattleStatusActive => 'Activo';

  @override
  String get cattleStatusSold => 'Vendido';

  @override
  String get cattleStatusDead => 'Muerto';

  @override
  String get cattleStatusLost => 'Perdido';

  @override
  String get eventTypeWeight => 'Peso';

  @override
  String get eventTypeCastration => 'Castración';

  @override
  String get eventTypeTracker => 'Asignar Tracker';

  @override
  String get eventTypeEartag => 'Poner Eartag';

  @override
  String get eventTypeMedication => 'Medicación';

  @override
  String get eventTypeBrand => 'Marcado Brand';

  @override
  String get gender => 'Género';

  @override
  String get genderMale => 'Macho';

  @override
  String get genderFemale => 'Hembra';

  @override
  String get color => 'Color';

  @override
  String get colors => 'Colores';

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
  String get characteristic => 'Característica';

  @override
  String get characteristics => 'Características';

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
  String get status => 'Estado';

  @override
  String get purchaseStatusOpen => 'Abierta';

  @override
  String get purchaseStatusReceived => 'Recibida';

  @override
  String get received => 'Recibida';

  @override
  String get purchased => 'Comprada';

  @override
  String get sold => 'Vendida';

  @override
  String get name => 'Nombre';

  @override
  String get firstName => 'Nombre';

  @override
  String get lastName => 'Apellido';

  @override
  String get email => 'Correo Electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get company => 'Compañía';

  @override
  String get confirmPassword => 'Confirmar Contraseña';

  @override
  String get passwordMismatch => 'Las contraseñas no coinciden';

  @override
  String get address => 'Dirección';

  @override
  String get contactPersonName => 'Nombre de Contacto';

  @override
  String get phone1 => 'Teléfono 1';

  @override
  String get phone2 => 'Teléfono 2 (Opcional)';

  @override
  String get type => 'Tipo';

  @override
  String get login => 'Iniciar Sesión';

  @override
  String get logout => 'Cerrar Sesión';

  @override
  String get login_usernameRequired => 'Ingrese su usuario';

  @override
  String get login_passwordRequired => 'Ingrese su contraseña';

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
  String get systemNumber => 'No. Sistema';

  @override
  String get cattleNumber => 'Número de Res';

  @override
  String get animalNumber => 'Número de Animal';

  @override
  String get number => 'Número';

  @override
  String get lastWeightKg => 'Último Peso (kg)';

  @override
  String get estimatedWeightKg => 'Peso estimado (kg)';

  @override
  String get eartag => 'Arete';

  @override
  String get eartagLeft => 'Arete Izquierdo';

  @override
  String get eartagRight => 'Arete Derecho';

  @override
  String get horns => 'Cachos';

  @override
  String get castrated => 'Castrado';

  @override
  String get age => 'Edad';

  @override
  String get approxBirthDate => 'Fecha aprox. de nacimiento';

  @override
  String get approxBirthEditTitle => 'Fecha aprox. de nacimiento';

  @override
  String get calculateBirthByDentition => 'Calcular por dentición…';

  @override
  String get approxBirthFilledViaDentitionHint =>
      'Por dentición (se enviarán los datos del diálogo)';

  @override
  String get dentitionQuickFieldsSection => 'Dentición rápida (uso frecuente)';

  @override
  String get birthAprxModeManual => 'Fecha manual';

  @override
  String get birthAprxModeDentition => 'Por dentición';

  @override
  String get milkTeethCountShort => 'Dientes de leche';

  @override
  String get permanentTeethCountShort => 'Dientes permanentes';

  @override
  String get milkTeethWearShort => 'Desgaste leche';

  @override
  String get permanentTeethWearShort => 'Desgaste permanentes';

  @override
  String get teethWearGrade0 => 'No aplica / diente no presente';

  @override
  String get teethWearGrade1 => 'Erupcionado, sin desgaste visible';

  @override
  String get teethWearGrade2 => 'Desgaste leve';

  @override
  String get teethWearGrade3 => 'Rasamiento o desgaste claro de la superficie';

  @override
  String get teethWearGrade4 => 'Nivelamiento / diente más plano';

  @override
  String get teethWearGrade5 => 'Acortamiento avanzado';

  @override
  String get dentalEvaluationDateShort => 'Fecha evaluación dental';

  @override
  String get dentitionOptionalSection => 'Dentición (opcional)';

  @override
  String get dentitionCompleteAllOrNone =>
      'Si usa dentición, complete los cinco valores y la fecha de evaluación.';

  @override
  String get dentitionWearCannotBeNaWhenMilkTeethPositive =>
      'Si hay dientes de leche, el desgaste no puede ser «No aplica» (grado 0). Elija un grado del 1 al 5.';

  @override
  String get dentitionWearCannotBeNaWhenPermanentTeethPositive =>
      'Si hay dientes permanentes, el desgaste no puede ser «No aplica» (grado 0). Elija un grado del 1 al 5.';

  @override
  String get dentitionWearGradeInvalidForTeethCounts =>
      'Para esa cantidad de dientes de leche y permanentes, el grado de desgaste elegido no corresponde a la tabla SAPA (2014). Ajuste los conteos o los grados.';

  @override
  String get newFeedStartDate => 'Inicio nueva alimentación';

  @override
  String get averageDailyGain => 'Ganancia diaria prom.';

  @override
  String get tracker => 'Tracker';

  @override
  String get comments => 'Comentarios';

  @override
  String get receivedAt => 'Recibido en';

  @override
  String get purchaseCommission => 'Comisión';

  @override
  String get purchasePrice => 'Precio Compra';

  @override
  String get purchaseWeightKg => 'Peso Compra';

  @override
  String get receivedWeightKg => 'Peso Recibido';

  @override
  String get saleWeightKg => 'Peso Venta';

  @override
  String get salePrice => 'Precio Venta';

  @override
  String get weightHistory => 'Hist. Peso';

  @override
  String get medicationHistory => 'Hist. Medicamentos';

  @override
  String get count => 'Cant.';

  @override
  String countSomething(Object object) {
    return 'Cant. de $object';
  }

  @override
  String countAdjetive(Object adjetive) {
    return 'Cant. $adjetive';
  }

  @override
  String get price => 'Precio';

  @override
  String get weightKg => 'Peso (kg)';

  @override
  String get totalWeightKg => 'Peso Total (kg)';

  @override
  String get avgWeightKg => 'Peso Prom. (kg)';

  @override
  String get pricePerKg => 'Precio por Kilo';

  @override
  String get totalPrice => 'Precio Total';

  @override
  String get pricePerHead => 'Precio Prom. por Res';

  @override
  String get minWeightKg => 'Peso Mín. (Kg)';

  @override
  String get sale_minWeight_changeTitle => '¿Actualizar peso mínimo?';

  @override
  String sale_minWeight_changeMessage(
    String buyerName,
    String current,
    String buyerDefault,
  ) {
    return 'Cambió el comprador a $buyerName. Peso mínimo actual: $current kg. Peso mínimo del comprador: $buyerDefault kg.';
  }

  @override
  String sale_minWeight_useBuyerDefault(String weight) {
    return 'Usar peso del comprador ($weight kg)';
  }

  @override
  String sale_minWeight_keepCurrent(String weight) {
    return 'Mantener actual ($weight kg)';
  }

  @override
  String get sale_minWeight_reclassifyTitle =>
      '¿Reclasificar reses según el nuevo peso mínimo?';

  @override
  String sale_minWeight_reclassifyMessage(
    String previous,
    String newMin,
    int approvedCount,
    int rejectedCount,
  ) {
    return 'El peso mínimo cambió de $previous kg a $newMin kg. Hay $approvedCount aprobadas y $rejectedCount rechazadas. ¿Desea reclasificarlas automáticamente según el nuevo mínimo?';
  }

  @override
  String get sale_minWeight_reclassifyYes => 'Sí, reclasificar';

  @override
  String get sale_minWeight_reclassifyNo => 'No, mantener clasificación';

  @override
  String get purchasedAvgWeight => 'Peso Prom. Comprado (kg)';

  @override
  String get receivedAvgWeight => 'Peso Prom. Recibido (kg)';

  @override
  String get unassignedCattle => 'Reses sin lote identificado';

  @override
  String get lotNumber => 'Número de lote';

  @override
  String get origin => 'Procedencia';

  @override
  String get total => 'Total';

  @override
  String get average => 'Promedio';

  @override
  String get nit => 'NIT';

  @override
  String get dosage => 'Dosis';

  @override
  String get route => 'Vía aplicación';

  @override
  String get medicationLot => 'Lote de fabricación';

  @override
  String get appliedBy => 'Aplicado por';

  @override
  String get recordedBy => 'Registrado por';

  @override
  String get medication => 'Medicación';

  @override
  String get selectBrand => 'Seleccione una marca';

  @override
  String get createNewBrand => 'Crear nueva marca';

  @override
  String get createNewBrandTitle => 'Crear Nueva Brand';

  @override
  String get selectImage => 'Seleccionar imagen';

  @override
  String get imageRequired => 'La imagen es obligatoria';

  @override
  String get eventConfigTitle => 'Configuración de Eventos';

  @override
  String get noAnimals => 'Aún no se han agregado animales';

  @override
  String get purchaseReceptionTitle => 'Recepción de compra';

  @override
  String get purchaseBatchesTitle => 'Lotes de la compra';

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
  String get receivedOk => 'Res recibida';

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
  String get isCastrated => 'Está castrado';

  @override
  String get receiveCattle => 'Recibir res';

  @override
  String get eventsApplied => 'Eventos Aplicados';

  @override
  String get noEventsApplied => 'Sin eventos aplicados';

  @override
  String get receivedCount => 'Recibidos';

  @override
  String get purchasedCount => 'Comprados';

  @override
  String get sales_searchPlaceholder => 'Buscar ventas...';

  @override
  String get sales_dateRange => 'Rango de Fechas';

  @override
  String get sales_createFirstSale => 'Crea tu primera venta para comenzar';

  @override
  String get purchases_createFirstPurchase =>
      'Crea tu primera compra para comenzar';

  @override
  String get sales_amount => 'Monto';

  @override
  String get sales_viewDetails => 'Ver Detalles';

  @override
  String get sales_showing => 'Mostrando';

  @override
  String get sales_saleDetails => 'Detalles de Venta';

  @override
  String get sales_transactionDate => 'Fecha de Transacción';

  @override
  String get sales_totalAmount => 'Monto Total';

  @override
  String get sales_cattleList => 'Lista de Ganado';

  @override
  String get sales_noDetails => 'No hay detalles disponibles.';

  @override
  String get sales_errorLoading => 'Error al cargar ventas';

  @override
  String get provider_selectOrCreate => 'Seleccionar o crear proveedor';

  @override
  String get provider_searchByName => 'Buscar por nombre...';

  @override
  String provider_providerName(Object providerTypeLabel) {
    return 'Nombre $providerTypeLabel';
  }

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
  String get cattle_weightUnderMin => 'Peso Debajo del Mínimo';

  @override
  String cattle_weightUnderMinMessage(Object measured, Object min) {
    return 'El peso medido ($measured kg) está por debajo del peso mínimo ($min kg). Este ganado recibirá el peso mínimo para el cálculo de precio.';
  }

  @override
  String get cattle_approveQuestion => '¿Desea aprobar o rechazar este ganado?';

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
  String get sale_editTitle => 'Editar venta';

  @override
  String get sale_editSuccess => 'Venta actualizada exitosamente';

  @override
  String get sale_editLoadError => 'No se pudo cargar la venta para editar';

  @override
  String get sale_editSaveError => 'Error al guardar los cambios de la venta';

  @override
  String get sale_editSaving => 'Guardando cambios...';

  @override
  String get sale_saveChanges => 'Guardar cambios';

  @override
  String get sale_confirm_edit_title => 'Confirmar edición de venta';

  @override
  String get sale_confirm_edit_proceed => 'Confirmar y guardar';

  @override
  String get user_editUserPageMessage =>
      'Esta funcionalidad está en desarrollo';

  @override
  String get saleSavedSuccess => 'Venta guardada exitosamente';

  @override
  String get cattleFoundPending =>
      'Ganado encontrado (Implementación pendiente)';

  @override
  String get scanEnterNumber => 'Escanear/Ingresar Número';

  @override
  String get salesDashboard => 'Tablero de Ventas';

  @override
  String get noOfflineSales =>
      'No hay ventas fuera de línea pendientes de sincronización.';

  @override
  String saleWithDate(Object date) {
    return 'Venta $date';
  }

  @override
  String totalWithAmount(Object amount) {
    return 'Total: $amount';
  }

  @override
  String get label_measuredWeight => 'Peso Medido';

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
  String get masterListTitle => 'Lista Maestra de Ganado';

  @override
  String get invalidEmail => 'Correo electrónico inválido';

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
  String get noUsersFound => 'No se encontraron usuarios';

  @override
  String get error_eartagExist => 'Número de Eartag ya existe para otra res.';

  @override
  String get purchase_dateRequired => 'Debes seleccionar una fecha de compra.';

  @override
  String get purchase_saveSuccess => 'Compra guardada exitosamente.';

  @override
  String get purchase_saveError => 'Falló el guardado de compra.';

  @override
  String get purchase_editTitle => 'Editar compra';

  @override
  String get purchase_editSuccess => 'Compra actualizada correctamente.';

  @override
  String get purchase_editLoadError =>
      'No se pudo cargar la compra para editar.';

  @override
  String get purchase_editSaveError => 'No se pudo guardar la compra.';

  @override
  String get purchase_editForbiddenReceived =>
      'No se puede editar una compra ya recibida.';

  @override
  String get purchase_editForbiddenReceptionStarted =>
      'No se puede editar: la recepción ya comenzó.';

  @override
  String get reception_cattleEditSuccess => 'Datos de la res actualizados.';

  @override
  String get cp_error_noLots => 'Debe agregar al menos un lote';

  @override
  String get cp_error_providerRequired =>
      'Por favor seleccione o cree un proveedor.';

  @override
  String get purchase_totalCattle => 'Reses totales';

  @override
  String get noPurchasesFound => 'Compra no encontrada';

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
  String get error_massiveEventClosePurchaseReception =>
      'Este evento masivo está vinculado a una recepción de compra y no puede cerrarse desde el módulo de eventos masivos.';

  @override
  String get event_finishSuccess =>
      'El evento masivo se finalizó correctamente.';

  @override
  String get cattle_exists_error => 'El número ya existe (Activa/Perdida)';

  @override
  String get eartag_exists_error => 'El arete ya existe (Activa/Perdida)';

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
  String get locations_map_loadError =>
      'No se pudo cargar el mapa de ubicaciones.';

  @override
  String get locations_map_empty => 'No hay ubicaciones disponibles.';

  @override
  String get locations_map_lastLocationTitle => 'Última ubicación';

  @override
  String locations_map_cattleCount(Object count) {
    return 'Mostrando $count reses';
  }

  @override
  String get locations_map_osmAttribution => '© OpenStreetMap contributors';

  @override
  String get deviceRemoteConfig_title => 'Configuración remota';

  @override
  String deviceRemoteConfig_titleWithName(Object name) {
    return 'Configuración: $name';
  }

  @override
  String get deviceRemoteConfig_statusTitle => 'Estado de configuración';

  @override
  String get deviceRemoteConfig_synced => 'Sincronizado';

  @override
  String deviceRemoteConfig_waitingConfirmation(
    Object desired,
    Object confirmed,
  ) {
    return 'Esperando confirmación del collar (versión deseada $desired vs confirmada $confirmed)';
  }

  @override
  String deviceRemoteConfig_currentProfile(Object name) {
    return 'Perfil actual: $name';
  }

  @override
  String get deviceRemoteConfig_noProfileApplied => 'Sin perfil aplicado';

  @override
  String deviceRemoteConfig_divergentParams(Object params) {
    return 'Parámetros desincronizados: $params';
  }

  @override
  String get deviceRemoteConfig_actions_historyTitle => 'Historial de comandos';

  @override
  String get deviceRemoteConfig_action_applyProfile => 'Aplicar perfil';

  @override
  String get deviceRemoteConfig_action_requestPositionNow =>
      'Pedir posición ahora';

  @override
  String get deviceRemoteConfig_action_requestBattery => 'Pedir batería';

  @override
  String get deviceRemoteConfig_action_clearManDown => 'Limpiar man-down';

  @override
  String get deviceRemoteConfig_action_lorawanOnly =>
      'Solo LoRaWAN (apaga GPS/WiFi/BT)';

  @override
  String get deviceRemoteConfig_lorawanOnly_dialog_title =>
      '¿Usar solo LoRaWAN para posición?';

  @override
  String get deviceRemoteConfig_lorawanOnly_dialog_body =>
      'El collar dejará de intentar fixes con GPS, WiFi y Bluetooth. La posición la calculará el servidor LoRaWAN (TDOA/RSSI). Ahorra mucha batería pero la precisión depende de la cobertura de gateways.';

  @override
  String get deviceRemoteConfig_lorawanOnly_dialog_cancel => 'Cancelar';

  @override
  String get deviceRemoteConfig_lorawanOnly_dialog_confirm => 'Aplicar';

  @override
  String get deviceRemoteConfig_snackbar_lorawanOnlySent =>
      'Configuración «Solo LoRaWAN» enviada al collar.';

  @override
  String get deviceRemoteConfig_snackbar_profileApplied =>
      'Perfil aplicado. Esperando confirmación del collar.';

  @override
  String get deviceRemoteConfig_snackbar_positionRequested =>
      'Posición solicitada al collar.';

  @override
  String get deviceRemoteConfig_snackbar_batteryRequested =>
      'Reporte de batería solicitado.';

  @override
  String get deviceRemoteConfig_snackbar_manDownCleared =>
      'Estado man-down limpiado.';

  @override
  String get deviceRemoteConfig_snackbar_readRequested =>
      'Solicitud de lectura enviada. Aparecerá en el próximo uplink.';

  @override
  String get deviceRemoteConfig_action_readAllSafeParameters =>
      'Leer todos los parámetros (seguros)';

  @override
  String deviceRemoteConfig_snackbar_readAllSent(Object chunks, Object total) {
    return 'Se enviaron $chunks tramas de lectura ($total parámetros). Los valores llegarán en uplinks.';
  }

  @override
  String get deviceRemoteConfig_readSafeChunks_sectionTitle =>
      'Lectura por bloques (no sensibles)';

  @override
  String get deviceRemoteConfig_readSafeChunks_loading => 'Cargando bloques…';

  @override
  String get deviceRemoteConfig_readSafeChunks_unavailable =>
      'No se pudo cargar el plan de bloques. Reinicia el backend si acabas de actualizar.';

  @override
  String get deviceRemoteConfig_readSafeChunks_retry => 'Reintentar';

  @override
  String deviceRemoteConfig_action_readSafeChunkShort(
    Object blockNumber,
    Object totalBlocks,
  ) {
    return 'Bloque $blockNumber/$totalBlocks';
  }

  @override
  String deviceRemoteConfig_snackbar_readChunkSent(
    Object blockNumber,
    Object totalBlocks,
    Object paramCount,
  ) {
    return 'Bloque $blockNumber de $totalBlocks encolado ($paramCount parámetros). Los valores llegarán en uplinks.';
  }

  @override
  String get deviceRemoteConfig_currentValuesTitle =>
      'Valores actuales del dispositivo';

  @override
  String get deviceRemoteConfig_currentValues_neverRead =>
      'Sin lecturas confirmadas todavía. Desde la tarjeta de acciones puedes solicitar lecturas por bloque o todas a la vez.';

  @override
  String deviceRemoteConfig_currentValues_lastReadAt(Object when) {
    return 'Última lectura confirmada: $when';
  }

  @override
  String get deviceRemoteConfig_currentValues_searchHint => 'Buscar parámetro…';

  @override
  String get deviceRemoteConfig_currentValues_noMatches =>
      'Ningún parámetro coincide con la búsqueda.';

  @override
  String get deviceRemoteConfig_currentValues_emptyHint =>
      'Aún no se han leído parámetros del collar. Usa los botones «Bloque …» o «Leer todos los parámetros (seguros)» y los valores se llenarán a medida que lleguen los uplinks.';

  @override
  String get deviceRemoteConfig_currentValues_colParameter => 'Parámetro';

  @override
  String get deviceRemoteConfig_currentValues_colConfirmed =>
      'Valor confirmado';

  @override
  String get deviceRemoteConfig_currentValues_colDesired => 'Valor deseado';

  @override
  String get deviceRemoteConfig_currentValues_colState => 'Estado';

  @override
  String get deviceRemoteConfig_currentValues_state_ok => 'OK';

  @override
  String get deviceRemoteConfig_currentValues_state_divergent => 'Divergente';

  @override
  String get deviceRemoteConfig_currentValues_state_pending => 'Sin lectura';

  @override
  String get deviceRemoteConfig_currentValues_state_readonly => 'Solo lectura';

  @override
  String get deviceRemoteConfig_snackbar_configureSent =>
      'Parámetros enviados. Esperando confirmación.';

  @override
  String get deviceRemoteConfig_dialog_applyProfileTitle =>
      'Aplicar perfil de configuración';

  @override
  String get deviceRemoteConfig_dialog_noProfiles =>
      'No hay perfiles disponibles para este tenant.';

  @override
  String get deviceRemoteConfig_profile_systemBadge => 'sistema';

  @override
  String get deviceRemoteConfig_history_empty =>
      'Aún no hay comandos enviados a este collar.';

  @override
  String deviceRemoteConfig_history_statusLabel(Object status) {
    return 'Estado: $status';
  }

  @override
  String deviceRemoteConfig_history_errorLabel(Object error) {
    return 'Error: $error';
  }

  @override
  String deviceRemoteConfig_history_fportLabel(Object port) {
    return 'fPort $port';
  }

  @override
  String get deviceRemoteConfig_diagnostic_title => 'Modo diagnóstico';

  @override
  String get deviceRemoteConfig_diagnostic_description =>
      'Silencia temporalmente shock, man-down y tamper, y baja el heartbeat al mínimo (300 s) para inspeccionar el collar en ChirpStack. Se restaura solo al expirar.';

  @override
  String get deviceRemoteConfig_diagnostic_inactiveStatus =>
      'Inactivo. El collar opera con sus parámetros normales.';

  @override
  String deviceRemoteConfig_diagnostic_activeStatus(Object remaining) {
    return 'Activo. Restauración automática en $remaining.';
  }

  @override
  String get deviceRemoteConfig_diagnostic_action_enable =>
      'Activar modo diagnóstico';

  @override
  String get deviceRemoteConfig_diagnostic_action_disable =>
      'Desactivar y restaurar';

  @override
  String deviceRemoteConfig_diagnostic_remainingMinutesSeconds(
    Object minutes,
    Object seconds,
  ) {
    return '$minutes min $seconds s';
  }

  @override
  String get deviceRemoteConfig_snackbar_diagnosticEnabled =>
      'Modo diagnóstico activado. Se restaurará automáticamente al expirar.';

  @override
  String get deviceRemoteConfig_snackbar_diagnosticDisabled =>
      'Modo diagnóstico desactivado. Restaurando los parámetros previos.';

  @override
  String get openRemoteConfigTooltip => 'Abrir configuración remota del collar';

  @override
  String trackerSearch_minCharsHint(int count) {
    return 'Mínimo $count caracteres…';
  }

  @override
  String get cattleGrid_savedSuccess => 'Cambios guardados';

  @override
  String get cattleGrid_trackerRemoved => 'Tracker eliminado';

  @override
  String get cattleGrid_rowNotFound => 'No se encontró la fila';

  @override
  String get equipmentAndResource_title => 'Equipos y recursos';

  @override
  String get devicesList_pageTitle => 'Dispositivos';

  @override
  String get devicesList_searchHint => 'Buscar por nombre o DevEUI';

  @override
  String devicesList_countLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dispositivos',
      one: '1 dispositivo',
      zero: 'Sin dispositivos',
    );
    return '$_temp0';
  }

  @override
  String get devicesList_emptyTitle => 'Aún no hay dispositivos';

  @override
  String get devicesList_emptyMessage =>
      'Los dispositivos LoRaWAN registrados aparecerán aquí.';

  @override
  String get devicesList_errorGeneric =>
      'No se pudieron cargar los dispositivos. Inténtelo de nuevo.';

  @override
  String get devicesList_forbidden => 'No tiene permiso para ver dispositivos.';

  @override
  String get devicesList_retry => 'Reintentar';

  @override
  String get devicesList_columnName => 'Nombre';

  @override
  String get devicesList_columnDeveui => 'DevEUI';

  @override
  String get devicesList_columnActive => 'Estado';

  @override
  String get devicesList_columnBattery => 'Batería';

  @override
  String get devicesList_columnProfile => 'Perfil';

  @override
  String get devicesList_active => 'Activo';

  @override
  String get devicesList_inactive => 'Inactivo';

  @override
  String get devicesList_noBatteryData => 'Sin dato';

  @override
  String get devicesList_importButton => 'Importar';

  @override
  String get importLw001_pageTitle => 'Importar dispositivos LW001-BG PRO';

  @override
  String get importLw001_helpIntro =>
      'Suba una hoja con exactamente estas cabeceras en la fila 1, columnas A a D, en este orden:';

  @override
  String get importLw001_helpHeadersList =>
      '1. devEui (obligatorio por fila)\n2. idDeviceProfile\n3. joineui\n4. appKey';

  @override
  String get importLw001_helpOptionalCells =>
      'Si falta un valor en idDeviceProfile, joineui o appKey, se toma del perfil de dispositivo resuelto (por defecto abajo o el UUID de la columna B). Solo devEui es obligatorio en cada fila.';

  @override
  String get importLw001_helpMultiSheet =>
      'En archivos .xlsx o .xls con varias hojas, se importan todas las que tengan datos (la fila 1 de cada hoja debe ser la cabecera indicada arriba). Las hojas vacías se omiten.';

  @override
  String get importLw001_selectFile =>
      'Seleccionar archivo (.xlsx, .xls, .csv)';

  @override
  String get importLw001_defaultProfile => 'Perfil de dispositivo por defecto';

  @override
  String get importLw001_submit => 'Importar';

  @override
  String get importLw001_summaryTitle => 'Resumen de importación';

  @override
  String importLw001_summaryTotalRows(int count) {
    return 'Filas procesadas: $count';
  }

  @override
  String importLw001_summaryCreated(int count) {
    return 'Creados: $count';
  }

  @override
  String importLw001_summaryUpdated(int count) {
    return 'Actualizados: $count';
  }

  @override
  String importLw001_summaryDuplicates(String list) {
    return 'DevEUI repetidos en archivo: $list';
  }

  @override
  String importLw001_rowIssue(int row, String message) {
    return 'Fila $row: $message';
  }

  @override
  String get importLw001_backToList => 'Volver al listado';

  @override
  String get importLw001_profileRequired =>
      'Seleccione un perfil por defecto cuando alguna fila pueda tener idDeviceProfile vacío.';

  @override
  String get importLw001_fileRequired => 'Seleccione un archivo para importar.';

  @override
  String get importLw001_reason_IMPORT_HEADERS_INVALID =>
      'La fila de cabeceras no es válida. La fila 1 debe ser exactamente: devEui, idDeviceProfile, joineui, appKey.';

  @override
  String get importLw001_reason_DEVEUI_INVALID_LENGTH =>
      'El DevEUI debe tener exactamente 16 caracteres hexadecimales.';

  @override
  String get importLw001_reason_DEVEUI_DUPLICATE_IN_FILE_UPDATED =>
      'El DevEUI se repitió en el archivo; se actualizó el dispositivo.';

  @override
  String get importLw001_reason_DEVEUI_ALREADY_EXISTS_UPDATED =>
      'El DevEUI ya existía en su tenant; se actualizó el dispositivo.';

  @override
  String get importLw001_reason_DEVICE_PROFILE_ID_REQUIRED =>
      'Se requiere un perfil por defecto en el formulario.';

  @override
  String get importLw001_reason_DEVICE_PROFILE_ID_INVALID =>
      'El perfil de dispositivo no existe o no es válido para este tenant.';

  @override
  String get importLw001_reason_CHIRPSTACK_PROFILE_ID_REQUIRED =>
      'El perfil no tiene ID de perfil en ChirpStack (idChipstack). Configúrelo antes de importar.';

  @override
  String get importLw001_reason_JOINEUI_INVALID =>
      'JoinEUI debe ser 16 caracteres hexadecimales.';

  @override
  String get importLw001_reason_APP_KEY_INVALID =>
      'App Key debe ser 32 caracteres hexadecimales.';

  @override
  String get importLw001_reason_APP_KEY_SCIENTIFIC_NOTATION =>
      'App Key parece notación científica de Excel; formatee la celda como texto.';

  @override
  String get importLw001_reason_NWK_KEY_INVALID =>
      'La clave de red del perfil no es válida.';

  @override
  String get importLw001_reason_UNSUPPORTED_FILE_FORMAT =>
      'Formato de archivo no soportado.';

  @override
  String get importLw001_reason_FILE_EMPTY =>
      'El archivo no tiene filas de datos.';

  @override
  String get importLw001_reason_ROW_PROCESS_FAILED =>
      'No se pudo procesar esta fila.';

  @override
  String importLw001_reason_unknown(String code) {
    return 'Error de importación ($code).';
  }
}
