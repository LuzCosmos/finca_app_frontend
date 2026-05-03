import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finca_app_frontend/modules/shared/features/sales/bloc/sales_bloc.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/bloc/sales_event.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/bloc/sales_state.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/data/sales_data_source.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/models/sale_model.dart';

// Bajo prueba:
// - lib/modules/shared/features/sales/bloc/sales_bloc.dart
// - lib/modules/shared/features/sales/bloc/sales_event.dart
// - lib/modules/shared/features/sales/bloc/sales_state.dart
// - lib/modules/shared/features/sales/data/sales_data_source.dart (contrato ISalesDataSource)
// - lib/modules/shared/features/sales/models/sale_model.dart

class MockSalesDataSource extends Mock implements ISalesDataSource {}

SaleModel fakeSale({String id = 'sale-1', bool isSynced = false}) {
  return SaleModel(
    id: id,
    idTenant: 'tenant-1',
    transactionDate: DateTime(2024, 6, 1),
    buyerId: 'buyer-1',
    minWeightConfig: 100,
    valuePerKgConfig: 2.5,
    totalAmount: 1000,
    totalWeight: 400,
    totalCount: 2,
    isSynced: isSynced,
  );
}

void main() {
  late MockSalesDataSource dataSource;

  setUpAll(() {
    registerFallbackValue(fakeSale());
  });

  setUp(() {
    dataSource = MockSalesDataSource();
  });

  group('SalesEvent', () {
    test('LoadSalesInitialData igualdad y props vacíos', () {
      expect(LoadSalesInitialData(), LoadSalesInitialData());
      expect(LoadSalesInitialData().props, isEmpty);
    });

    test('SearchCattleByNumber igualdad y props', () {
      expect(
        const SearchCattleByNumber('001'),
        const SearchCattleByNumber('001'),
      );
      expect(
        const SearchCattleByNumber('001'),
        isNot(const SearchCattleByNumber('002')),
      );
      expect(const SearchCattleByNumber('001').props, ['001']);
    });

    test('SaveSaleTransaction igualdad y props', () {
      final sale = fakeSale();
      expect(SaveSaleTransaction(sale), SaveSaleTransaction(sale));
      expect(SaveSaleTransaction(sale).props, [sale]);
      expect(
        SaveSaleTransaction(sale),
        isNot(SaveSaleTransaction(fakeSale(id: 'otro'))),
      );
    });

    test('LoadUnsyncedSales igualdad y props vacíos', () {
      expect(LoadUnsyncedSales(), LoadUnsyncedSales());
      expect(LoadUnsyncedSales().props, isEmpty);
    });

    test('SyncSalesTransaction igualdad y props vacíos', () {
      expect(SyncSalesTransaction(), SyncSalesTransaction());
      expect(SyncSalesTransaction().props, isEmpty);
    });
  });

  group('SalesState', () {
    test('estados sin props explícitos', () {
      expect(SalesInitial(), SalesInitial());
      expect(SalesLoading(), SalesLoading());
      expect(SaleSavedSuccess(), SaleSavedSuccess());
      expect(SalesInitial().props, isEmpty);
      expect(SalesLoading().props, isEmpty);
      expect(SaleSavedSuccess().props, isEmpty);
      expect(SalesInitial(), isNot(SalesLoading()));
    });

    test('SalesReady', () {
      const buyers = <dynamic>[{'id': 'b1'}];
      const transporters = <dynamic>['t1'];
      expect(
        const SalesReady(buyers: buyers, transporters: transporters),
        const SalesReady(buyers: buyers, transporters: transporters),
      );
      expect(
        const SalesReady(buyers: buyers, transporters: transporters).props,
        [buyers, transporters],
      );
      expect(
        const SalesReady(buyers: [1], transporters: []),
        isNot(const SalesReady(buyers: [2], transporters: [])),
      );
    });

    test('CattleSearchSuccess', () {
      final cattle = <String, Object?>{'number': '001'};
      expect(CattleSearchSuccess(cattle), CattleSearchSuccess(cattle));
      expect(CattleSearchSuccess(cattle).props, [cattle]);
      expect(
        CattleSearchSuccess(cattle),
        isNot(CattleSearchSuccess(<String, Object?>{'number': '002'})),
      );
    });

    test('SalesError', () {
      expect(const SalesError('m1'), const SalesError('m1'));
      expect(const SalesError('m1'), isNot(const SalesError('m2')));
      expect(const SalesError('m1').props, ['m1']);
    });

    test('UnsyncedSalesLoaded', () {
      final sales = [fakeSale()];
      expect(UnsyncedSalesLoaded(sales), UnsyncedSalesLoaded(sales));
      expect(UnsyncedSalesLoaded(sales).props, [sales]);
      expect(
        UnsyncedSalesLoaded(sales),
        isNot(UnsyncedSalesLoaded([fakeSale(id: 'x')])),
      );
    });
  });

  group('SalesBloc', () {
    test('estado inicial es SalesInitial', () async {
      final bloc = SalesBloc(dataSource: dataSource);
      expect(bloc.state, SalesInitial());
      await bloc.close();
      verifyZeroInteractions(dataSource);
    });

    blocTest<SalesBloc, SalesState>(
      'LoadSalesInitialData emite SalesReady con buyers y transporters',
      build: () {
        when(() => dataSource.fetchCatalogs()).thenAnswer((_) async {});
        when(
          () => dataSource.getProviders('BUYER'),
        ).thenAnswer((_) async => <dynamic>[const {'id': 'buyer-a'}]);
        when(
          () => dataSource.getProviders('TRANSPORTER'),
        ).thenAnswer((_) async => <dynamic>['tr-1']);
        return SalesBloc(dataSource: dataSource);
      },
      act: (bloc) => bloc.add(LoadSalesInitialData()),
      expect:
          () => [
            SalesLoading(),
            const SalesReady(
              buyers: <dynamic>[{'id': 'buyer-a'}],
              transporters: <dynamic>['tr-1'],
            ),
          ],
      verify: (_) {
        verify(() => dataSource.fetchCatalogs()).called(1);
        verify(() => dataSource.getProviders('BUYER')).called(1);
        verify(() => dataSource.getProviders('TRANSPORTER')).called(1);
        verifyNoMoreInteractions(dataSource);
      },
    );

    blocTest<SalesBloc, SalesState>(
      'LoadSalesInitialData emite SalesError si fetchCatalogs falla',
      build: () {
        when(
          () => dataSource.fetchCatalogs(),
        ).thenThrow(Exception('catálogo'));
        return SalesBloc(dataSource: dataSource);
      },
      act: (bloc) => bloc.add(LoadSalesInitialData()),
      expect:
          () => [
            SalesLoading(),
            const SalesError('Exception: catálogo'),
          ],
      verify: (_) {
        verify(() => dataSource.fetchCatalogs()).called(1);
        verifyNever(() => dataSource.getProviders(any()));
        verifyNoMoreInteractions(dataSource);
      },
    );

    blocTest<SalesBloc, SalesState>(
      'LoadSalesInitialData emite SalesError si getProviders BUYER falla',
      build: () {
        when(() => dataSource.fetchCatalogs()).thenAnswer((_) async {});
        when(
          () => dataSource.getProviders('BUYER'),
        ).thenThrow(Exception('buyer-red'));
        return SalesBloc(dataSource: dataSource);
      },
      act: (bloc) => bloc.add(LoadSalesInitialData()),
      expect:
          () => [
            SalesLoading(),
            const SalesError('Exception: buyer-red'),
          ],
      verify: (_) {
        verify(() => dataSource.fetchCatalogs()).called(1);
        verify(() => dataSource.getProviders('BUYER')).called(1);
        verifyNever(() => dataSource.getProviders('TRANSPORTER'));
        verifyNoMoreInteractions(dataSource);
      },
    );

    blocTest<SalesBloc, SalesState>(
      'LoadSalesInitialData emite SalesError si getProviders TRANSPORTER falla',
      build: () {
        when(() => dataSource.fetchCatalogs()).thenAnswer((_) async {});
        when(
          () => dataSource.getProviders('BUYER'),
        ).thenAnswer((_) async => <dynamic>[]);
        when(
          () => dataSource.getProviders('TRANSPORTER'),
        ).thenThrow(Exception('transporter-red'));
        return SalesBloc(dataSource: dataSource);
      },
      act: (bloc) => bloc.add(LoadSalesInitialData()),
      expect:
          () => [
            SalesLoading(),
            const SalesError('Exception: transporter-red'),
          ],
      verify: (_) {
        verify(() => dataSource.fetchCatalogs()).called(1);
        verify(() => dataSource.getProviders('BUYER')).called(1);
        verify(() => dataSource.getProviders('TRANSPORTER')).called(1);
        verifyNoMoreInteractions(dataSource);
      },
    );

    blocTest<SalesBloc, SalesState>(
      'SearchCattleByNumber emite CattleSearchSuccess',
      build: () {
        final cattle = <String, Object?>{'number': '001'};
        when(
          () => dataSource.getCattleByNumber('001'),
        ).thenAnswer((_) async => cattle);
        return SalesBloc(dataSource: dataSource);
      },
      act: (bloc) => bloc.add(const SearchCattleByNumber('001')),
      expect:
          () => [
            SalesLoading(),
            isA<CattleSearchSuccess>().having(
              (s) => (s.cattle as Map<String, Object?>)['number'],
              'number',
              '001',
            ),
          ],
      verify: (_) {
        verify(() => dataSource.getCattleByNumber('001')).called(1);
        verifyNoMoreInteractions(dataSource);
      },
    );

    blocTest<SalesBloc, SalesState>(
      'SearchCattleByNumber sin resultado emite SalesError',
      build: () {
        when(
          () => dataSource.getCattleByNumber('999'),
        ).thenAnswer((_) async => null);
        return SalesBloc(dataSource: dataSource);
      },
      act: (bloc) => bloc.add(const SearchCattleByNumber('999')),
      expect:
          () => [
            SalesLoading(),
            const SalesError('Cattle not found'),
          ],
      verify: (_) {
        verify(() => dataSource.getCattleByNumber('999')).called(1);
        verifyNoMoreInteractions(dataSource);
      },
    );

    blocTest<SalesBloc, SalesState>(
      'SearchCattleByNumber excepción emite SalesError',
      build: () {
        when(
          () => dataSource.getCattleByNumber('001'),
        ).thenThrow(Exception('red'));
        return SalesBloc(dataSource: dataSource);
      },
      act: (bloc) => bloc.add(const SearchCattleByNumber('001')),
      expect:
          () => [
            SalesLoading(),
            const SalesError('Exception: red'),
          ],
      verify: (_) {
        verify(() => dataSource.getCattleByNumber('001')).called(1);
        verifyNoMoreInteractions(dataSource);
      },
    );

    blocTest<SalesBloc, SalesState>(
      'SaveSaleTransaction emite SaleSavedSuccess',
      build: () {
        when(() => dataSource.saveSale(any())).thenAnswer((_) async {});
        return SalesBloc(dataSource: dataSource);
      },
      act: (bloc) => bloc.add(SaveSaleTransaction(fakeSale())),
      expect:
          () => [
            SalesLoading(),
            SaleSavedSuccess(),
          ],
      verify: (_) {
        verify(() => dataSource.saveSale(any())).called(1);
        verifyNoMoreInteractions(dataSource);
      },
    );

    blocTest<SalesBloc, SalesState>(
      'SaveSaleTransaction error',
      build: () {
        when(() => dataSource.saveSale(any())).thenThrow(Exception('save-fail'));
        return SalesBloc(dataSource: dataSource);
      },
      act: (bloc) => bloc.add(SaveSaleTransaction(fakeSale())),
      expect:
          () => [
            SalesLoading(),
            const SalesError('Exception: save-fail'),
          ],
      verify: (_) {
        verify(() => dataSource.saveSale(any())).called(1);
        verifyNoMoreInteractions(dataSource);
      },
    );

    blocTest<SalesBloc, SalesState>(
      'LoadUnsyncedSales emite UnsyncedSalesLoaded',
      build: () {
        final sales = [fakeSale(id: 'u1')];
        when(
          () => dataSource.getUnsyncedSales(),
        ).thenAnswer((_) async => sales);
        return SalesBloc(dataSource: dataSource);
      },
      act: (bloc) => bloc.add(LoadUnsyncedSales()),
      expect:
          () => [
            SalesLoading(),
            UnsyncedSalesLoaded([fakeSale(id: 'u1')]),
          ],
      verify: (_) {
        verify(() => dataSource.getUnsyncedSales()).called(1);
        verifyNoMoreInteractions(dataSource);
      },
    );

    blocTest<SalesBloc, SalesState>(
      'LoadUnsyncedSales lista vacía',
      build: () {
        when(
          () => dataSource.getUnsyncedSales(),
        ).thenAnswer((_) async => <SaleModel>[]);
        return SalesBloc(dataSource: dataSource);
      },
      act: (bloc) => bloc.add(LoadUnsyncedSales()),
      expect:
          () => [
            SalesLoading(),
            const UnsyncedSalesLoaded([]),
          ],
      verify: (_) {
        verify(() => dataSource.getUnsyncedSales()).called(1);
        verifyNoMoreInteractions(dataSource);
      },
    );

    blocTest<SalesBloc, SalesState>(
      'LoadUnsyncedSales error',
      build: () {
        when(
          () => dataSource.getUnsyncedSales(),
        ).thenThrow(Exception('no-list'));
        return SalesBloc(dataSource: dataSource);
      },
      act: (bloc) => bloc.add(LoadUnsyncedSales()),
      expect:
          () => [
            SalesLoading(),
            const SalesError('Exception: no-list'),
          ],
      verify: (_) {
        verify(() => dataSource.getUnsyncedSales()).called(1);
        verifyNoMoreInteractions(dataSource);
      },
    );

    blocTest<SalesBloc, SalesState>(
      'SyncSalesTransaction delega en LoadUnsyncedSales al tener éxito',
      build: () {
        final sales = [fakeSale(id: 'synced-1')];
        when(() => dataSource.syncSales()).thenAnswer((_) async {});
        when(
          () => dataSource.getUnsyncedSales(),
        ).thenAnswer((_) async => sales);
        return SalesBloc(dataSource: dataSource);
      },
      act: (bloc) => bloc.add(SyncSalesTransaction()),
      expect:
          () => [
            SalesLoading(),
            UnsyncedSalesLoaded([fakeSale(id: 'synced-1')]),
          ],
      verify: (_) {
        verify(() => dataSource.syncSales()).called(1);
        verify(() => dataSource.getUnsyncedSales()).called(1);
        verifyNoMoreInteractions(dataSource);
      },
    );

    blocTest<SalesBloc, SalesState>(
      'SyncSalesTransaction error en syncSales',
      build: () {
        when(() => dataSource.syncSales()).thenThrow(Exception('sync-bad'));
        return SalesBloc(dataSource: dataSource);
      },
      act: (bloc) => bloc.add(SyncSalesTransaction()),
      expect:
          () => [
            SalesLoading(),
            const SalesError('Exception: sync-bad'),
          ],
      verify: (_) {
        verify(() => dataSource.syncSales()).called(1);
        verifyNever(() => dataSource.getUnsyncedSales());
        verifyNoMoreInteractions(dataSource);
      },
    );

    blocTest<SalesBloc, SalesState>(
      'SyncSalesTransaction sync ok pero falla getUnsyncedSales',
      build: () {
        when(() => dataSource.syncSales()).thenAnswer((_) async {});
        when(
          () => dataSource.getUnsyncedSales(),
        ).thenThrow(Exception('reload'));
        return SalesBloc(dataSource: dataSource);
      },
      act: (bloc) => bloc.add(SyncSalesTransaction()),
      expect:
          () => [
            SalesLoading(),
            const SalesError('Exception: reload'),
          ],
      verify: (_) {
        verify(() => dataSource.syncSales()).called(1);
        verify(() => dataSource.getUnsyncedSales()).called(1);
        verifyNoMoreInteractions(dataSource);
      },
    );
  });
}
