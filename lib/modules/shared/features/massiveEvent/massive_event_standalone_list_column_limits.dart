/// Anchos máximos (lógicos) para columnas / textos del listado autónomo de eventos masivos
/// (fecha del evento, estado, usuario creador, fechas con hora). Web y móvil.
abstract final class MassiveEventStandaloneListColumnLimits {
  static const double eventDateMax = 120;
  static const double statusMax = 112;
  static const double createdByUsernameMax = 180;
  static const double dateTimeMax = 176;

  /// Líneas móvil (etiqueta + valor): ancho máximo del texto.
  static const double mobileEventDateLineMax = 220;
  static const double mobileCreatedByLineMax = 260;
  static const double mobileDateTimeLineMax = 240;
  static const double mobileTitleMax = 280;

  static const double webNameColumnMin = 88;

  /// Ancho fijo (lógico) de la columna «Editar» (índice 6) en web: no escala con el panel.
  /// Debe cubrir el mínimo interactivo del [IconButton].
  static const double webActionsColumnFixedWidth = 48;

  /// [DataTable] coloca tras el `label` de cabeceras ordenables un [_SortArrow] (16px)
  /// más [_sortArrowPadding] (2px) — ver `material/data_table.dart`. Nuestros [cw]
  /// solo acotan el texto; sin sumar esto, `contentTotalW` subestima el intrínseco
  /// real, `tableWidth` puede quedar en `availOuter` por debajo de lo necesario y
  /// el `Card` recorta la fila (desaparece el botón de editar a la derecha).
  static const double webDataTableSortHeaderTrailing = 18;

  /// Columnas con `onSort` en la tabla web de eventos masivos (índices 0,1,2,4,5).
  static const int webMassiveEventListWebSortableHeaderCount = 5;

  static double webMassiveEventListWebSortHeaderOverhead(int columnCount) {
    if (columnCount < 6) return 0;
    return webMassiveEventListWebSortableHeaderCount *
        webDataTableSortHeaderTrailing;
  }

  /// Fija [cw[6]] a [webActionsColumnFixedWidth] y compensa en **nombre** (1) para no
  /// desalinear la suma con [usableCols]; si no hay margen en el nombre, la suma puede
  /// crecer (scroll horizontal) en lugar de recortar el botón.
  static List<double> lockWebActionsColumnWidth(List<double> cw) {
    if (cw.length <= 6) return cw;
    final out = List<double>.from(cw);
    if (out[6] == webActionsColumnFixedWidth) return out;
    final delta = webActionsColumnFixedWidth - out[6];
    out[6] = webActionsColumnFixedWidth;
    out[1] = (out[1] - delta).clamp(webNameColumnMin, double.infinity);
    return out;
  }

  /// Tras [capWebColumnWidths], asigna a la columna **nombre** (índice 1) todo el
  /// [usableCols] que no usen las demás columnas (solo el nombre crece al ampliar el panel).
  static List<double> expandWebNameColumnOnly(
    List<double> cw,
    double usableCols, {
    required int columnCount,
  }) {
    if (cw.length < 2) return cw;
    final out = List<double>.from(cw);
    var sumOthers = 0.0;
    for (var i = 0; i < out.length; i++) {
      if (i != 1) sumOthers += out[i];
    }
    final forName = usableCols - sumOthers;
    out[1] = forName > webNameColumnMin ? forName : webNameColumnMin;
    return out;
  }

  /// Aplica [eventDateMax], [statusMax], [createdByUsernameMax], [dateTimeMax] a índices
  /// 0, 2, 3, 4, 5 de [cw] (tabla web: nombre del evento en 1 y acciones en 6 sin tocar).
  static List<double> capWebColumnWidths(List<double> cw) {
    if (cw.isEmpty) return cw;
    final out = List<double>.from(cw);
    void cap(int i, double m) {
      if (i < out.length && out[i] > m) out[i] = m;
    }
    cap(0, eventDateMax);
    cap(2, statusMax);
    cap(3, createdByUsernameMax);
    cap(4, dateTimeMax);
    cap(5, dateTimeMax);
    return out;
  }

  /// Anchos ideales web al forzar scroll horizontal (no superan los máximos).
  static List<double> webIdealColumnWidths(int columnCount) {
    final base =
        columnCount >= 7
            ? <double>[80, 220, 92, 100, 136, 136, webActionsColumnFixedWidth]
            : <double>[80, 220, 92, 100, 136, 136];
    return capWebColumnWidths(base);
  }
}
