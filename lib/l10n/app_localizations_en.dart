// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Finca App';

  @override
  String get fieldRequired => 'This field is mandatory';

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
  String get cattlePurchase => 'Cattle Purchase';

  @override
  String get purchaseLotCountError =>
      'The cattle count must be greater than 0.';

  @override
  String get cp_purchaseDate => 'Purchase Date';

  @override
  String get cp_createPurchase => 'Create Purchase';

  @override
  String get cp_errors_noLots => 'At least one lot is required';

  @override
  String get cp_errors_cattleCountRequired =>
      'Cattle quantity must be greater than 0';

  @override
  String get purchase_provider_required => 'Please select a provider.';

  @override
  String get purchase_no_valid_lots => 'At least one valid lot is required.';

  @override
  String get purchase_save_success => 'Purchase saved successfully.';

  @override
  String get purchase_save_error => 'Failed to save purchase.';

  @override
  String get cp_provider => 'Provider';

  @override
  String get cp_nit => 'NIT';

  @override
  String get cp_createProvider => 'Create Provider';

  @override
  String get cp_providerFound => 'Provider found and loaded.';

  @override
  String get cp_providerWillBeCreated =>
      'New provider will be created with this NIT.';

  @override
  String get cp_providerIsRequired => 'Provider name is requested';

  @override
  String get cp_nitIsRequired => 'NIT is requested';

  @override
  String get cp_providerCreatedSuccessfully => 'Provider created successfully';

  @override
  String get cp_providerNitAlreadyExists =>
      'A provider with this NIT already exists';

  @override
  String get cp_providerCreationError => 'Error creating provider';

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
  String get lot_cattleCount => 'Cattle count';

  @override
  String get lot_totalWeight => 'Total Weight';

  @override
  String get lot_totalValue => 'Total Value';

  @override
  String get lot_cattleCountRequired => 'Please enter the number of cattle';

  @override
  String get lot_totalWeightRequired => 'Please enter the total weight';

  @override
  String get lot_pricePerKgRequired => 'Please enter the price per kilo';

  @override
  String get lot_cattleCountInvalid => 'Enter a valid cattle count';

  @override
  String get lot_totalWeightInvalid => 'Enter a valid weight';

  @override
  String get lot_pricePerKgInvalid => 'Enter a valid price per kilo';

  @override
  String get lotRequired => 'Please enter the lot number';
}
