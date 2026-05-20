import 'package:equatable/equatable.dart';
import '../models/sale_model.dart';

abstract class SalesEvent extends Equatable {
  const SalesEvent();

  @override
  List<Object?> get props => [];
}

class LoadSalesInitialData extends SalesEvent {}

class SearchCattleByNumber extends SalesEvent {
  final String number;
  const SearchCattleByNumber(this.number);
  @override
  List<Object?> get props => [number];
}

class SaveSaleTransaction extends SalesEvent {
  final SaleModel sale;
  const SaveSaleTransaction(this.sale);
  @override
  List<Object?> get props => [sale];
}
