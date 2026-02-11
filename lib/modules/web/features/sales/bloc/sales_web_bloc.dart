import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/data/sales_data_source.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/models/sale_model.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/models/sales_query_models.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';

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

class LoadProvidersEvent extends SalesWebEvent {
  const LoadProvidersEvent();
}

class CreateSaleEvent extends SalesWebEvent {
  final SaleModel sale;
  const CreateSaleEvent({required this.sale});
  @override
  List<Object?> get props => [sale];
}

class UpdateSaleWeb extends SalesWebEvent {
  final String id;
  final Map<String, dynamic> updates;
  const UpdateSaleWeb({required this.id, required this.updates});
}

// State
enum SalesWebStatus { initial, loading, success, failure, saleCreated }

class SalesWebState extends Equatable {
  final SalesWebStatus status;
  final PaginatedSales? sales;
  final SalesQuery query;
  final String? error;
  final List<Map<String, dynamic>>? providers;

  const SalesWebState({
    this.status = SalesWebStatus.initial,
    this.sales,
    this.query = const SalesQueryDefaults(),
    this.error,
    this.providers,
  });
  // Note: Const default constructor for SalesQuery

  SalesWebState copyWith({
    SalesWebStatus? status,
    PaginatedSales? sales,
    SalesQuery? query,
    String? error,
    List<Map<String, dynamic>>? providers,
  }) {
    return SalesWebState(
      status: status ?? this.status,
      sales: sales ?? this.sales,
      query: query ?? this.query,
      error: error,
      providers: providers ?? this.providers,
    );
  }

  @override
  List<Object?> get props => [status, sales, query, error, providers];
}

class SalesQueryDefaults extends SalesQuery {
  const SalesQueryDefaults() : super();
}

// Bloc
class SalesWebBloc extends Bloc<SalesWebEvent, SalesWebState> {
  final ISalesDataSource dataSource;

  SalesWebBloc({required this.dataSource}) : super(const SalesWebState()) {
    on<LoadSalesWeb>(_onLoadSales);
    on<LoadProvidersEvent>(_onLoadProviders);
    on<CreateSaleEvent>(_onCreateSale);
    on<UpdateSaleWeb>(_onUpdateSale);
  }

  Future<void> _onLoadSales(
    LoadSalesWeb event,
    Emitter<SalesWebState> emit,
  ) async {
    emit(state.copyWith(status: SalesWebStatus.loading));
    try {
      final query = event.query ?? state.query;
      final result = await dataSource.getSales(query);
      emit(
        state.copyWith(
          status: SalesWebStatus.success,
          sales: result,
          query: query,
        ),
      );
    } on ApiException catch (e) {
      emit(state.copyWith(status: SalesWebStatus.failure, error: e.code));
    } catch (e) {
      emit(state.copyWith(status: SalesWebStatus.failure, error: e.toString()));
    }
  }

  Future<void> _onLoadProviders(
    LoadProvidersEvent event,
    Emitter<SalesWebState> emit,
  ) async {
    emit(state.copyWith(status: SalesWebStatus.loading));
    try {
      final providers = await dataSource.getProviders('');
      emit(
        state.copyWith(
          status: SalesWebStatus.success,
          providers: providers.map((p) => p as Map<String, dynamic>).toList(),
        ),
      );
    } on ApiException catch (e) {
      emit(state.copyWith(status: SalesWebStatus.failure, error: e.code));
    } catch (e) {
      emit(
        state.copyWith(
          status: SalesWebStatus.failure,
          error: 'Failed to load providers: $e',
        ),
      );
    }
  }

  Future<void> _onCreateSale(
    CreateSaleEvent event,
    Emitter<SalesWebState> emit,
  ) async {
    emit(state.copyWith(status: SalesWebStatus.loading));
    try {
      await dataSource.saveSale(event.sale);
      emit(state.copyWith(status: SalesWebStatus.saleCreated));
    } on ApiException catch (e) {
      emit(state.copyWith(status: SalesWebStatus.failure, error: e.code));
    } catch (e) {
      emit(
        state.copyWith(
          status: SalesWebStatus.failure,
          error: 'Failed to create sale: $e',
        ),
      );
    }
  }

  Future<void> _onUpdateSale(
    UpdateSaleWeb event,
    Emitter<SalesWebState> emit,
  ) async {
    // We don't set global loading, maybe just optimistic update or specific loading?
    // For simplicity, reload after update.
    emit(state.copyWith(status: SalesWebStatus.loading));
    try {
      await dataSource.updateSale(event.id, event.updates);
      add(const LoadSalesWeb()); // Reload list
    } on ApiException catch (e) {
      emit(state.copyWith(status: SalesWebStatus.failure, error: e.code));
    } catch (e) {
      emit(
        state.copyWith(
          status: SalesWebStatus.failure,
          error: "Update failed: $e",
        ),
      );
    }
  }
}
