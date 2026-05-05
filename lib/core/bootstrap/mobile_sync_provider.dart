import 'package:flutter/material.dart';
import 'package:finca_app_frontend/modules/mobile/bloc/sync_bloc_stub.dart'
    if (dart.library.io) 'package:finca_app_frontend/modules/mobile/bloc/sync_bloc.dart';

import 'mobile_sync_provider_stub.dart'
    if (dart.library.io) 'mobile_sync_provider_io.dart' as impl;

Widget wrapMobileSyncScope(
  Widget child, {
  SyncBloc? syncBlocOverride,
}) =>
    impl.wrapMobileSyncScope(child, syncBlocOverride: syncBlocOverride);
