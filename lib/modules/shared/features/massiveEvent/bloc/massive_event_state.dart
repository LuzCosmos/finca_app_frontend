import 'package:equatable/equatable.dart';
import 'package:finca_app_frontend/modules/shared/features/brands/models/brand_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/animal_simple_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';

abstract class MassiveEventState extends Equatable {
  const MassiveEventState();
  @override
  List<Object?> get props => [];
}

class MassiveEventInitial extends MassiveEventState {}

class MassiveEventLoading extends MassiveEventState {}

class MassiveEventSuccess extends MassiveEventState {
  final String messageKey;
  final List<SimpleEventModel> configs;

  const MassiveEventSuccess({required this.messageKey, required this.configs});

  @override
  List<Object?> get props => [messageKey, configs];
}

class MassiveEventError extends MassiveEventState {
  final String messageKey;
  final String? debugInfo;

  const MassiveEventError({required this.messageKey, this.debugInfo});

  @override
  List<Object?> get props => [messageKey, debugInfo];
}

class BrandCreatedSuccess extends MassiveEventState {
  final BrandModel brand;

  BrandCreatedSuccess({required this.brand});
}

class AnimalSimpleEventsAdded extends MassiveEventState {
  final List<AnimalSimpleEventModel> animalSimpleEvents;

  const AnimalSimpleEventsAdded({required this.animalSimpleEvents});

  @override
  List<Object?> get props => [animalSimpleEvents];
}

class MassiveEventClosed extends MassiveEventState {
  final String idMassiveEvent;

  const MassiveEventClosed({required this.idMassiveEvent});

  @override
  List<Object?> get props => [idMassiveEvent];
}
