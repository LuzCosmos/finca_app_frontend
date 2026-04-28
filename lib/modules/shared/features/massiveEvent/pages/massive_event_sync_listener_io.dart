import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finca_app_frontend/modules/mobile/bloc/sync_bloc.dart';
import 'package:finca_app_frontend/modules/mobile/bloc/sync_state.dart';

Widget wrapMassiveEventPageSyncListener({
  required Widget child,
  required void Function() onSyncSuccess,
}) {
  return BlocListener<SyncBloc, SyncState>(
    listener: (context, state) {
      if (state is SyncSuccess) {
        onSyncSuccess();
      }
    },
    child: child,
  );
}
