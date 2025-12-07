import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/data/sales_data_source.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/models/sale_model.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/models/sales_query_models.dart';

// Events
abstract class SalesWebEvent extends Equatable {
  const SalesWebEvent();
  @override
  List<Object?> get props => [];
}

class LoadSalesWeb extends SalesWebEvent {
  final SalesQuery? query;
  const LoadSalesWeb({this.query});
}

class UpdateSaleWeb extends SalesWebEvent {
  final String id;
  final Map<String, dynamic> updates;
  const UpdateSaleWeb({required this.id, required this.updates});
}

// State
enum SalesWebStatus { initial, loading, success, failure }

class SalesWebState extends Equatable {
  final SalesWebStatus status;
  final PaginatedSales? sales;
  final SalesQuery query;
  final String? error;

  const SalesWebState({
    this.status = SalesWebStatus.initial,
    this.sales,
    this.query = const SalesQuery_Defaults(), 
    this.error,
  });
  // Note: Const default constructor for SalesQuery
  
  SalesWebState copyWith({
    SalesWebStatus? status,
    PaginatedSales? sales,
    SalesQuery? query,
    String? error,
  }) {
    return SalesWebState(
      status: status ?? this.status,
      sales: sales ?? this.sales,
      query: query ?? this.query,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, sales, query, error];
}

class SalesQuery_Defaults extends SalesQuery {
  const SalesQuery_Defaults() : super();
}


// Bloc
class SalesWebBloc extends Bloc<SalesWebEvent, SalesWebState> {
  final ISalesDataSource dataSource;

  SalesWebBloc({required this.dataSource}) : super(const SalesWebState()) {
    on<LoadSalesWeb>(_onLoadSales);
    on<UpdateSaleWeb>(_onUpdateSale);
  }

  Future<void> _onLoadSales(LoadSalesWeb event, Emitter<SalesWebState> emit) async {
    emit(state.copyWith(status: SalesWebStatus.loading));
    try {
      final query = event.query ?? state.query;
      final result = await dataSource.getSales(query);
      emit(state.copyWith(
        status: SalesWebStatus.success,
        sales: result,
        query: query,
      ));
    } catch (e) {
      emit(state.copyWith(status: SalesWebStatus.failure, error: e.toString()));
    }
  }

  Future<void> _onUpdateSale(UpdateSaleWeb event, Emitter<SalesWebState> emit) async {
    // We don't set global loading, maybe just optimistic update or specific loading?
    // For simplicity, reload after update.
    emit(state.copyWith(status: SalesWebStatus.loading));
    try {
      await dataSource.updateSale(event.id, event.updates);
      add(const LoadSalesWeb()); // Reload list
    } catch (e) {
      emit(state.copyWith(status: SalesWebStatus.failure, error: "Update failed: $e"));
    }
  }
}
