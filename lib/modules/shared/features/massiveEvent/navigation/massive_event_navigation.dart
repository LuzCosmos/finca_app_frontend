import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/page/massive_event_page.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/bloc/massive_event_bloc.dart';

// 👇 Condicionales
import 'massive_event_navigation_stub.dart'
    if (dart.library.io) 'massive_event_navigation_mobile.dart'
    if (dart.library.html) 'massive_event_navigation_web.dart';

void openMassiveEventPage(BuildContext context) {
  final dataSource = createMassiveEventDataSource();

  Navigator.push(
    context,
    MaterialPageRoute(
      builder:
          (_) => BlocProvider(
            create: (_) => MassiveEventBloc(dataSource: dataSource),
            child: const MassiveEventPage(),
          ),
    ),
  );
}
