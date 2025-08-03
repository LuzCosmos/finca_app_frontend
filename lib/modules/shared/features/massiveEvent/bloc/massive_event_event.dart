import 'package:equatable/equatable.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';

abstract class MassiveEventEvent extends Equatable {
  const MassiveEventEvent();

  @override
  List<Object?> get props => [];
}

class AddSimpleEvent extends MassiveEventEvent {
  final SimpleEventModel simpleEvent;
  final String idTenant;

  const AddSimpleEvent({required this.simpleEvent, required this.idTenant});

  @override
  List<Object?> get props => [simpleEvent, idTenant];
}

class AddMassiveEventWithConfig extends MassiveEventEvent {
  final MassiveEventModel massiveEvent;
  final String idTenant;

  const AddMassiveEventWithConfig({
    required this.massiveEvent,
    required this.idTenant,
  });

  @override
  List<Object?> get props => [massiveEvent, idTenant];
}
