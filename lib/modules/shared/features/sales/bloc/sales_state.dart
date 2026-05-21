import 'package:equatable/equatable.dart';

abstract class SalesState extends Equatable {
  const SalesState();
  
  @override
  List<Object?> get props => [];
}

class SalesInitial extends SalesState {}

class SalesLoading extends SalesState {}

class SalesReady extends SalesState {
  final List<dynamic> buyers;
  final List<dynamic> transporters;
  
  const SalesReady({
    this.buyers = const [],
    this.transporters = const [],
  });
  
  @override
  List<Object?> get props => [buyers, transporters];
}

class CattleSearchSuccess extends SalesState {
  final dynamic cattle;
  const CattleSearchSuccess(this.cattle);
  @override
  List<Object?> get props => [cattle];
}

class SalesError extends SalesState {
  final String message;
  const SalesError(this.message);
  @override
  List<Object?> get props => [message];
}

class SaleSavedSuccess extends SalesState {}
