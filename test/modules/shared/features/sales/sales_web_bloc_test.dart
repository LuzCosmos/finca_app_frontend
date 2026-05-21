import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finca_app_frontend/modules/shared/features/sales/bloc/sales_web_bloc.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/data/sales_data_source.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/models/sale_model.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/models/sales_query_models.dart';

class MockSalesDataSource extends Mock implements ISalesDataSource {}

SaleModel fakeSale({String id = 'sale-1'}) {
  return SaleModel(
    id: id,
    idTenant: 'tenant-1',
    transactionDate: DateTime(2024, 6, 1),
    buyerId: 'buyer-1',
    minWeightConfig: 100,
    valuePerKgConfig: 2.5,
    totalAmount: 1000,
    totalWeight: 400,
    totalCount: 1,
  );
}

void main() {
  late MockSalesDataSource dataSource;

  setUpAll(() {
    registerFallbackValue(fakeSale());
    registerFallbackValue(const SalesQuery());
  });

  setUp(() {
    dataSource = MockSalesDataSource();
  });

  group('SalesWebBloc', () {
    blocTest<SalesWebBloc, SalesWebState>(
      'CreateSaleEvent emite saleCreated',
      build: () {
        when(() => dataSource.saveSale(any())).thenAnswer((_) async {});
        return SalesWebBloc(dataSource: dataSource);
      },
      act: (bloc) => bloc.add(CreateSaleEvent(sale: fakeSale())),
      expect: () => [
        const SalesWebState(status: SalesWebStatus.loading),
        const SalesWebState(status: SalesWebStatus.saleCreated),
      ],
    );

    blocTest<SalesWebBloc, SalesWebState>(
      'LoadBusinessPartnersEvent carga lista en state',
      build: () {
        when(() => dataSource.getBusinessPartners(any())).thenAnswer(
          (_) async => [
            {'id': 'bp-1', 'name': 'Buyer', 'type': 'BUYER'},
          ],
        );
        return SalesWebBloc(dataSource: dataSource);
      },
      act: (bloc) => bloc.add(const LoadBusinessPartnersEvent()),
      expect: () => [
        const SalesWebState(status: SalesWebStatus.loading),
        isA<SalesWebState>()
            .having((s) => s.status, 'status', SalesWebStatus.success)
            .having((s) => s.businessPartners?.length, 'count', 1),
      ],
    );

    blocTest<SalesWebBloc, SalesWebState>(
      'UpdateSaleWeb emite saleUpdated y recarga listado',
      build: () {
        when(() => dataSource.updateSale(any(), any())).thenAnswer((_) async {});
        when(() => dataSource.getSales(any())).thenAnswer(
          (_) async => PaginatedSales(
            items: [fakeSale(id: 'sale-1')],
            total: 1,
          ),
        );
        return SalesWebBloc(dataSource: dataSource);
      },
      act: (bloc) => bloc.add(UpdateSaleWeb(sale: fakeSale())),
      expect: () => [
        const SalesWebState(status: SalesWebStatus.loading),
        isA<SalesWebState>().having(
          (s) => s.status,
          'status',
          SalesWebStatus.saleUpdated,
        ).having((s) => s.sales?.total, 'sales total', 1),
      ],
    );
  });
}
