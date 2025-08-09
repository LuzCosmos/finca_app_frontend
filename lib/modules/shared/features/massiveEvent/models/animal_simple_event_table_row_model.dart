import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/animal_simple_event_model.dart';
import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/simple_event_type.dart';

class AnimalSimpleEventTableRowModel {
  final String animalNumber;
  double? weight;
  String? tracker;
  String? earTag;
  bool castrated;
  List<String> idSimpleEventsApplied;
  List<String> medicalTreatments;
  List<String> brandNames;
  List<String> idBrandsApplied;
  bool isSynced;

  AnimalSimpleEventTableRowModel({
    required this.animalNumber,
    this.weight,
    this.tracker,
    this.earTag,
    this.castrated = false,
    List<String>? idSimpleEventsApplied,
    List<String>? medicalTreatments,
    List<String>? brandNames,
    List<String>? idBrandsApplied,
    this.isSynced = false,
  }) : idSimpleEventsApplied = idSimpleEventsApplied ?? [],
       medicalTreatments = medicalTreatments ?? [],
       brandNames = brandNames ?? [],
       idBrandsApplied = idBrandsApplied ?? [];

  static AnimalSimpleEventTableRowModel createFromAnimalSimpleEventList(
    List<AnimalSimpleEventModel> animalSimpleEvents,
  ) {
    final weightEvent = animalSimpleEvents.firstWhereOrNull(
      (e) => e.type == SimpleEventType.weight && e.data != null,
    );

    final weight =
        weightEvent != null
            ? double.tryParse(jsonDecode(weightEvent.data!)['weight'])
            : null;

    final trackerEvent = animalSimpleEvents.firstWhereOrNull(
      (e) => e.type == SimpleEventType.tracker && e.data != null,
    );

    final tracker =
        trackerEvent != null ? jsonDecode(trackerEvent.data!)['tracker'] : null;

    final earTagEvent = animalSimpleEvents.firstWhereOrNull(
      (e) => e.type == SimpleEventType.eartag && e.data != null,
    );

    final earTag =
        earTagEvent != null ? jsonDecode(earTagEvent.data!)['eartag'] : null;

    final castratedEvent = animalSimpleEvents.firstWhereOrNull(
      (e) => e.type == SimpleEventType.castration && e.data != null,
    );
    final castrated = castratedEvent != null ? true : false;
    final idSimpleEventsApplied =
        animalSimpleEvents.map((e) => e.idSimpleEvent).toList();
    final medicalTreatments =
        animalSimpleEvents
            .where((e) => e.type == SimpleEventType.medication)
            .map((e) {
              final data = jsonDecode(e.data!);
              return (data['medicationName'] ?? '').toString();
            })
            .toList();
    final brandNames =
        animalSimpleEvents.where((e) => e.type == SimpleEventType.brand).map((
          e,
        ) {
          final data = jsonDecode(e.data!);
          return (data['brandName'] ?? '').toString();
        }).toList();
    final idBrandsApplied =
        animalSimpleEvents.where((e) => e.type == SimpleEventType.brand).map((
          e,
        ) {
          final data = jsonDecode(e.data!);
          return (data['idBrand']).toString();
        }).toList();
    return AnimalSimpleEventTableRowModel(
      animalNumber: animalSimpleEvents.first.animalNumber,
      weight: weight,
      tracker: tracker,
      earTag: earTag,
      castrated: castrated,
      idSimpleEventsApplied: idSimpleEventsApplied,
      medicalTreatments: medicalTreatments,
      brandNames: brandNames,
      idBrandsApplied: idBrandsApplied,
    );
  }

  void updateWith(
    List<AnimalSimpleEventModel> animalSimpleEvents,
    bool isSynced,
  ) {
    final weightEvent = animalSimpleEvents.firstWhereOrNull(
      (e) => e.type == SimpleEventType.weight && e.data != null,
    );
    final weight =
        weightEvent != null
            ? double.tryParse(jsonDecode(weightEvent.data!)['weight'])
            : null;
    final trackerEvent = animalSimpleEvents.firstWhereOrNull(
      (e) => e.type == SimpleEventType.tracker && e.data != null,
    );
    final tracker =
        trackerEvent != null ? jsonDecode(trackerEvent.data!)['tracker'] : null;
    final earTagEvent = animalSimpleEvents.firstWhereOrNull(
      (e) => e.type == SimpleEventType.eartag && e.data != null,
    );
    final earTag =
        earTagEvent != null ? jsonDecode(earTagEvent.data!)['eartag'] : null;
    final castratedEvent = animalSimpleEvents.firstWhereOrNull(
      (e) => e.type == SimpleEventType.castration && e.data != null,
    );
    final castrated = castratedEvent != null ? true : false;
    final newIdSimpleEventsApplied =
        animalSimpleEvents.map((e) => e.idSimpleEvent).toList();
    final newMedicalTreatments =
        animalSimpleEvents
            .where((e) => e.type == SimpleEventType.medication)
            .map((e) {
              final data = jsonDecode(e.data!);
              return (data['medicationName'] ?? '').toString();
            })
            .toList();
    final newBrandNames =
        animalSimpleEvents.where((e) => e.type == SimpleEventType.brand).map((
          e,
        ) {
          final data = jsonDecode(e.data!);
          return (data['brandName'] ?? '').toString();
        }).toList();
    final newIdBrandsApplied =
        animalSimpleEvents.where((e) => e.type == SimpleEventType.brand).map((
          e,
        ) {
          final data = jsonDecode(e.data!);
          return (data['idBrand']).toString();
        }).toList();
    this.weight = weight ?? this.weight;
    this.tracker = tracker ?? this.tracker;
    this.earTag = earTag ?? this.earTag;
    this.castrated = castrated;
    this.isSynced = isSynced;
    idSimpleEventsApplied =
        {...idSimpleEventsApplied, ...newIdSimpleEventsApplied}.toList();
    medicalTreatments =
        {...medicalTreatments, ...newMedicalTreatments}.toList();
    brandNames = {...brandNames, ...newBrandNames}.toList();
    idBrandsApplied = {...idBrandsApplied, ...newIdBrandsApplied}.toList();
  }
}
