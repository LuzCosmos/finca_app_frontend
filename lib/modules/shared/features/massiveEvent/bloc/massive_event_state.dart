import 'package:equatable/equatable.dart';
import '../models/simple_event_config.dart';

abstract class MassiveEventState extends Equatable {
  const MassiveEventState();

  @override
  List<Object?> get props => [];
}

class MassiveEventInitial extends MassiveEventState {}

class MassiveEventLoading extends MassiveEventState {}

class MassiveEventSuccess extends MassiveEventState {
  final String messageKey;
  final List<SimpleEventConfig> configs;

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
