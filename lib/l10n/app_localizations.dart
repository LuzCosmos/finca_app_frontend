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

  /// No description provided for @testMedium.
  ///
  /// In en, this message translates to:
  /// **'Test in English'**
  String get testMedium;

  /// Application Title shown in the HomePage
  ///
  /// In en, this message translates to:
  /// **'Farm App'**
  String get general_appTitle;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Finca App'**
  String get appTitle;

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

  /// No description provided for @cp_purchaseDate.
  ///
  /// In en, this message translates to:
  /// **'Purchase Date'**
  String get cp_purchaseDate;

  /// No description provided for @cp_addLot.
  ///
  /// In en, this message translates to:
  /// **'Add Lot'**
  String get cp_addLot;

  /// No description provided for @cp_lot.
  ///
  /// In en, this message translates to:
  /// **'Lot'**
  String get cp_lot;

  /// No description provided for @cp_origin.
  ///
  /// In en, this message translates to:
  /// **'Origin'**
  String get cp_origin;

  /// No description provided for @cp_quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get cp_quantity;

  /// No description provided for @cp_age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get cp_age;

  /// No description provided for @cp_gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get cp_gender;

  /// No description provided for @cp_avgWeight.
  ///
  /// In en, this message translates to:
  /// **'Avg. Weight (kg)'**
  String get cp_avgWeight;

  /// No description provided for @cp_totalWeight.
  ///
  /// In en, this message translates to:
  /// **'Total Weight'**
  String get cp_totalWeight;

  /// No description provided for @cp_pricePerKg.
  ///
  /// In en, this message translates to:
  /// **'Price per Kg'**
  String get cp_pricePerKg;

  /// No description provided for @cp_totalValue.
  ///
  /// In en, this message translates to:
  /// **'Total Value'**
  String get cp_totalValue;

  /// No description provided for @cp_totalCattle.
  ///
  /// In en, this message translates to:
  /// **'Total Cattle'**
  String get cp_totalCattle;

  /// No description provided for @cp_createPurchase.
  ///
  /// In en, this message translates to:
  /// **'Create Purchase'**
  String get cp_createPurchase;

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
