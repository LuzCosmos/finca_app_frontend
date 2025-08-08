import 'package:equatable/equatable.dart';
import 'package:finca_app_frontend/modules/shared/features/brands/models/brand_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/animal_simple_event_model.dart';

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

class AddBrand extends MassiveEventEvent {
  final BrandModel brand;
  final String idTenant;

  const AddBrand({required this.brand, required this.idTenant});

  @override
  List<Object?> get props => [brand, idTenant];
}

class AddAnimalSimpleEvents extends MassiveEventEvent {
  final List<AnimalSimpleEventModel> animalSimpleEvents;
  final String cattleNumber;

  const AddAnimalSimpleEvents({
    required this.animalSimpleEvents,
    required this.cattleNumber,
  });

  @override
  List<Object?> get props => [animalSimpleEvents];
}
