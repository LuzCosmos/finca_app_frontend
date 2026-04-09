import 'package:flutter/material.dart';

import 'mobile_sync_provider_stub.dart'
    if (dart.library.io) 'mobile_sync_provider_io.dart' as impl;

Widget wrapMobileSyncScope(Widget child) => impl.wrapMobileSyncScope(child);
