import 'package:finca_app_frontend/modules/shared/features/massiveEvent/models/animal_simple_event_model.dart';

class AnimalSimpleEventTableRowModel {
  final String animalNumber;
  double? weight;
  String? tracker;
  String? earTag;
  bool castrated;
  List<String> idSimpleEventsApplied;
  List<String> medicalTreatments;
  List<String> brandNames;

  AnimalSimpleEventTableRowModel({
    required this.animalNumber,
    this.weight,
    this.tracker,
    this.earTag,
    this.castrated = false,
    this.idSimpleEventsApplied = const [],
    this.medicalTreatments = const [],
    this.brandNames = const [],
  });
}
