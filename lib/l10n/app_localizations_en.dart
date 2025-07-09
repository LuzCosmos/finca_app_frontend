// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get testMedium => 'Test in English';

  @override
  String get general_appTitle => 'Farm App';

  @override
  String get appTitle => 'Finca App';

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
  String get cp_provider => 'Provider';

  @override
  String get cp_nit => 'NIT';

  @override
  String get cp_purchaseDate => 'Purchase Date';

  @override
  String get cp_addLot => 'Add Lot';

  @override
  String get cp_lot => 'Lot';

  @override
  String get cp_origin => 'Origin';

  @override
  String get cp_quantity => 'Quantity';

  @override
  String get cp_age => 'Age';

  @override
  String get cp_gender => 'Gender';

  @override
  String get cp_avgWeight => 'Avg. Weight (kg)';

  @override
  String get cp_totalWeight => 'Total Weight';

  @override
  String get cp_pricePerKg => 'Price per Kg';

  @override
  String get cp_totalValue => 'Total Value';

  @override
  String get cp_totalCattle => 'Total Cattle';

  @override
  String get cp_createPurchase => 'Create Purchase';

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
}
