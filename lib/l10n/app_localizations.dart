import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// Application Title shown in the bar
  ///
  /// In en, this message translates to:
  /// **'Finca App'**
  String get appTitle;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is mandatory'**
  String get fieldRequired;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @login_username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get login_username;

  /// No description provided for @login_usernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your username'**
  String get login_usernameRequired;

  /// No description provided for @login_password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get login_password;

  /// No description provided for @login_passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get login_passwordRequired;

  /// No description provided for @login_company.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get login_company;

  /// No description provided for @login_login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login_login;

  /// No description provided for @login_loginError.
  ///
  /// In en, this message translates to:
  /// **'Login failed, please try again'**
  String get login_loginError;

  /// No description provided for @login_invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Incorrect credentials. Please try again.'**
  String get login_invalidCredentials;

  /// No description provided for @login_unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again later.'**
  String get login_unexpectedError;

  /// No description provided for @home_title.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home_title;

  /// No description provided for @home_purchase.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get home_purchase;

  /// No description provided for @home_purchaseReception.
  ///
  /// In en, this message translates to:
  /// **'Purchase Reception'**
  String get home_purchaseReception;

  /// No description provided for @home_massiveEvent.
  ///
  /// In en, this message translates to:
  /// **'Massive Event'**
  String get home_massiveEvent;

  /// No description provided for @home_sale.
  ///
  /// In en, this message translates to:
  /// **'Sale'**
  String get home_sale;

  /// No description provided for @cattlePurchase.
  ///
  /// In en, this message translates to:
  /// **'Cattle Purchase'**
  String get cattlePurchase;

  /// No description provided for @purchaseLotCountError.
  ///
  /// In en, this message translates to:
  /// **'The cattle count must be greater than 0.'**
  String get purchaseLotCountError;

  /// No description provided for @cp_purchaseDate.
  ///
  /// In en, this message translates to:
  /// **'Purchase Date'**
  String get cp_purchaseDate;

  /// No description provided for @cp_createPurchase.
  ///
  /// In en, this message translates to:
  /// **'Create Purchase'**
  String get cp_createPurchase;

  /// No description provided for @cp_errors_noLots.
  ///
  /// In en, this message translates to:
  /// **'At least one lot is required'**
  String get cp_errors_noLots;

  /// No description provided for @cp_errors_cattleCountRequired.
  ///
  /// In en, this message translates to:
  /// **'Cattle quantity must be greater than 0'**
  String get cp_errors_cattleCountRequired;

  /// No description provided for @purchase_provider_required.
  ///
  /// In en, this message translates to:
  /// **'Please select a provider.'**
  String get purchase_provider_required;

  /// No description provided for @purchase_no_valid_lots.
  ///
  /// In en, this message translates to:
  /// **'At least one valid lot is required.'**
  String get purchase_no_valid_lots;

  /// No description provided for @purchase_save_success.
  ///
  /// In en, this message translates to:
  /// **'Purchase saved successfully.'**
  String get purchase_save_success;

  /// No description provided for @purchase_save_error.
  ///
  /// In en, this message translates to:
  /// **'Failed to save purchase.'**
  String get purchase_save_error;

  /// No description provided for @cp_provider.
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get cp_provider;

  /// No description provided for @cp_nit.
  ///
  /// In en, this message translates to:
  /// **'NIT'**
  String get cp_nit;

  /// No description provided for @cp_createProvider.
  ///
  /// In en, this message translates to:
  /// **'Create Provider'**
  String get cp_createProvider;

  /// No description provided for @cp_providerFound.
  ///
  /// In en, this message translates to:
  /// **'Provider found and loaded.'**
  String get cp_providerFound;

  /// No description provided for @cp_providerWillBeCreated.
  ///
  /// In en, this message translates to:
  /// **'New provider will be created with this NIT.'**
  String get cp_providerWillBeCreated;

  /// No description provided for @cp_providerIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Provider name is requested'**
  String get cp_providerIsRequired;

  /// No description provided for @cp_nitIsRequired.
  ///
  /// In en, this message translates to:
  /// **'NIT is requested'**
  String get cp_nitIsRequired;

  /// No description provided for @cp_providerCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Provider created successfully'**
  String get cp_providerCreatedSuccessfully;

  /// No description provided for @cp_providerNitAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'A provider with this NIT already exists'**
  String get cp_providerNitAlreadyExists;

  /// No description provided for @cp_providerCreationError.
  ///
  /// In en, this message translates to:
  /// **'Error creating provider'**
  String get cp_providerCreationError;

  /// No description provided for @lotsTitle.
  ///
  /// In en, this message translates to:
  /// **'Lots'**
  String get lotsTitle;

  /// No description provided for @lot.
  ///
  /// In en, this message translates to:
  /// **'Lot'**
  String get lot;

  /// No description provided for @addLot.
  ///
  /// In en, this message translates to:
  /// **'Add Lot'**
  String get addLot;

  /// No description provided for @removeLot.
  ///
  /// In en, this message translates to:
  /// **'Remove lot'**
  String get removeLot;

  /// No description provided for @lot_lotNumber.
  ///
  /// In en, this message translates to:
  /// **'Lot number'**
  String get lot_lotNumber;

  /// No description provided for @lot_origin.
  ///
  /// In en, this message translates to:
  /// **'Origin'**
  String get lot_origin;

  /// No description provided for @lot_age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get lot_age;

  /// No description provided for @lot_gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get lot_gender;

  /// No description provided for @lot_avgWeight.
  ///
  /// In en, this message translates to:
  /// **'Avg. Weight (kg)'**
  String get lot_avgWeight;

  /// No description provided for @lot_pricePerKg.
  ///
  /// In en, this message translates to:
  /// **'Price per Kg'**
  String get lot_pricePerKg;

  /// No description provided for @lot_cattleCount.
  ///
  /// In en, this message translates to:
  /// **'Cattle count'**
  String get lot_cattleCount;

  /// No description provided for @lot_totalWeight.
  ///
  /// In en, this message translates to:
  /// **'Total Weight'**
  String get lot_totalWeight;

  /// No description provided for @lot_totalValue.
  ///
  /// In en, this message translates to:
  /// **'Total Value'**
  String get lot_totalValue;

  /// No description provided for @lot_cattleCountRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the number of cattle'**
  String get lot_cattleCountRequired;

  /// No description provided for @lot_totalWeightRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the total weight'**
  String get lot_totalWeightRequired;

  /// No description provided for @lot_pricePerKgRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the price per kilo'**
  String get lot_pricePerKgRequired;

  /// No description provided for @lot_cattleCountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid cattle count'**
  String get lot_cattleCountInvalid;

  /// No description provided for @lot_totalWeightInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid weight'**
  String get lot_totalWeightInvalid;

  /// No description provided for @lot_pricePerKgInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid price per kilo'**
  String get lot_pricePerKgInvalid;

  /// No description provided for @lotRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the lot number'**
  String get lotRequired;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
