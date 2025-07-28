import 'package:equatable/equatable.dart';
import '../models/simple_event_model.dart';

abstract class MassiveEventEvent extends Equatable {
  const MassiveEventEvent();

  @override
  List<Object?> get props => [];
}

class AddSimpleEvent extends MassiveEventEvent {
  final SimpleEventModel config;
  final String idMassiveEvent;
  final String idTenant;

  const AddSimpleEvent({
    required this.config,
    required this.idMassiveEvent,
    required this.idTenant,
  });

  @override
  List<Object?> get props => [config, idMassiveEvent, idTenant];
}
