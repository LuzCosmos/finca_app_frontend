// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'package:finca_app_frontend/l10n/app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Finca App';

  @override
  String get fieldRequired => 'This field is mandatory';

  @override
  String get delete => 'Delete';

  @override
  String get fixErrors => 'Please fix the errors highlighted in red.';

  @override
  String get numberFormat => '#,##0.##';

  @override
  String get numberFormat_country => 'en_US';

  @override
  String get error_invalidData => 'Invalid data in the form.';

  @override
  String get error_forbidden =>
      'You do not have permission to perform this action.';

  @override
  String get error_conflict => 'Duplicate entry in database';

  @override
  String get error_server => 'Internal server error. Please try again later.';

  @override
  String get error_savingObject => 'An unexpected error occurred while saving';

  @override
  String get error_unauthorized =>
      'Your session has expired and you need to log in again.';

  @override
  String get error_serverConnection =>
      'Unable to connect to the server. Please check your internet connection or try again later.';

  @override
  String get error_generic => 'An unexpected error has occurred.';

  @override
  String get login_username => 'Username';

  @override
  String get login_usernameRequired => 'Please enter your username';

  @override
  String get login_password => 'Password';

  @override
  String get login_passwordRequired => 'Please enter your password';

  @override
  String get login_company => 'Company';

  @override
  String get login_login => 'Login';

  @override
  String get login_loginError => 'Login failed, please try again';

  @override
  String get login_invalidCredentials =>
      'Incorrect credentials. Please try again.';

  @override
  String get login_unexpectedError =>
      'An unexpected error occurred. Please try again later.';

  @override
  String get home_title => 'Home';

  @override
  String get home_purchase => 'Purchase';

  @override
  String get home_purchaseReception => 'Purchase Reception';

  @override
  String get home_massiveEvent => 'Massive Event';

  @override
  String get home_sale => 'Sale';

  @override
  String get purchase_date => 'Purchase Date';

  @override
  String get purchase_dateRequired => 'You must select a purchase date.';

  @override
  String get purchase_create => 'Create Purchase';

  @override
  String get purchase_saveSuccess => 'Purchase saved successfully.';

  @override
  String get purchase_saveError => 'Failed to save purchase.';

  @override
  String get cattlePurchase => 'Cattle Purchase';

  @override
  String get cp_error_noLots => 'At least one lot is required';

  @override
  String get cp_error_providerRequired => 'Please select or create a provider.';

  @override
  String get provider => 'Provider';

  @override
  String get provider_nit => 'NIT';

  @override
  String get provider_create => 'Create Provider';

  @override
  String get provider_found => 'Provider found and loaded.';

  @override
  String get provider_willBeCreated =>
      'New provider will be created with this NIT.';

  @override
  String get provider_nameIsRequired => 'Provider name is requested';

  @override
  String get provider_nitIsRequired => 'NIT is requested';

  @override
  String get provider_createdSuccessfully => 'Provider created successfully';

  @override
  String get provider_nitAlreadyExists =>
      'A provider with this NIT already exists';

  @override
  String get provider_creationError => 'Error creating provider';

  @override
  String get lotsTitle => 'Lots';

  @override
  String get lot => 'Lot';

  @override
  String get addLot => 'Add Lot';

  @override
  String get removeLot => 'Remove lot';

  @override
  String get lot_lotNumber => 'Lot number';

  @override
  String get lot_origin => 'Origin';

  @override
  String get lot_age => 'Age';

  @override
  String get lot_gender => 'Gender';

  @override
  String get lot_avgWeight => 'Avg. Weight (kg)';

  @override
  String get lot_pricePerKg => 'Price per Kg';

  @override
  String get lot_cattleCount => 'Count';

  @override
  String get lot_totalWeight => 'Total Weight';

  @override
  String get lot_totalValue => 'Total Value';

  @override
  String get lot_pricePerHead => 'Avg. Price per Head';

  @override
  String get lot_pricePerHeadRequired =>
      'Please enter the average price per head.';

  @override
  String get lot_pricePerHeadInvalid => 'Enter a valid average price per head.';

  @override
  String get lot_numberRequired => 'Please enter the lot number.';

  @override
  String get lot_duplicateLotNumber =>
      'Two or more lots have the same lot number.';

  @override
  String get lot_avgWeightRequired => 'Please enter the average weight (Kg).';

  @override
  String get lot_avgWeightInvalid =>
      'Enter a valid average weight, it must be greater than zero';

  @override
  String get lot_pricePerKgRequired => 'Please enter the price per kilo';

  @override
  String get lot_pricePerKgInvalid => 'Enter a valid price per kilo.';

  @override
  String get lot_cattleCountRequired => 'Please enter the cattle count.';

  @override
  String get lot_cattleCountInvalid =>
      'Enter a valid cattle count, it must be greater than zero';

  @override
  String get lot_totalWeightRequired => 'Please enter the total weight.';

  @override
  String get lot_totalWeightInvalid => 'Enter a valid total weight';

  @override
  String get lot_countAvWeightPriceKgRequired =>
      'Each lot must have cattle count, average weight and price per kg greater than zero.';

  @override
  String get lots_summaryAverageTitle => 'Average';

  @override
  String get lots_summaryTotalTitle => 'Total';

  @override
  String get addAnimalTitle => 'Add Animal';

  @override
  String get animalNumberLabel => 'Animal Number';

  @override
  String get weightLabel => 'Weight (kg)';

  @override
  String get trackerLabel => 'Tracker';

  @override
  String get eartagLabel => 'Eartag';

  @override
  String get applyButton => 'Apply';

  @override
  String get eventConfigTitle => 'Event Configuration';

  @override
  String get addEventDetail => 'Add Event';

  @override
  String get activeDetails => 'Active Events:';

  @override
  String get noActiveDetails => 'No active Events';

  @override
  String get deactivateTooltip => 'Deactivate';

  @override
  String get historyTitle => 'History:';

  @override
  String get noHistory => 'No history yet';

  @override
  String get reactivateTooltip => 'Reactivate';

  @override
  String onlyOneType(Object type) {
    return 'Only one event of type $type is allowed in this Massive Event.';
  }

  @override
  String brandAlreadyExists(Object brand) {
    return 'The brand \"$brand\" already exists in this Massive Event.';
  }

  @override
  String reactivatedInfo(Object name) {
    return '\"$name\" has been reactivated.';
  }

  @override
  String get eventTypeWeight => 'Weight';

  @override
  String get eventTypeCastration => 'Castration';

  @override
  String get eventTypeTracker => 'Assign Tracker';

  @override
  String get eventTypeEartag => 'Put Eartag';

  @override
  String get eventTypeMedication => 'Medication';

  @override
  String get eventTypeBrand => 'Brand Marking';

  @override
  String get medicationName => 'Name';

  @override
  String get medicationDosage => 'Dosage';

  @override
  String get medicationRoute => 'Application route';

  @override
  String get medicationLot => 'Manufacturing lot';

  @override
  String get selectBrand => 'Select a brand';

  @override
  String get createNewBrand => 'Create new brand';

  @override
  String get cancel => 'Cancel';

  @override
  String get add => 'Add';

  @override
  String get createNewBrandTitle => 'Create New Brand';

  @override
  String get brandName => 'Name';

  @override
  String get selectImage => 'Select image';

  @override
  String get imageRequired => 'Image is required';

  @override
  String get create => 'Create';

  @override
  String get noAnimals => 'No animals added yet';

  @override
  String get tableAnimal => 'Animal';

  @override
  String get tableWeight => 'Weight';

  @override
  String get tableTracker => 'Tracker';

  @override
  String get tableStatus => 'Status';

  @override
  String get simpleEventAdded => 'Detail successfully added';

  @override
  String get simpleEventError => 'An error occurred while adding detail';
}
