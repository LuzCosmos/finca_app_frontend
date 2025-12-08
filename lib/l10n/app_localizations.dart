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

  /// No description provided for @invalidValue.
  ///
  /// In en, this message translates to:
  /// **'Invalid value.'**
  String get invalidValue;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @numberFormat.
  ///
  /// In en, this message translates to:
  /// **'#,##0.##'**
  String get numberFormat;

  /// No description provided for @numberFormat_country.
  ///
  /// In en, this message translates to:
  /// **'en_US'**
  String get numberFormat_country;

  /// No description provided for @fixErrors.
  ///
  /// In en, this message translates to:
  /// **'Please fix the errors highlighted in red.'**
  String get fixErrors;

  /// No description provided for @error_savingObject.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred while saving.'**
  String get error_savingObject;

  /// Generic message for HTTP 400 errors.
  ///
  /// In en, this message translates to:
  /// **'The request is invalid. Please check the data and try again.'**
  String get error_badRequest;

  /// Shown when the user must log in again (HTTP 401).
  ///
  /// In en, this message translates to:
  /// **'Your session has expired or you do not have access. Please log in again.'**
  String get error_unauthorized;

  /// Authorization failed (HTTP 403).
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to perform this action.'**
  String get error_forbidden;

  /// Shown when a resource is not found (HTTP 404). {object} is a noun like 'Animal', 'Device', etc.
  ///
  /// In en, this message translates to:
  /// **'{object} not found.'**
  String error_notFound(Object object);

  /// HTTP 405.
  ///
  /// In en, this message translates to:
  /// **'This action is not allowed at the moment.'**
  String get error_methodNotAllowed;

  /// Conflict/duplicate (HTTP 409).
  ///
  /// In en, this message translates to:
  /// **'This item already exists.'**
  String get error_conflict;

  /// HTTP 412.
  ///
  /// In en, this message translates to:
  /// **'The conditions to perform this action are not met.'**
  String get error_preconditionFailed;

  /// Business/validation errors (HTTP 422).
  ///
  /// In en, this message translates to:
  /// **'Some data is invalid. Please correct it and try again.'**
  String get error_unprocessableEntity;

  /// Shown when the user tries to perform an action but the resource is locked, usually due to another ongoing process. (HTTP 423)
  ///
  /// In en, this message translates to:
  /// **'The resource is currently locked by another operation. Please try again later.'**
  String get error_locked;

  /// HTTP 429 rate limiting.
  ///
  /// In en, this message translates to:
  /// **'You have made too many requests. Please try again later.'**
  String get error_tooManyRequests;

  /// Network/connectivity issues.
  ///
  /// In en, this message translates to:
  /// **'Unable to connect to the server. Please check your internet connection or try again later.'**
  String get error_serverConnection;

  /// HTTP 5xx generic.
  ///
  /// In en, this message translates to:
  /// **'Internal server error. Please try again later.'**
  String get error_server;

  /// Fallback for unknown errors.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error has occurred.'**
  String get error_generic;

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

  /// No description provided for @purchase_date.
  ///
  /// In en, this message translates to:
  /// **'Purchase Date'**
  String get purchase_date;

  /// No description provided for @purchase_dateRequired.
  ///
  /// In en, this message translates to:
  /// **'You must select a purchase date.'**
  String get purchase_dateRequired;

  /// No description provided for @purchase_create.
  ///
  /// In en, this message translates to:
  /// **'Create Purchase'**
  String get purchase_create;

  /// No description provided for @purchase_saveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Purchase saved successfully.'**
  String get purchase_saveSuccess;

  /// No description provided for @purchase_saveError.
  ///
  /// In en, this message translates to:
  /// **'Failed to save purchase.'**
  String get purchase_saveError;

  /// No description provided for @cattlePurchase.
  ///
  /// In en, this message translates to:
  /// **'Cattle Purchase'**
  String get cattlePurchase;

  /// No description provided for @cp_error_noLots.
  ///
  /// In en, this message translates to:
  /// **'At least one lot is required'**
  String get cp_error_noLots;

  /// No description provided for @cp_error_providerRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select or create a provider.'**
  String get cp_error_providerRequired;

  /// No description provided for @provider.
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get provider;

  /// No description provided for @provider_nit.
  ///
  /// In en, this message translates to:
  /// **'NIT'**
  String get provider_nit;

  /// No description provided for @provider_create.
  ///
  /// In en, this message translates to:
  /// **'Create Provider'**
  String get provider_create;

  /// No description provided for @provider_found.
  ///
  /// In en, this message translates to:
  /// **'Provider found and loaded.'**
  String get provider_found;

  /// No description provided for @provider_willBeCreated.
  ///
  /// In en, this message translates to:
  /// **'New provider will be created with this NIT.'**
  String get provider_willBeCreated;

  /// No description provided for @provider_nameIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Provider name is requested'**
  String get provider_nameIsRequired;

  /// No description provided for @provider_nitIsRequired.
  ///
  /// In en, this message translates to:
  /// **'NIT is requested'**
  String get provider_nitIsRequired;

  /// No description provided for @provider_createdSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Provider created successfully'**
  String get provider_createdSuccessfully;

  /// No description provided for @provider_nitAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'A provider with this NIT already exists'**
  String get provider_nitAlreadyExists;

  /// No description provided for @provider_creationError.
  ///
  /// In en, this message translates to:
  /// **'Error creating provider'**
  String get provider_creationError;

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
  /// **'Count'**
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

  /// Label for the field where the user enters the average price per head (per cattle)
  ///
  /// In en, this message translates to:
  /// **'Avg. Price per Head'**
  String get lot_pricePerHead;

  /// Validation message when the average price per head is required
  ///
  /// In en, this message translates to:
  /// **'Please enter the average price per head.'**
  String get lot_pricePerHeadRequired;

  /// Validation message when the average price per head is invalid
  ///
  /// In en, this message translates to:
  /// **'Enter a valid average price per head.'**
  String get lot_pricePerHeadInvalid;

  /// No description provided for @lot_numberRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the lot number.'**
  String get lot_numberRequired;

  /// No description provided for @lot_duplicateLotNumber.
  ///
  /// In en, this message translates to:
  /// **'Two or more lots have the same lot number.'**
  String get lot_duplicateLotNumber;

  /// No description provided for @lot_avgWeightRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the average weight (Kg).'**
  String get lot_avgWeightRequired;

  /// No description provided for @lot_avgWeightInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid average weight, it must be greater than zero'**
  String get lot_avgWeightInvalid;

  /// No description provided for @lot_pricePerKgRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the price per kilo'**
  String get lot_pricePerKgRequired;

  /// No description provided for @lot_pricePerKgInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid price per kilo.'**
  String get lot_pricePerKgInvalid;

  /// No description provided for @lot_cattleCountRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the cattle count.'**
  String get lot_cattleCountRequired;

  /// No description provided for @lot_cattleCountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid cattle count, it must be greater than zero'**
  String get lot_cattleCountInvalid;

  /// No description provided for @lot_totalWeightRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the total weight.'**
  String get lot_totalWeightRequired;

  /// No description provided for @lot_totalWeightInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid total weight'**
  String get lot_totalWeightInvalid;

  /// No description provided for @lot_countAvWeightPriceKgRequired.
  ///
  /// In en, this message translates to:
  /// **'Each lot must have cattle count, average weight and price per kg greater than zero.'**
  String get lot_countAvWeightPriceKgRequired;

  /// Label used in the lots section summary row for averages
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get lots_summaryAverageTitle;

  /// Label used in the lots section summary row for totals
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get lots_summaryTotalTitle;

  /// No description provided for @addAnimalTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Animal'**
  String get addAnimalTitle;

  /// No description provided for @animalNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Animal Number'**
  String get animalNumberLabel;

  /// No description provided for @weightLabel.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weightLabel;

  /// No description provided for @trackerLabel.
  ///
  /// In en, this message translates to:
  /// **'Tracker'**
  String get trackerLabel;

  /// No description provided for @eartagLabel.
  ///
  /// In en, this message translates to:
  /// **'Eartag'**
  String get eartagLabel;

  /// No description provided for @applyButton.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get applyButton;

  /// No description provided for @eventConfigTitle.
  ///
  /// In en, this message translates to:
  /// **'Event Configuration'**
  String get eventConfigTitle;

  /// No description provided for @eventDate.
  ///
  /// In en, this message translates to:
  /// **'Event Date'**
  String get eventDate;

  /// No description provided for @eventFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get eventFinish;

  /// No description provided for @addEventDetail.
  ///
  /// In en, this message translates to:
  /// **'Add Event'**
  String get addEventDetail;

  /// No description provided for @activeDetails.
  ///
  /// In en, this message translates to:
  /// **'Active Events:'**
  String get activeDetails;

  /// No description provided for @noActiveDetails.
  ///
  /// In en, this message translates to:
  /// **'No active Events'**
  String get noActiveDetails;

  /// No description provided for @deactivateTooltip.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get deactivateTooltip;

  /// No description provided for @inactiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Inactive:'**
  String get inactiveTitle;

  /// No description provided for @noInactive.
  ///
  /// In en, this message translates to:
  /// **'No inactive Events'**
  String get noInactive;

  /// No description provided for @reactivateTooltip.
  ///
  /// In en, this message translates to:
  /// **'Reactivate'**
  String get reactivateTooltip;

  /// No description provided for @onlyOneType.
  ///
  /// In en, this message translates to:
  /// **'Only one event of type {type} is allowed in this Massive Event.'**
  String onlyOneType(Object type);

  /// No description provided for @brandAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'The brand \"{brand}\" already exists in this Massive Event.'**
  String brandAlreadyExists(Object brand);

  /// No description provided for @reactivatedInfo.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" has been reactivated.'**
  String reactivatedInfo(Object name);

  /// No description provided for @eventTypeWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get eventTypeWeight;

  /// No description provided for @eventTypeCastration.
  ///
  /// In en, this message translates to:
  /// **'Castration'**
  String get eventTypeCastration;

  /// No description provided for @eventTypeTracker.
  ///
  /// In en, this message translates to:
  /// **'Assign Tracker'**
  String get eventTypeTracker;

  /// No description provided for @eventTypeEartag.
  ///
  /// In en, this message translates to:
  /// **'Put Eartag'**
  String get eventTypeEartag;

  /// No description provided for @eventTypeMedication.
  ///
  /// In en, this message translates to:
  /// **'Medication'**
  String get eventTypeMedication;

  /// No description provided for @eventTypeBrand.
  ///
  /// In en, this message translates to:
  /// **'Brand Marking'**
  String get eventTypeBrand;

  /// No description provided for @medicationName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get medicationName;

  /// No description provided for @medicationDosage.
  ///
  /// In en, this message translates to:
  /// **'Dosage'**
  String get medicationDosage;

  /// No description provided for @medicationRoute.
  ///
  /// In en, this message translates to:
  /// **'Application route'**
  String get medicationRoute;

  /// No description provided for @medicationLot.
  ///
  /// In en, this message translates to:
  /// **'Manufacturing lot'**
  String get medicationLot;

  /// No description provided for @selectBrand.
  ///
  /// In en, this message translates to:
  /// **'Select a brand'**
  String get selectBrand;

  /// No description provided for @createNewBrand.
  ///
  /// In en, this message translates to:
  /// **'Create new brand'**
  String get createNewBrand;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @createNewBrandTitle.
  ///
  /// In en, this message translates to:
  /// **'Create New Brand'**
  String get createNewBrandTitle;

  /// No description provided for @brandName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get brandName;

  /// No description provided for @selectImage.
  ///
  /// In en, this message translates to:
  /// **'Select image'**
  String get selectImage;

  /// No description provided for @imageRequired.
  ///
  /// In en, this message translates to:
  /// **'Image is required'**
  String get imageRequired;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @noAnimals.
  ///
  /// In en, this message translates to:
  /// **'No animals added yet'**
  String get noAnimals;

  /// No description provided for @tableAnimal.
  ///
  /// In en, this message translates to:
  /// **'Animal'**
  String get tableAnimal;

  /// No description provided for @tableWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get tableWeight;

  /// No description provided for @tableTracker.
  ///
  /// In en, this message translates to:
  /// **'Tracker'**
  String get tableTracker;

  /// No description provided for @tableEartag.
  ///
  /// In en, this message translates to:
  /// **'Eartag'**
  String get tableEartag;

  /// No description provided for @tableBrand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get tableBrand;

  /// No description provided for @tableMedication.
  ///
  /// In en, this message translates to:
  /// **'Medication'**
  String get tableMedication;

  /// No description provided for @tableCastration.
  ///
  /// In en, this message translates to:
  /// **'Castrated'**
  String get tableCastration;

  /// No description provided for @tableSynced.
  ///
  /// In en, this message translates to:
  /// **'Synced'**
  String get tableSynced;

  /// No description provided for @simpleEventAdded.
  ///
  /// In en, this message translates to:
  /// **'Detail successfully added'**
  String get simpleEventAdded;

  /// No description provided for @simpleEventError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while adding detail'**
  String get simpleEventError;

  /// No description provided for @simpleEventApplied.
  ///
  /// In en, this message translates to:
  /// **'Active events applied to number {cattleNumber}'**
  String simpleEventApplied(Object cattleNumber);

  /// No description provided for @applyAtLeastOneSimpleEvent.
  ///
  /// In en, this message translates to:
  /// **'Apply at least one event.'**
  String get applyAtLeastOneSimpleEvent;

  /// No description provided for @eventsApplicationNotice.
  ///
  /// In en, this message translates to:
  /// **'All events have been applied. If any event appears unapplied, please make sure the required information is filled in.'**
  String get eventsApplicationNotice;

  /// Shown when attempting to close a massive event but none of its simple events were applied to any animal.
  ///
  /// In en, this message translates to:
  /// **'The massive event cannot be closed because no simple events have been applied to any animal.'**
  String get error_noSimpleEventsApplied;

  /// Shown when the user tries to close or modify a massive event that has already been closed.
  ///
  /// In en, this message translates to:
  /// **'This massive event is already closed and cannot be modified.'**
  String get error_massiveEventAlreadyClosed;

  /// Shown when a massive event has been finished successfully.
  ///
  /// In en, this message translates to:
  /// **'The massive event was successfully finished.'**
  String get event_finishSuccess;

  /// No description provided for @sales_title.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get sales_title;

  /// No description provided for @sales_addSale.
  ///
  /// In en, this message translates to:
  /// **'Add Sale'**
  String get sales_addSale;

  /// No description provided for @sales_searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search sales...'**
  String get sales_searchPlaceholder;

  /// No description provided for @sales_dateRange.
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get sales_dateRange;

  /// No description provided for @sales_clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get sales_clearFilters;

  /// No description provided for @sales_rowsPerPage.
  ///
  /// In en, this message translates to:
  /// **'Rows per page:'**
  String get sales_rowsPerPage;

  /// No description provided for @sales_refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get sales_refresh;

  /// No description provided for @sales_noData.
  ///
  /// In en, this message translates to:
  /// **'No sales data available'**
  String get sales_noData;

  /// No description provided for @sales_noDataFiltered.
  ///
  /// In en, this message translates to:
  /// **'No sales found with the current filters'**
  String get sales_noDataFiltered;

  /// No description provided for @sales_tryAdjustFilters.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters'**
  String get sales_tryAdjustFilters;

  /// No description provided for @sales_createFirstSale.
  ///
  /// In en, this message translates to:
  /// **'Create your first sale to get started'**
  String get sales_createFirstSale;

  /// No description provided for @sales_date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get sales_date;

  /// No description provided for @sales_buyer.
  ///
  /// In en, this message translates to:
  /// **'Buyer'**
  String get sales_buyer;

  /// No description provided for @sales_items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get sales_items;

  /// No description provided for @sales_weight.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get sales_weight;

  /// No description provided for @sales_amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get sales_amount;

  /// No description provided for @sales_actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get sales_actions;

  /// No description provided for @sales_viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get sales_viewDetails;

  /// No description provided for @sales_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get sales_edit;

  /// No description provided for @sales_page.
  ///
  /// In en, this message translates to:
  /// **'Page'**
  String get sales_page;

  /// No description provided for @sales_of.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get sales_of;

  /// No description provided for @sales_showing.
  ///
  /// In en, this message translates to:
  /// **'Showing'**
  String get sales_showing;

  /// No description provided for @sales_editSale.
  ///
  /// In en, this message translates to:
  /// **'Edit Sale'**
  String get sales_editSale;

  /// No description provided for @sales_saleDetails.
  ///
  /// In en, this message translates to:
  /// **'Sale Details'**
  String get sales_saleDetails;

  /// No description provided for @sales_transactionDate.
  ///
  /// In en, this message translates to:
  /// **'Transaction Date'**
  String get sales_transactionDate;

  /// No description provided for @sales_totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get sales_totalAmount;

  /// No description provided for @sales_totalWeight.
  ///
  /// In en, this message translates to:
  /// **'Total Weight'**
  String get sales_totalWeight;

  /// No description provided for @sales_animals.
  ///
  /// In en, this message translates to:
  /// **'Animals'**
  String get sales_animals;

  /// No description provided for @sales_notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get sales_notes;

  /// No description provided for @sales_cattleList.
  ///
  /// In en, this message translates to:
  /// **'Cattle List'**
  String get sales_cattleList;

  /// No description provided for @sales_noDetails.
  ///
  /// In en, this message translates to:
  /// **'No details available.'**
  String get sales_noDetails;

  /// No description provided for @sales_cattleId.
  ///
  /// In en, this message translates to:
  /// **'Cattle ID'**
  String get sales_cattleId;

  /// No description provided for @sales_price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get sales_price;

  /// No description provided for @sales_close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get sales_close;

  /// No description provided for @sales_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get sales_cancel;

  /// No description provided for @sales_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get sales_save;

  /// No description provided for @sales_errorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading sales'**
  String get sales_errorLoading;

  /// No description provided for @sales_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get sales_retry;

  /// No description provided for @sales_previousPage.
  ///
  /// In en, this message translates to:
  /// **'Previous Page'**
  String get sales_previousPage;

  /// No description provided for @sales_nextPage.
  ///
  /// In en, this message translates to:
  /// **'Next Page'**
  String get sales_nextPage;
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
