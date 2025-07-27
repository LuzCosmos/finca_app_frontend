import 'package:equatable/equatable.dart';

abstract class SyncEvent extends Equatable {
  const SyncEvent();

  @override
  List<Object?> get props => [];
}

class StartSync extends SyncEvent {
  final String idTenant;
  const StartSync(this.idTenant);

  @override
  List<Object?> get props => [idTenant];
}
