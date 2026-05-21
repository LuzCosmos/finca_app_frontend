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

  @override
  List<Object?> get props => [query];
}

class LoadBusinessPartnersEvent extends SalesWebEvent {
  const LoadBusinessPartnersEvent();
}

class CreateSaleEvent extends SalesWebEvent {
  final SaleModel sale;
  const CreateSaleEvent({required this.sale});
  @override
  List<Object?> get props => [sale];
}

class UpdateSaleWeb extends SalesWebEvent {
  final SaleModel sale;
  const UpdateSaleWeb({required this.sale});

  @override
  List<Object?> get props => [sale];
}

// State
enum SalesWebStatus {
  initial,
  loading,
  success,
  failure,
  saleCreated,
  saleUpdated,
}

class SalesWebState extends Equatable {
  final SalesWebStatus status;
  final PaginatedSales? sales;
  final SalesQuery query;
  final String? error;
  final List<Map<String, dynamic>>? businessPartners;

  const SalesWebState({
    this.status = SalesWebStatus.initial,
    this.sales,
    this.query = const SalesQueryDefaults(),
    this.error,
    this.businessPartners,
  });
  // Note: Const default constructor for SalesQuery

  SalesWebState copyWith({
    SalesWebStatus? status,
    PaginatedSales? sales,
    SalesQuery? query,
    String? error,
    List<Map<String, dynamic>>? businessPartners,
  }) {
    return SalesWebState(
      status: status ?? this.status,
      sales: sales ?? this.sales,
      query: query ?? this.query,
      error: error,
      businessPartners: businessPartners ?? this.businessPartners,
    );
  }

  @override
  List<Object?> get props => [status, sales, query, error, businessPartners];
}

class SalesQueryDefaults extends SalesQuery {
  const SalesQueryDefaults() : super();
}

// Bloc
class SalesWebBloc extends Bloc<SalesWebEvent, SalesWebState> {
  final ISalesDataSource dataSource;

  SalesWebBloc({required this.dataSource}) : super(const SalesWebState()) {
    on<LoadSalesWeb>(_onLoadSales);
    on<LoadBusinessPartnersEvent>(_onLoadBusinessPartners);
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

  Future<void> _onLoadBusinessPartners(
    LoadBusinessPartnersEvent event,
    Emitter<SalesWebState> emit,
  ) async {
    emit(state.copyWith(status: SalesWebStatus.loading));
    try {
      final businessPartners = await dataSource.getBusinessPartners('');
      emit(
        state.copyWith(
          status: SalesWebStatus.success,
          businessPartners:
              businessPartners.map((p) => p as Map<String, dynamic>).toList(),
        ),
      );
    } on ApiException catch (e) {
      emit(state.copyWith(status: SalesWebStatus.failure, error: e.code));
    } catch (e) {
      emit(
        state.copyWith(
          status: SalesWebStatus.failure,
          error: 'Failed to load business partners: $e',
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
    emit(state.copyWith(status: SalesWebStatus.loading));
    try {
      await dataSource.updateSale(event.sale.id, event.sale);
      final query = state.query;
      final refreshed = await dataSource.getSales(query);
      emit(
        state.copyWith(
          status: SalesWebStatus.saleUpdated,
          sales: refreshed,
          query: query,
        ),
      );
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
