import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finca_app_frontend/modules/shared/features/brands/models/brand_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/bloc/massive_event_bloc.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/bloc/massive_event_event.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/bloc/massive_event_state.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/data/massive_event_page_data_source.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/animal_simple_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/massive_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_type.dart';

// Bajo prueba:
// - lib/modules/shared/features/massiveEvent/bloc/massive_event_bloc.dart
// - lib/modules/shared/features/massiveEvent/bloc/massive_event_event.dart
// - lib/modules/shared/features/massiveEvent/bloc/massive_event_state.dart
// - lib/modules/shared/features/massiveEvent/data/massive_event_page_data_source.dart (contrato)
// - modelos en lib/modules/shared/features/massiveEvent/models/ y brand_model (helpers)

class MockMassiveEventPageDataSource extends Mock
    implements IMassiveEventPageDataSource {}

BrandModel fakeBrand({
  String id = 'brand-1',
  String? idTenant = 'tenant-1',
  String name = 'Marca test',
}) {
  return BrandModel(
    id: id,
    idTenant: idTenant,
    name: name,
    imageMimeType: 'image/png',
    imageBase64: '',
  );
}

SimpleEventModel fakeSimpleEvent({
  String id = 'simple-1',
  String idTenant = 'tenant-1',
  String idMassiveEvent = 'massive-1',
  SimpleEventType type = SimpleEventType.weight,
}) {
  return SimpleEventModel(
    id: id,
    idTenant: idTenant,
    idMassiveEvent: idMassiveEvent,
    type: type,
    data: null,
    createdAt: DateTime(2024, 6, 1),
    isActive: true,
  );
}

MassiveEventModel fakeMassiveEvent({
  String id = 'massive-1',
  List<SimpleEventModel>? simpleEvents,
}) {
  return MassiveEventModel(
    id: id,
    idTenant: 'tenant-1',
    name: 'Masivo test',
    eventDate: DateTime(2024, 6, 2),
    simpleEvents: simpleEvents ?? [fakeSimpleEvent()],
    createdAt: DateTime(2024, 6, 1),
    updatedAt: DateTime(2024, 6, 1),
  );
}

AnimalSimpleEventModel fakeAnimal({
  String animalNumber = '001',
  String idMassiveEvent = 'massive-1',
  String idSimpleEvent = 'simple-1',
}) {
  return AnimalSimpleEventModel(
    animalNumber: animalNumber,
    type: SimpleEventType.weight,
    appliedAt: DateTime(2024, 6, 3),
    idMassiveEvent: idMassiveEvent,
    idSimpleEvent: idSimpleEvent,
  );
}

void main() {
  late MockMassiveEventPageDataSource dataSource;

  setUpAll(() {
    registerFallbackValue(fakeBrand());
    registerFallbackValue(fakeSimpleEvent());
    registerFallbackValue(fakeMassiveEvent());
    registerFallbackValue(<AnimalSimpleEventModel>[]);
  });

  setUp(() {
    dataSource = MockMassiveEventPageDataSource();
  });

  group('MassiveEventEvent', () {
    test('AddSimpleEvent equatable y props', () {
      final se = fakeSimpleEvent();
      expect(
        AddSimpleEvent(simpleEvent: se, idTenant: 'tenant-1'),
        AddSimpleEvent(simpleEvent: se, idTenant: 'tenant-1'),
      );
      expect(
        AddSimpleEvent(simpleEvent: se, idTenant: 'tenant-1').props,
        [se, 'tenant-1'],
      );
      expect(
        AddSimpleEvent(simpleEvent: se, idTenant: 'tenant-1'),
        isNot(AddSimpleEvent(simpleEvent: se, idTenant: 'tenant-2')),
      );
    });

    test('AddMassiveEventWithConfig equatable y props', () {
      final me = fakeMassiveEvent();
      expect(
        AddMassiveEventWithConfig(massiveEvent: me, idTenant: 'tenant-1'),
        AddMassiveEventWithConfig(massiveEvent: me, idTenant: 'tenant-1'),
      );
      expect(
        AddMassiveEventWithConfig(
          massiveEvent: me,
          idTenant: 'tenant-1',
        ).props,
        [me, 'tenant-1'],
      );
      expect(
        AddMassiveEventWithConfig(massiveEvent: me, idTenant: 'tenant-1'),
        isNot(
          AddMassiveEventWithConfig(massiveEvent: me, idTenant: 'tenant-2'),
        ),
      );
    });

    test('AddBrand equatable y props', () {
      final b = fakeBrand();
      expect(
        AddBrand(brand: b, idTenant: 'tenant-1'),
        AddBrand(brand: b, idTenant: 'tenant-1'),
      );
      expect(AddBrand(brand: b, idTenant: 'tenant-1').props, [b, 'tenant-1']);
      expect(
        AddBrand(brand: b, idTenant: 'tenant-1'),
        isNot(AddBrand(brand: b, idTenant: 'tenant-2')),
      );
    });

    test('AddAnimalSimpleEvents distingue cattleNumber en props', () {
      final events = [fakeAnimal()];
      expect(
        AddAnimalSimpleEvents(
          animalSimpleEvents: events,
          cattleNumber: '001',
        ).props,
        [events, '001'],
      );
      expect(
        AddAnimalSimpleEvents(
          animalSimpleEvents: events,
          cattleNumber: '001',
        ),
        isNot(
          AddAnimalSimpleEvents(
            animalSimpleEvents: events,
            cattleNumber: '002',
          ),
        ),
      );
    });

    test('CloseMassiveEvent equatable y props', () {
      expect(
        const CloseMassiveEvent(idMassiveEvent: 'm1'),
        const CloseMassiveEvent(idMassiveEvent: 'm1'),
      );
      expect(
        const CloseMassiveEvent(idMassiveEvent: 'm1').props,
        ['m1'],
      );
      expect(
        const CloseMassiveEvent(idMassiveEvent: 'm1'),
        isNot(const CloseMassiveEvent(idMassiveEvent: 'm2')),
      );
    });
  });

  group('MassiveEventState', () {
    test('estados base', () {
      expect(MassiveEventInitial(), MassiveEventInitial());
      expect(MassiveEventLoading(), MassiveEventLoading());
      expect(MassiveEventInitial(), isNot(MassiveEventLoading()));
      expect(MassiveEventInitial().props, isEmpty);
      expect(MassiveEventLoading().props, isEmpty);
    });

    test('MassiveEventSuccess equatable', () {
      final configs = [fakeSimpleEvent()];
      const a = MassiveEventSuccess(
        messageKey: 'k',
        configs: [],
      );
      expect(
        const MassiveEventSuccess(messageKey: 'k', configs: []),
        a,
      );
      expect(
        MassiveEventSuccess(messageKey: 'k', configs: configs),
        MassiveEventSuccess(messageKey: 'k', configs: configs),
      );
      expect(
        const MassiveEventSuccess(messageKey: 'a', configs: []),
        isNot(const MassiveEventSuccess(messageKey: 'b', configs: [])),
      );
    });

    test('MassiveEventError equatable', () {
      expect(
        const MassiveEventError(messageKey: 'k', debugInfo: 'd'),
        const MassiveEventError(messageKey: 'k', debugInfo: 'd'),
      );
      expect(
        const MassiveEventError(messageKey: 'k', debugInfo: 'd').props,
        ['k', 'd'],
      );
      expect(
        const MassiveEventError(messageKey: 'k', debugInfo: 'a'),
        isNot(const MassiveEventError(messageKey: 'k', debugInfo: 'b')),
      );
    });

    test('BrandCreatedSuccess distingue marca en props', () {
      expect(
        BrandCreatedSuccess(brand: fakeBrand(id: 'brand-1')),
        isNot(BrandCreatedSuccess(brand: fakeBrand(id: 'brand-2'))),
      );
      final b = fakeBrand();
      expect(
        BrandCreatedSuccess(brand: b),
        BrandCreatedSuccess(brand: b),
      );
    });

    test('AnimalSimpleEventsAdded equatable', () {
      final list = [fakeAnimal()];
      expect(
        AnimalSimpleEventsAdded(animalSimpleEvents: list),
        AnimalSimpleEventsAdded(animalSimpleEvents: list),
      );
      expect(
        AnimalSimpleEventsAdded(animalSimpleEvents: list).props,
        [list],
      );
      expect(
        AnimalSimpleEventsAdded(animalSimpleEvents: list),
        isNot(AnimalSimpleEventsAdded(animalSimpleEvents: [fakeAnimal()])),
      );
    });

    test('MassiveEventClosed equatable', () {
      expect(
        const MassiveEventClosed(idMassiveEvent: 'm1'),
        const MassiveEventClosed(idMassiveEvent: 'm1'),
      );
      expect(
        const MassiveEventClosed(idMassiveEvent: 'm1'),
        isNot(const MassiveEventClosed(idMassiveEvent: 'm2')),
      );
    });
  });

  group('MassiveEventBloc', () {
    test('estado inicial MassiveEventInitial', () async {
      final bloc = MassiveEventBloc(dataSource: dataSource);
      expect(bloc.state, MassiveEventInitial());
      await bloc.close();
      verifyZeroInteractions(dataSource);
    });

    blocTest<MassiveEventBloc, MassiveEventState>(
      'AddSimpleEvent éxito',
      build: () {
        final saved = fakeSimpleEvent(id: 'saved-id');
        when(
          () => dataSource.saveSimpleEvent(simpleEvent: any(named: 'simpleEvent')),
        ).thenAnswer(
          (_) async => SaveSimpleEventResult(saved: saved),
        );
        return MassiveEventBloc(dataSource: dataSource);
      },
      act: (bloc) {
        final se = fakeSimpleEvent();
        bloc.add(AddSimpleEvent(simpleEvent: se, idTenant: 'tenant-1'));
      },
      expect:
          () => [
            MassiveEventLoading(),
            isA<MassiveEventSuccess>()
                .having((s) => s.messageKey, 'messageKey', 'simpleEventAdded')
                .having((s) => s.configs.length, 'configs.length', 1)
                .having((s) => s.configs.first.id, 'configs.first.id', 'saved-id'),
          ],
      verify: (_) {
        verify(
          () => dataSource.saveSimpleEvent(simpleEvent: any(named: 'simpleEvent')),
        ).called(1);
        verifyNoMoreInteractions(dataSource);
      },
    );

    blocTest<MassiveEventBloc, MassiveEventState>(
      'AddSimpleEvent error y relanza',
      build: () {
        when(
          () => dataSource.saveSimpleEvent(simpleEvent: any(named: 'simpleEvent')),
        ).thenThrow(Exception('network'));
        return MassiveEventBloc(dataSource: dataSource);
      },
      act: (bloc) {
        bloc.add(
          AddSimpleEvent(simpleEvent: fakeSimpleEvent(), idTenant: 't'),
        );
      },
      expect:
          () => [
            MassiveEventLoading(),
            isA<MassiveEventError>()
                .having((s) => s.messageKey, 'messageKey', 'simpleEventError')
                .having(
                  (s) => s.debugInfo,
                  'debugInfo',
                  contains('network'),
                ),
          ],
      errors:
          () => [
            isA<Exception>(),
          ],
      verify: (_) {
        verify(
          () => dataSource.saveSimpleEvent(simpleEvent: any(named: 'simpleEvent')),
        ).called(1);
        verifyNoMoreInteractions(dataSource);
      },
    );

    blocTest<MassiveEventBloc, MassiveEventState>(
      'AddMassiveEventWithConfig éxito',
      build: () {
        final returned = fakeMassiveEvent(
          id: 'ret-1',
          simpleEvents: [fakeSimpleEvent(id: 'in-return')],
        );
        when(
          () => dataSource.saveMassiveEvent(
            massiveEvent: any(named: 'massiveEvent'),
          ),
        ).thenAnswer((_) async => returned);
        return MassiveEventBloc(dataSource: dataSource);
      },
      act: (bloc) {
        bloc.add(
          AddMassiveEventWithConfig(
            massiveEvent: fakeMassiveEvent(id: 'req-1'),
            idTenant: 'tenant-1',
          ),
        );
      },
      expect:
          () => [
            MassiveEventLoading(),
            isA<MassiveEventSuccess>()
                .having((s) => s.messageKey, 'messageKey', 'massiveEventSaved')
                .having((s) => s.configs.length, 'configs.length', 1)
                .having(
                  (s) => s.configs.first.id,
                  'configs.first.id',
                  'in-return',
                ),
          ],
      verify: (_) {
        verify(
          () => dataSource.saveMassiveEvent(
            massiveEvent: any(named: 'massiveEvent'),
          ),
        ).called(1);
        verifyNoMoreInteractions(dataSource);
      },
    );

    blocTest<MassiveEventBloc, MassiveEventState>(
      'AddMassiveEventWithConfig error y relanza',
      build: () {
        when(
          () => dataSource.saveMassiveEvent(
            massiveEvent: any(named: 'massiveEvent'),
          ),
        ).thenThrow(Exception('save massive'));
        return MassiveEventBloc(dataSource: dataSource);
      },
      act: (bloc) {
        bloc.add(
          AddMassiveEventWithConfig(
            massiveEvent: fakeMassiveEvent(),
            idTenant: 't',
          ),
        );
      },
      expect:
          () => [
            MassiveEventLoading(),
            isA<MassiveEventError>()
                .having((s) => s.messageKey, 'messageKey', 'massiveEventError')
                .having(
                  (s) => s.debugInfo,
                  'debugInfo',
                  contains('save massive'),
                ),
          ],
      errors: () => [isA<Exception>()],
      verify: (_) {
        verify(
          () => dataSource.saveMassiveEvent(
            massiveEvent: any(named: 'massiveEvent'),
          ),
        ).called(1);
        verifyNoMoreInteractions(dataSource);
      },
    );

    blocTest<MassiveEventBloc, MassiveEventState>(
      'AddBrand éxito y campos de marca',
      build: () {
        when(() => dataSource.saveBrand(brand: any(named: 'brand'))).thenAnswer((
          invocation,
        ) async {
          final brand = invocation.namedArguments[#brand] as BrandModel;
          return BrandModel(
            id: 'saved-${brand.id}',
            idTenant: brand.idTenant,
            name: brand.name,
            imageMimeType: brand.imageMimeType,
            imageBase64: brand.imageBase64,
            imageBytes: brand.imageBytes,
          );
        });
        return MassiveEventBloc(dataSource: dataSource);
      },
      act: (bloc) {
        final brand = fakeBrand(id: 'local', name: 'Marca test');
        bloc.add(AddBrand(brand: brand, idTenant: 'tenant-1'));
      },
      expect:
          () => [
            MassiveEventLoading(),
            isA<BrandCreatedSuccess>().having((s) => s.brand.id, 'id', 'saved-local').having(
                  (s) => s.brand.name,
                  'name',
                  'Marca test',
                ).having(
                  (s) => s.brand.imageMimeType,
                  'imageMimeType',
                  'image/png',
                ).having((s) => s.brand.imageBase64, 'imageBase64', '').having(
                  (s) => s.brand.idTenant,
                  'idTenant',
                  'tenant-1',
                ),
          ],
      verify: (_) {
        verify(() => dataSource.saveBrand(brand: any(named: 'brand'))).called(1);
        verifyNoMoreInteractions(dataSource);
      },
    );

    blocTest<MassiveEventBloc, MassiveEventState>(
      'AddBrand error',
      build: () {
        when(
          () => dataSource.saveBrand(brand: any(named: 'brand')),
        ).thenThrow(Exception('red'));
        return MassiveEventBloc(dataSource: dataSource);
      },
      act: (bloc) {
        bloc.add(AddBrand(brand: fakeBrand(), idTenant: 't'));
      },
      expect:
          () => [
            MassiveEventLoading(),
            isA<MassiveEventError>()
                .having((s) => s.messageKey, 'messageKey', 'brandSaveError')
                .having((s) => s.debugInfo, 'debugInfo', contains('red')),
          ],
      verify: (_) {
        verify(() => dataSource.saveBrand(brand: any(named: 'brand'))).called(1);
        verifyNoMoreInteractions(dataSource);
      },
    );

    blocTest<MassiveEventBloc, MassiveEventState>(
      'AddAnimalSimpleEvents éxito',
      build: () {
        final saved = [fakeAnimal(animalNumber: '99')];
        when(
          () => dataSource.saveAnimalSimpleEvents(
            animalSimpleEvents: any(named: 'animalSimpleEvents'),
            cattleNumber: any(named: 'cattleNumber'),
          ),
        ).thenAnswer(
          (_) async => SaveAnimalSimpleEventsResult(animalSimpleEvents: saved),
        );
        return MassiveEventBloc(dataSource: dataSource);
      },
      act: (bloc) {
        final events = [fakeAnimal()];
        bloc.add(
          AddAnimalSimpleEvents(animalSimpleEvents: events, cattleNumber: '001'),
        );
      },
      expect:
          () => [
            MassiveEventLoading(),
            isA<AnimalSimpleEventsAdded>()
                .having(
                  (s) => s.animalSimpleEvents.length,
                  'length',
                  1,
                )
                .having(
                  (s) => s.animalSimpleEvents.first.animalNumber,
                  'animalNumber',
                  '99',
                ),
          ],
      verify: (_) {
        verify(
          () => dataSource.saveAnimalSimpleEvents(
            animalSimpleEvents: any(named: 'animalSimpleEvents'),
            cattleNumber: '001',
          ),
        ).called(1);
        verifyNoMoreInteractions(dataSource);
      },
    );

    blocTest<MassiveEventBloc, MassiveEventState>(
      'AddAnimalSimpleEvents error',
      build: () {
        when(
          () => dataSource.saveAnimalSimpleEvents(
            animalSimpleEvents: any(named: 'animalSimpleEvents'),
            cattleNumber: any(named: 'cattleNumber'),
          ),
        ).thenThrow(Exception('animal fail'));
        return MassiveEventBloc(dataSource: dataSource);
      },
      act: (bloc) {
        bloc.add(
          AddAnimalSimpleEvents(
            animalSimpleEvents: [fakeAnimal()],
            cattleNumber: '001',
          ),
        );
      },
      expect:
          () => [
            MassiveEventLoading(),
            isA<MassiveEventError>()
                .having(
                  (s) => s.messageKey,
                  'messageKey',
                  'animalSimpleEventError',
                )
                .having(
                  (s) => s.debugInfo,
                  'debugInfo',
                  contains('animal fail'),
                ),
          ],
      verify: (_) {
        verify(
          () => dataSource.saveAnimalSimpleEvents(
            animalSimpleEvents: any(named: 'animalSimpleEvents'),
            cattleNumber: '001',
          ),
        ).called(1);
        verifyNoMoreInteractions(dataSource);
      },
    );

    blocTest<MassiveEventBloc, MassiveEventState>(
      'CloseMassiveEvent éxito',
      build: () {
        when(
          () => dataSource.closeMassiveEvent(idMassiveEvent: any(named: 'idMassiveEvent')),
        ).thenAnswer((_) async {});
        return MassiveEventBloc(dataSource: dataSource);
      },
      act: (bloc) {
        bloc.add(const CloseMassiveEvent(idMassiveEvent: 'massive-1'));
      },
      expect:
          () =>
              [
                MassiveEventLoading(),
                const MassiveEventClosed(idMassiveEvent: 'massive-1'),
              ],
      verify: (_) {
        verify(
          () => dataSource.closeMassiveEvent(idMassiveEvent: 'massive-1'),
        ).called(1);
        verifyNoMoreInteractions(dataSource);
      },
    );

    blocTest<MassiveEventBloc, MassiveEventState>(
      'CloseMassiveEvent error',
      build: () {
        when(
          () => dataSource.closeMassiveEvent(idMassiveEvent: any(named: 'idMassiveEvent')),
        ).thenThrow(Exception('close fail'));
        return MassiveEventBloc(dataSource: dataSource);
      },
      act: (bloc) {
        bloc.add(const CloseMassiveEvent(idMassiveEvent: 'massive-1'));
      },
      expect:
          () => [
            MassiveEventLoading(),
            isA<MassiveEventError>()
                .having(
                  (s) => s.messageKey,
                  'messageKey',
                  'massiveEventCloseError',
                )
                .having(
                  (s) => s.debugInfo,
                  'debugInfo',
                  contains('close fail'),
                ),
          ],
      verify: (_) {
        verify(
          () => dataSource.closeMassiveEvent(idMassiveEvent: 'massive-1'),
        ).called(1);
        verifyNoMoreInteractions(dataSource);
      },
    );
  });
}
