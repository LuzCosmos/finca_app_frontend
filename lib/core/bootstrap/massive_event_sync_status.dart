import 'massive_event_sync_status_stub.dart'
    if (dart.library.io) 'massive_event_sync_status_io.dart' as impl;

Future<bool> isMassiveEventPendingSync(String id) =>
    impl.isMassiveEventPendingSync(id);
