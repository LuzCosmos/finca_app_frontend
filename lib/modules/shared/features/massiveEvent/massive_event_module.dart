import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Tu bloc y página
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/bloc/massive_event_bloc.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/page/massive_event_page.dart';

// Interfaz de data source
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/data/simple_event_data_source.dart';

// Conditional imports para data source específico de plataforma
import './data/massive_event_data_source_stub.dart'
    if (dart.library.io) 'package:finca_app_frontend/modules/mobile/data/massive_event/massive_event_data_source_mobile.dart'
    if (dart.library.html) 'package:finca_app_frontend/modules/web/data/massive_event/massive_event_data_source_web.dart';

/// Construye la página MassiveEvent completa con Bloc y data source
Widget buildMassiveEventPage() {
  final dataSource = createMassiveEventDataSource();
  return BlocProvider(
    create: (_) => MassiveEventBloc(dataSource: dataSource),
    child: const MassiveEventPage(),
  );
}
