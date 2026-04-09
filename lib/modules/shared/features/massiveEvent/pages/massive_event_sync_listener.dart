import 'package:flutter/material.dart';

import 'massive_event_sync_listener_stub.dart'
    if (dart.library.io) 'massive_event_sync_listener_io.dart' as _impl;

Widget wrapMassiveEventPageSyncListener({
  required Widget child,
  required void Function() onSyncSuccess,
}) =>
    _impl.wrapMassiveEventPageSyncListener(
      child: child,
      onSyncSuccess: onSyncSuccess,
    );
