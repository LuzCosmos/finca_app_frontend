import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finca_app_frontend/modules/mobile/bloc/sync_bloc.dart';

Widget wrapMobileSyncScope(
  Widget child, {
  SyncBloc? syncBlocOverride,
}) {
  if (syncBlocOverride != null) {
    return BlocProvider<SyncBloc>.value(
      value: syncBlocOverride,
      child: child,
    );
  }
  return child;
}
