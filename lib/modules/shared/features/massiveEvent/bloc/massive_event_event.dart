import 'package:equatable/equatable.dart';
import '../models/simple_event_config.dart';

abstract class MassiveEventEvent extends Equatable {
  const MassiveEventEvent();

  @override
  List<Object?> get props => [];
}

class AddSimpleEventConfig extends MassiveEventEvent {
  final SimpleEventConfig config;
  final String massiveEventId;
  final String idTenant;

  const AddSimpleEventConfig({
    required this.config,
    required this.massiveEventId,
    required this.idTenant,
  });

  @override
  List<Object?> get props => [config, massiveEventId, idTenant];
}
