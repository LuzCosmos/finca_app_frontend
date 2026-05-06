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

  /// Application title displayed in the bar
  ///
  /// In en, this message translates to:
  /// **'Finca App'**
  String get appTitle;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @createSomething.
  ///
  /// In en, this message translates to:
  /// **'Create {object}'**
  String createSomething(Object object);

  /// No description provided for @createNewSomething.
  ///
  /// In en, this message translates to:
  /// **'Create new {object}'**
  String createNewSomething(Object object);

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @addSomething.
  ///
  /// In en, this message translates to:
  /// **'Add {object}'**
  String addSomething(Object object);

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @editSomething.
  ///
  /// In en, this message translates to:
  /// **'Edit {object}'**
  String editSomething(Object object);

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @updateSomething.
  ///
  /// In en, this message translates to:
  /// **'Update {object}'**
  String updateSomething(Object object);

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteSomething.
  ///
  /// In en, this message translates to:
  /// **'Delete {object}'**
  String deleteSomething(Object object);

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @removeSomething.
  ///
  /// In en, this message translates to:
  /// **'Remove {object}'**
  String removeSomething(Object object);

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saveSomething.
  ///
  /// In en, this message translates to:
  /// **'Save {object}'**
  String saveSomething(Object object);

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @selectSomething.
  ///
  /// In en, this message translates to:
  /// **'Select {object}'**
  String selectSomething(Object object);

  /// No description provided for @assign.
  ///
  /// In en, this message translates to:
  /// **'Assign'**
  String get assign;

  /// No description provided for @assignSomething.
  ///
  /// In en, this message translates to:
  /// **'Assign {object}'**
  String assignSomething(Object object);

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @receive.
  ///
  /// In en, this message translates to:
  /// **'Receive'**
  String get receive;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @print.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get print;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @l10n_of.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get l10n_of;

  /// No description provided for @page.
  ///
  /// In en, this message translates to:
  /// **'Page'**
  String get page;

  /// No description provided for @results.
  ///
  /// In en, this message translates to:
  /// **'results'**
  String get results;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @rowsPerPage.
  ///
  /// In en, this message translates to:
  /// **'Rows per page'**
  String get rowsPerPage;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required.'**
  String get fieldRequired;

  /// No description provided for @invalidValue.
  ///
  /// In en, this message translates to:
  /// **'Invalid value.'**
  String get invalidValue;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

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

  /// No description provided for @notApplied.
  ///
  /// In en, this message translates to:
  /// **'Not applied'**
  String get notApplied;

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

  /// No description provided for @error_readingObject.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred while reading.'**
  String get error_readingObject;

  /// No description provided for @error_savingObject.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred while saving.'**
  String get error_savingObject;

  /// Generic message for HTTP 400 errors.
  ///
  /// In en, this message translates to:
  /// **'The request is not valid. Check the data and try again.'**
  String get error_badRequest;

  /// Shown when the user must log in (HTTP 401).
  ///
  /// In en, this message translates to:
  /// **'Your session has expired or you do not have access. Please log in again.'**
  String get error_unauthorized;

  /// Authorization failure (HTTP 403).
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to perform this action.'**
  String get error_forbidden;

  /// Resource not found (HTTP 404). {object} is a noun such as 'Animal', 'Device', etc.
  ///
  /// In en, this message translates to:
  /// **'{object} was not found.'**
  String error_notFound(Object object);

  /// HTTP 405.
  ///
  /// In en, this message translates to:
  /// **'This action is not allowed at this time.'**
  String get error_methodNotAllowed;

  /// Conflict/duplicate (HTTP 409).
  ///
  /// In en, this message translates to:
  /// **'The record already exists.'**
  String get error_conflict;

  /// HTTP 412.
  ///
  /// In en, this message translates to:
  /// **'The conditions to perform this action are not met.'**
  String get error_preconditionFailed;

  /// Business/validation errors (HTTP 422).
  ///
  /// In en, this message translates to:
  /// **'Some data is not valid. Please correct it and try again.'**
  String get error_unprocessableEntity;

  /// Shown when the user attempts to perform an action but the resource is locked, usually by another running process.
  ///
  /// In en, this message translates to:
  /// **'The resource is locked by another operation in progress. Try again later.'**
  String get error_locked;

  /// Request limit (HTTP 429).
  ///
  /// In en, this message translates to:
  /// **'You have made too many requests. Try again later.'**
  String get error_tooManyRequests;

  /// Network/connectivity issues.
  ///
  /// In en, this message translates to:
  /// **'Could not connect to the server. Check your internet connection or try again later.'**
  String get error_serverConnection;

  /// Generic HTTP 5xx.
  ///
  /// In en, this message translates to:
  /// **'Internal server error. Try later.'**
  String get error_server;

  /// Fallback for unknown errors.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error has occurred.'**
  String get error_generic;

  /// Error when the cattle is not active.
  ///
  /// In en, this message translates to:
  /// **'The cattle is not active.'**
  String get error_cattleIsNotActive;

  /// Shown when editing a SOLD cattle but no sale detail exists.
  ///
  /// In en, this message translates to:
  /// **'Sold cattle must have an associated sale detail.'**
  String get error_soldCattleMissingSaleDetail;

  /// Shown when trying to update sale fields on non-SOLD cattle.
  ///
  /// In en, this message translates to:
  /// **'Sale price and weight can only be updated for cattle in SOLD status.'**
  String get error_saleFieldsOnlyForSoldCattle;

  /// Validation error for sale price field.
  ///
  /// In en, this message translates to:
  /// **'Invalid sale price.'**
  String get error_invalidSalePrice;

  /// Validation error for sale weight field.
  ///
  /// In en, this message translates to:
  /// **'Invalid sale weight.'**
  String get error_invalidSaleWeight;

  /// Generic error when saving a field in the cattle grid. {error} is the technical message.
  ///
  /// In en, this message translates to:
  /// **'Error saving: {error}'**
  String error_savingField(Object error);

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @noDataSomething.
  ///
  /// In en, this message translates to:
  /// **'No {object} data available'**
  String noDataSomething(Object object);

  /// No description provided for @noDataFiltered.
  ///
  /// In en, this message translates to:
  /// **'No {object} found with the current filters'**
  String noDataFiltered(Object object);

  /// No description provided for @tryAdjustFilters.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters'**
  String get tryAdjustFilters;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get clearFilters;

  /// No description provided for @home_title.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home_title;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @dateSomething.
  ///
  /// In en, this message translates to:
  /// **'{object} Date'**
  String dateSomething(Object object);

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @listSomething.
  ///
  /// In en, this message translates to:
  /// **'{object} List'**
  String listSomething(Object object);

  /// No description provided for @cattle.
  ///
  /// In en, this message translates to:
  /// **'Cattle'**
  String get cattle;

  /// No description provided for @cattles.
  ///
  /// In en, this message translates to:
  /// **'Cattle'**
  String get cattles;

  /// No description provided for @animal.
  ///
  /// In en, this message translates to:
  /// **'Animal'**
  String get animal;

  /// No description provided for @animals.
  ///
  /// In en, this message translates to:
  /// **'Animals'**
  String get animals;

  /// No description provided for @lot.
  ///
  /// In en, this message translates to:
  /// **'Lot'**
  String get lot;

  /// No description provided for @lots.
  ///
  /// In en, this message translates to:
  /// **'Lots'**
  String get lots;

  /// No description provided for @withoutLot.
  ///
  /// In en, this message translates to:
  /// **'Without lot'**
  String get withoutLot;

  /// No description provided for @purchase.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get purchase;

  /// No description provided for @purchases.
  ///
  /// In en, this message translates to:
  /// **'Purchases'**
  String get purchases;

  /// No description provided for @cattlePurchase.
  ///
  /// In en, this message translates to:
  /// **'Cattle Purchase'**
  String get cattlePurchase;

  /// No description provided for @massiveEvent.
  ///
  /// In en, this message translates to:
  /// **'Massive Event'**
  String get massiveEvent;

  /// No description provided for @massiveEvents.
  ///
  /// In en, this message translates to:
  /// **'Massive Events'**
  String get massiveEvents;

  /// Shown on mobile when a massive event exists locally but is not yet synced.
  ///
  /// In en, this message translates to:
  /// **'This event is saved on the device and is pending synchronization with the server.'**
  String get massiveEventPendingSync;

  /// Button label to trigger manual data sync on mobile.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get syncNow;

  /// No description provided for @event.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get event;

  /// No description provided for @events.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// No description provided for @sale.
  ///
  /// In en, this message translates to:
  /// **'Sale'**
  String get sale;

  /// No description provided for @sales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get sales;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @roles.
  ///
  /// In en, this message translates to:
  /// **'Roles'**
  String get roles;

  /// No description provided for @brand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get brand;

  /// No description provided for @brands.
  ///
  /// In en, this message translates to:
  /// **'Brands'**
  String get brands;

  /// No description provided for @provider.
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get provider;

  /// No description provided for @providers.
  ///
  /// In en, this message translates to:
  /// **'Providers'**
  String get providers;

  /// No description provided for @buyer.
  ///
  /// In en, this message translates to:
  /// **'Buyer'**
  String get buyer;

  /// No description provided for @buyers.
  ///
  /// In en, this message translates to:
  /// **'Buyers'**
  String get buyers;

  /// No description provided for @transporter.
  ///
  /// In en, this message translates to:
  /// **'Transporter'**
  String get transporter;

  /// No description provided for @transporters.
  ///
  /// In en, this message translates to:
  /// **'Transporters'**
  String get transporters;

  /// No description provided for @purchaseReception.
  ///
  /// In en, this message translates to:
  /// **'Purchase Reception'**
  String get purchaseReception;

  /// No description provided for @reception.
  ///
  /// In en, this message translates to:
  /// **'Reception'**
  String get reception;

  /// No description provided for @cattleStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get cattleStatusActive;

  /// No description provided for @cattleStatusSold.
  ///
  /// In en, this message translates to:
  /// **'Sold'**
  String get cattleStatusSold;

  /// No description provided for @cattleStatusDead.
  ///
  /// In en, this message translates to:
  /// **'Dead'**
  String get cattleStatusDead;

  /// No description provided for @cattleStatusLost.
  ///
  /// In en, this message translates to:
  /// **'Lost'**
  String get cattleStatusLost;

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
  /// **'Apply Eartag'**
  String get eventTypeEartag;

  /// No description provided for @eventTypeMedication.
  ///
  /// In en, this message translates to:
  /// **'Medication'**
  String get eventTypeMedication;

  /// No description provided for @eventTypeBrand.
  ///
  /// In en, this message translates to:
  /// **'Branding'**
  String get eventTypeBrand;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @colors.
  ///
  /// In en, this message translates to:
  /// **'Colors'**
  String get colors;

  /// No description provided for @colorBlack.
  ///
  /// In en, this message translates to:
  /// **'Black'**
  String get colorBlack;

  /// No description provided for @colorWhite.
  ///
  /// In en, this message translates to:
  /// **'White'**
  String get colorWhite;

  /// No description provided for @colorBrown.
  ///
  /// In en, this message translates to:
  /// **'Brown'**
  String get colorBrown;

  /// No description provided for @colorBlackBrown.
  ///
  /// In en, this message translates to:
  /// **'Black-Brown'**
  String get colorBlackBrown;

  /// No description provided for @colorLightBrown.
  ///
  /// In en, this message translates to:
  /// **'Light Brown'**
  String get colorLightBrown;

  /// No description provided for @colorGrey.
  ///
  /// In en, this message translates to:
  /// **'Grey'**
  String get colorGrey;

  /// No description provided for @characteristic.
  ///
  /// In en, this message translates to:
  /// **'Characteristic'**
  String get characteristic;

  /// No description provided for @characteristics.
  ///
  /// In en, this message translates to:
  /// **'Characteristics'**
  String get characteristics;

  /// No description provided for @charBlackBelly.
  ///
  /// In en, this message translates to:
  /// **'Black Belly'**
  String get charBlackBelly;

  /// No description provided for @charWhiteBelly.
  ///
  /// In en, this message translates to:
  /// **'White Belly'**
  String get charWhiteBelly;

  /// No description provided for @charBrownBelly.
  ///
  /// In en, this message translates to:
  /// **'Brown Belly'**
  String get charBrownBelly;

  /// No description provided for @charLightBrownBelly.
  ///
  /// In en, this message translates to:
  /// **'Light Brown Belly'**
  String get charLightBrownBelly;

  /// No description provided for @charGreyBelly.
  ///
  /// In en, this message translates to:
  /// **'Grey Belly'**
  String get charGreyBelly;

  /// No description provided for @charBlackHead.
  ///
  /// In en, this message translates to:
  /// **'Black Head'**
  String get charBlackHead;

  /// No description provided for @charWhiteHead.
  ///
  /// In en, this message translates to:
  /// **'White Head'**
  String get charWhiteHead;

  /// No description provided for @charBrownHead.
  ///
  /// In en, this message translates to:
  /// **'Brown Head'**
  String get charBrownHead;

  /// No description provided for @charLightBrownHead.
  ///
  /// In en, this message translates to:
  /// **'Light Brown Head'**
  String get charLightBrownHead;

  /// No description provided for @charGreyHead.
  ///
  /// In en, this message translates to:
  /// **'Grey Head'**
  String get charGreyHead;

  /// No description provided for @charBlackHalfHead.
  ///
  /// In en, this message translates to:
  /// **'Half Black Head'**
  String get charBlackHalfHead;

  /// No description provided for @charWhiteHalfHead.
  ///
  /// In en, this message translates to:
  /// **'Half White Head'**
  String get charWhiteHalfHead;

  /// No description provided for @charBrownHalfHead.
  ///
  /// In en, this message translates to:
  /// **'Half Brown Head'**
  String get charBrownHalfHead;

  /// No description provided for @charLightBrownHalfHead.
  ///
  /// In en, this message translates to:
  /// **'Half Light Brown Head'**
  String get charLightBrownHalfHead;

  /// No description provided for @charGreyHalfHead.
  ///
  /// In en, this message translates to:
  /// **'Half Grey Head'**
  String get charGreyHalfHead;

  /// No description provided for @charBlackLegs.
  ///
  /// In en, this message translates to:
  /// **'Black Legs'**
  String get charBlackLegs;

  /// No description provided for @charWhiteLegs.
  ///
  /// In en, this message translates to:
  /// **'White Legs'**
  String get charWhiteLegs;

  /// No description provided for @charBrownLegs.
  ///
  /// In en, this message translates to:
  /// **'Brown Legs'**
  String get charBrownLegs;

  /// No description provided for @charLightBrownLegs.
  ///
  /// In en, this message translates to:
  /// **'Light Brown Legs'**
  String get charLightBrownLegs;

  /// No description provided for @charGreyLegs.
  ///
  /// In en, this message translates to:
  /// **'Grey Legs'**
  String get charGreyLegs;

  /// No description provided for @charBlackFeet.
  ///
  /// In en, this message translates to:
  /// **'Black Feet'**
  String get charBlackFeet;

  /// No description provided for @charWhiteFeet.
  ///
  /// In en, this message translates to:
  /// **'White Feet'**
  String get charWhiteFeet;

  /// No description provided for @charBrownFeet.
  ///
  /// In en, this message translates to:
  /// **'Brown Feet'**
  String get charBrownFeet;

  /// No description provided for @charLightBrownFeet.
  ///
  /// In en, this message translates to:
  /// **'Light Brown Feet'**
  String get charLightBrownFeet;

  /// No description provided for @charGreyFeet.
  ///
  /// In en, this message translates to:
  /// **'Grey Feet'**
  String get charGreyFeet;

  /// No description provided for @charBlackSpots.
  ///
  /// In en, this message translates to:
  /// **'Black Spots'**
  String get charBlackSpots;

  /// No description provided for @charBrownSpots.
  ///
  /// In en, this message translates to:
  /// **'Brown Spots'**
  String get charBrownSpots;

  /// No description provided for @charLightBrownSpots.
  ///
  /// In en, this message translates to:
  /// **'Light Brown Spots'**
  String get charLightBrownSpots;

  /// No description provided for @charGreySpots.
  ///
  /// In en, this message translates to:
  /// **'Grey Spots'**
  String get charGreySpots;

  /// No description provided for @charBlackPattern.
  ///
  /// In en, this message translates to:
  /// **'Black Pattern'**
  String get charBlackPattern;

  /// No description provided for @charBrownPattern.
  ///
  /// In en, this message translates to:
  /// **'Brown Pattern'**
  String get charBrownPattern;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @purchaseStatusOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get purchaseStatusOpen;

  /// No description provided for @purchaseStatusReceived.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get purchaseStatusReceived;

  /// No description provided for @received.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get received;

  /// No description provided for @purchased.
  ///
  /// In en, this message translates to:
  /// **'Purchased'**
  String get purchased;

  /// No description provided for @sold.
  ///
  /// In en, this message translates to:
  /// **'Sold'**
  String get sold;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @company.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get company;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatch;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @contactPersonName.
  ///
  /// In en, this message translates to:
  /// **'Contact Name'**
  String get contactPersonName;

  /// No description provided for @phone1.
  ///
  /// In en, this message translates to:
  /// **'Phone 1'**
  String get phone1;

  /// No description provided for @phone2.
  ///
  /// In en, this message translates to:
  /// **'Phone 2 (Optional)'**
  String get phone2;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @login_usernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your username'**
  String get login_usernameRequired;

  /// No description provided for @login_passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get login_passwordRequired;

  /// No description provided for @login_loginError.
  ///
  /// In en, this message translates to:
  /// **'Login error, please try again'**
  String get login_loginError;

  /// No description provided for @login_invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials. Please try again.'**
  String get login_invalidCredentials;

  /// No description provided for @login_unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try later.'**
  String get login_unexpectedError;

  /// No description provided for @systemNumber.
  ///
  /// In en, this message translates to:
  /// **'System No.'**
  String get systemNumber;

  /// No description provided for @cattleNumber.
  ///
  /// In en, this message translates to:
  /// **'Cattle Number'**
  String get cattleNumber;

  /// No description provided for @animalNumber.
  ///
  /// In en, this message translates to:
  /// **'Animal Number'**
  String get animalNumber;

  /// No description provided for @number.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get number;

  /// No description provided for @lastWeightKg.
  ///
  /// In en, this message translates to:
  /// **'Last Weight (kg)'**
  String get lastWeightKg;

  /// No description provided for @estimatedWeightKg.
  ///
  /// In en, this message translates to:
  /// **'Estimated Weight (kg)'**
  String get estimatedWeightKg;

  /// No description provided for @eartag.
  ///
  /// In en, this message translates to:
  /// **'Eartag'**
  String get eartag;

  /// No description provided for @eartagLeft.
  ///
  /// In en, this message translates to:
  /// **'Left Eartag'**
  String get eartagLeft;

  /// No description provided for @eartagRight.
  ///
  /// In en, this message translates to:
  /// **'Right Eartag'**
  String get eartagRight;

  /// No description provided for @horns.
  ///
  /// In en, this message translates to:
  /// **'Horns'**
  String get horns;

  /// No description provided for @castrated.
  ///
  /// In en, this message translates to:
  /// **'Castrated'**
  String get castrated;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @approxBirthDate.
  ///
  /// In en, this message translates to:
  /// **'Approx. Birth Date'**
  String get approxBirthDate;

  /// No description provided for @newFeedStartDate.
  ///
  /// In en, this message translates to:
  /// **'New feed start date'**
  String get newFeedStartDate;

  /// No description provided for @averageDailyGain.
  ///
  /// In en, this message translates to:
  /// **'Avg. daily gain'**
  String get averageDailyGain;

  /// No description provided for @tracker.
  ///
  /// In en, this message translates to:
  /// **'Tracker'**
  String get tracker;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @receivedAt.
  ///
  /// In en, this message translates to:
  /// **'Received at'**
  String get receivedAt;

  /// No description provided for @purchaseCommission.
  ///
  /// In en, this message translates to:
  /// **'Commission'**
  String get purchaseCommission;

  /// No description provided for @purchasePrice.
  ///
  /// In en, this message translates to:
  /// **'Purchase Price'**
  String get purchasePrice;

  /// No description provided for @purchaseWeightKg.
  ///
  /// In en, this message translates to:
  /// **'Purchase Weight'**
  String get purchaseWeightKg;

  /// No description provided for @receivedWeightKg.
  ///
  /// In en, this message translates to:
  /// **'Received Weight'**
  String get receivedWeightKg;

  /// No description provided for @saleWeightKg.
  ///
  /// In en, this message translates to:
  /// **'Sale Weight'**
  String get saleWeightKg;

  /// No description provided for @salePrice.
  ///
  /// In en, this message translates to:
  /// **'Sale Price'**
  String get salePrice;

  /// No description provided for @weightHistory.
  ///
  /// In en, this message translates to:
  /// **'Weight Hist.'**
  String get weightHistory;

  /// No description provided for @medicationHistory.
  ///
  /// In en, this message translates to:
  /// **'Medication Hist.'**
  String get medicationHistory;

  /// No description provided for @count.
  ///
  /// In en, this message translates to:
  /// **'Count'**
  String get count;

  /// No description provided for @countSomething.
  ///
  /// In en, this message translates to:
  /// **'Count of {object}'**
  String countSomething(Object object);

  /// No description provided for @countAdjetive.
  ///
  /// In en, this message translates to:
  /// **'{adjetive} Count'**
  String countAdjetive(Object adjetive);

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @weightKg.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get weightKg;

  /// No description provided for @totalWeightKg.
  ///
  /// In en, this message translates to:
  /// **'Total Weight (kg)'**
  String get totalWeightKg;

  /// No description provided for @avgWeightKg.
  ///
  /// In en, this message translates to:
  /// **'Avg. Weight (kg)'**
  String get avgWeightKg;

  /// No description provided for @pricePerKg.
  ///
  /// In en, this message translates to:
  /// **'Price per Kg'**
  String get pricePerKg;

  /// No description provided for @totalPrice.
  ///
  /// In en, this message translates to:
  /// **'Total Price'**
  String get totalPrice;

  /// No description provided for @pricePerHead.
  ///
  /// In en, this message translates to:
  /// **'Avg. Price per Head'**
  String get pricePerHead;

  /// No description provided for @minWeightKg.
  ///
  /// In en, this message translates to:
  /// **'Min. Weight (Kg)'**
  String get minWeightKg;

  /// No description provided for @purchasedAvgWeight.
  ///
  /// In en, this message translates to:
  /// **'Purchased Avg. Weight (kg)'**
  String get purchasedAvgWeight;

  /// No description provided for @receivedAvgWeight.
  ///
  /// In en, this message translates to:
  /// **'Received Avg. Weight (kg)'**
  String get receivedAvgWeight;

  /// No description provided for @unassignedCattle.
  ///
  /// In en, this message translates to:
  /// **'Cattle without an identified lot'**
  String get unassignedCattle;

  /// No description provided for @lotNumber.
  ///
  /// In en, this message translates to:
  /// **'Lot Number'**
  String get lotNumber;

  /// No description provided for @origin.
  ///
  /// In en, this message translates to:
  /// **'Origin'**
  String get origin;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @average.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get average;

  /// No description provided for @nit.
  ///
  /// In en, this message translates to:
  /// **'NIT'**
  String get nit;

  /// No description provided for @dosage.
  ///
  /// In en, this message translates to:
  /// **'Dosage'**
  String get dosage;

  /// No description provided for @route.
  ///
  /// In en, this message translates to:
  /// **'Administration route'**
  String get route;

  /// No description provided for @medicationLot.
  ///
  /// In en, this message translates to:
  /// **'Manufacturing lot'**
  String get medicationLot;

  /// No description provided for @appliedBy.
  ///
  /// In en, this message translates to:
  /// **'Applied by'**
  String get appliedBy;

  /// No description provided for @recordedBy.
  ///
  /// In en, this message translates to:
  /// **'Recorded by'**
  String get recordedBy;

  /// No description provided for @medication.
  ///
  /// In en, this message translates to:
  /// **'Medication'**
  String get medication;

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

  /// No description provided for @createNewBrandTitle.
  ///
  /// In en, this message translates to:
  /// **'Create New Brand'**
  String get createNewBrandTitle;

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

  /// No description provided for @eventConfigTitle.
  ///
  /// In en, this message translates to:
  /// **'Event Configuration'**
  String get eventConfigTitle;

  /// No description provided for @noAnimals.
  ///
  /// In en, this message translates to:
  /// **'No animals have been added yet'**
  String get noAnimals;

  /// No description provided for @tableSynced.
  ///
  /// In en, this message translates to:
  /// **'Synced'**
  String get tableSynced;

  /// No description provided for @purchaseReceptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Purchase Reception'**
  String get purchaseReceptionTitle;

  /// No description provided for @purchaseBatchesTitle.
  ///
  /// In en, this message translates to:
  /// **'Purchase Lots'**
  String get purchaseBatchesTitle;

  /// No description provided for @cattleOfSelection.
  ///
  /// In en, this message translates to:
  /// **'Selected Cattle'**
  String get cattleOfSelection;

  /// No description provided for @simpleEventsTitle.
  ///
  /// In en, this message translates to:
  /// **'Simple Events'**
  String get simpleEventsTitle;

  /// No description provided for @selectAnimalHint.
  ///
  /// In en, this message translates to:
  /// **'Select a head of cattle to view its events'**
  String get selectAnimalHint;

  /// No description provided for @appliedEvents.
  ///
  /// In en, this message translates to:
  /// **'Applied'**
  String get appliedEvents;

  /// No description provided for @availableEvents.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get availableEvents;

  /// No description provided for @receivedOk.
  ///
  /// In en, this message translates to:
  /// **'Cattle received'**
  String get receivedOk;

  /// No description provided for @cattleCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0 {0 cattle} one {1 head} other {{count} cattle}}'**
  String cattleCountLabel(num count);

  /// No description provided for @purchaseCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0 {0 cattle} one {1 head} other {{count} cattle}}'**
  String purchaseCountLabel(num count);

  /// No description provided for @receptionDate.
  ///
  /// In en, this message translates to:
  /// **'Reception date'**
  String get receptionDate;

  /// No description provided for @initialCattleNumber.
  ///
  /// In en, this message translates to:
  /// **'Initial cattle number'**
  String get initialCattleNumber;

  /// No description provided for @numberInUse.
  ///
  /// In en, this message translates to:
  /// **'This number is already in use'**
  String get numberInUse;

  /// No description provided for @hasHorns.
  ///
  /// In en, this message translates to:
  /// **'Has horns'**
  String get hasHorns;

  /// No description provided for @isCastrated.
  ///
  /// In en, this message translates to:
  /// **'Is castrated'**
  String get isCastrated;

  /// No description provided for @receiveCattle.
  ///
  /// In en, this message translates to:
  /// **'Receive cattle'**
  String get receiveCattle;

  /// No description provided for @eventsApplied.
  ///
  /// In en, this message translates to:
  /// **'Applied Events'**
  String get eventsApplied;

  /// No description provided for @noEventsApplied.
  ///
  /// In en, this message translates to:
  /// **'No applied events'**
  String get noEventsApplied;

  /// No description provided for @receivedCount.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get receivedCount;

  /// No description provided for @purchasedCount.
  ///
  /// In en, this message translates to:
  /// **'Purchased'**
  String get purchasedCount;

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

  /// No description provided for @sales_createFirstSale.
  ///
  /// In en, this message translates to:
  /// **'Create your first sale to get started'**
  String get sales_createFirstSale;

  /// No description provided for @sales_amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get sales_amount;

  /// No description provided for @sales_viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get sales_viewDetails;

  /// No description provided for @sales_showing.
  ///
  /// In en, this message translates to:
  /// **'Showing'**
  String get sales_showing;

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

  /// No description provided for @sales_errorLoading.
  ///
  /// In en, this message translates to:
  /// **'Error loading sales'**
  String get sales_errorLoading;

  /// No description provided for @provider_selectOrCreate.
  ///
  /// In en, this message translates to:
  /// **'Select or create provider'**
  String get provider_selectOrCreate;

  /// No description provided for @provider_searchByName.
  ///
  /// In en, this message translates to:
  /// **'Search by name...'**
  String get provider_searchByName;

  /// No description provided for @provider_providerName.
  ///
  /// In en, this message translates to:
  /// **'{providerTypeLabel} Name'**
  String provider_providerName(Object providerTypeLabel);

  /// No description provided for @provider_creating.
  ///
  /// In en, this message translates to:
  /// **'Creating...'**
  String get provider_creating;

  /// No description provided for @provider_createdSuccess.
  ///
  /// In en, this message translates to:
  /// **'{providerTypeLabel} created successfully'**
  String provider_createdSuccess(Object providerTypeLabel);

  /// No description provided for @provider_createError.
  ///
  /// In en, this message translates to:
  /// **'Error creating {providerTypeLabel}'**
  String provider_createError(Object providerTypeLabel);

  /// No description provided for @provider_nitLengthError.
  ///
  /// In en, this message translates to:
  /// **'NIT must be between 5 and 20 characters'**
  String get provider_nitLengthError;

  /// No description provided for @provider_nameLengthError.
  ///
  /// In en, this message translates to:
  /// **'Name must be between 3 and 50 characters'**
  String get provider_nameLengthError;

  /// No description provided for @cattle_validation_validating.
  ///
  /// In en, this message translates to:
  /// **'Validating cattle...'**
  String get cattle_validation_validating;

  /// No description provided for @cattle_validation_invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid cattle number'**
  String get cattle_validation_invalid;

  /// No description provided for @cattle_validation_notFound.
  ///
  /// In en, this message translates to:
  /// **'Cattle not found'**
  String get cattle_validation_notFound;

  /// No description provided for @cattle_validation_notActive.
  ///
  /// In en, this message translates to:
  /// **'The cattle is not ACTIVE'**
  String get cattle_validation_notActive;

  /// No description provided for @cattle_validation_sold.
  ///
  /// In en, this message translates to:
  /// **'This cattle has already been sold'**
  String get cattle_validation_sold;

  /// No description provided for @cattle_validation_dead.
  ///
  /// In en, this message translates to:
  /// **'This cattle is marked as dead'**
  String get cattle_validation_dead;

  /// No description provided for @cattle_validation_lost.
  ///
  /// In en, this message translates to:
  /// **'This cattle is marked as lost'**
  String get cattle_validation_lost;

  /// No description provided for @cattle_weightUnderMin.
  ///
  /// In en, this message translates to:
  /// **'Weight Below Minimum'**
  String get cattle_weightUnderMin;

  /// No description provided for @cattle_weightUnderMinMessage.
  ///
  /// In en, this message translates to:
  /// **'The measured weight ({measured} kg) is below the minimum weight ({min} kg). This cattle will use the minimum weight for price calculation.'**
  String cattle_weightUnderMinMessage(Object measured, Object min);

  /// No description provided for @cattle_approveQuestion.
  ///
  /// In en, this message translates to:
  /// **'Do you want to approve or reject this cattle?'**
  String get cattle_approveQuestion;

  /// No description provided for @cattle_approved_title.
  ///
  /// In en, this message translates to:
  /// **'Cattle Approved'**
  String get cattle_approved_title;

  /// No description provided for @cattle_rejected_title.
  ///
  /// In en, this message translates to:
  /// **'Cattle Rejected'**
  String get cattle_rejected_title;

  /// No description provided for @cattle_approved_count.
  ///
  /// In en, this message translates to:
  /// **'Approved ({count})'**
  String cattle_approved_count(Object count);

  /// No description provided for @cattle_rejected_count.
  ///
  /// In en, this message translates to:
  /// **'Rejected ({count})'**
  String cattle_rejected_count(Object count);

  /// No description provided for @cattle_noApproved.
  ///
  /// In en, this message translates to:
  /// **'There is no approved cattle yet'**
  String get cattle_noApproved;

  /// No description provided for @cattle_noRejected.
  ///
  /// In en, this message translates to:
  /// **'There is no rejected cattle'**
  String get cattle_noRejected;

  /// No description provided for @cattle_rejectionReason.
  ///
  /// In en, this message translates to:
  /// **'Insufficient weight'**
  String get cattle_rejectionReason;

  /// No description provided for @sale_confirm_title.
  ///
  /// In en, this message translates to:
  /// **'Confirm Sale Creation'**
  String get sale_confirm_title;

  /// No description provided for @sale_confirm_message.
  ///
  /// In en, this message translates to:
  /// **'The following {count} approved cattle will be marked as SOLD:'**
  String sale_confirm_message(Object count);

  /// No description provided for @sale_confirm_warning.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. Continue?'**
  String get sale_confirm_warning;

  /// No description provided for @sale_confirm_proceed.
  ///
  /// In en, this message translates to:
  /// **'Confirm and Create Sale'**
  String get sale_confirm_proceed;

  /// No description provided for @sale_creating.
  ///
  /// In en, this message translates to:
  /// **'Creating sale...'**
  String get sale_creating;

  /// No description provided for @sale_created.
  ///
  /// In en, this message translates to:
  /// **'Sale created successfully'**
  String get sale_created;

  /// No description provided for @sale_createError.
  ///
  /// In en, this message translates to:
  /// **'Error creating sale'**
  String get sale_createError;

  /// No description provided for @user_editUserPageMessage.
  ///
  /// In en, this message translates to:
  /// **'This feature is under development'**
  String get user_editUserPageMessage;

  /// No description provided for @saleSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Sale saved successfully'**
  String get saleSavedSuccess;

  /// No description provided for @cattleFoundPending.
  ///
  /// In en, this message translates to:
  /// **'Cattle found (Implementation pending)'**
  String get cattleFoundPending;

  /// No description provided for @scanEnterNumber.
  ///
  /// In en, this message translates to:
  /// **'Scan/Enter Number'**
  String get scanEnterNumber;

  /// No description provided for @salesDashboard.
  ///
  /// In en, this message translates to:
  /// **'Sales Dashboard'**
  String get salesDashboard;

  /// No description provided for @noOfflineSales.
  ///
  /// In en, this message translates to:
  /// **'There are no offline sales pending sync.'**
  String get noOfflineSales;

  /// No description provided for @saleWithDate.
  ///
  /// In en, this message translates to:
  /// **'Sale {date}'**
  String saleWithDate(Object date);

  /// No description provided for @totalWithAmount.
  ///
  /// In en, this message translates to:
  /// **'Total: {amount}'**
  String totalWithAmount(Object amount);

  /// No description provided for @label_measuredWeight.
  ///
  /// In en, this message translates to:
  /// **'Measured Weight'**
  String get label_measuredWeight;

  /// No description provided for @label_totalCattle.
  ///
  /// In en, this message translates to:
  /// **'Total Cattle'**
  String get label_totalCattle;

  /// No description provided for @allPurchasedCattleReceived.
  ///
  /// In en, this message translates to:
  /// **'All purchased animals have been received'**
  String get allPurchasedCattleReceived;

  /// No description provided for @lotAssignedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Lot assigned successfully'**
  String get lotAssignedSuccessfully;

  /// No description provided for @error_enterCattleNumberWeight.
  ///
  /// In en, this message translates to:
  /// **'Please enter the cattle number and weight'**
  String get error_enterCattleNumberWeight;

  /// No description provided for @error_enterValidWeight.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid weight'**
  String get error_enterValidWeight;

  /// No description provided for @error_addApprovedCattle.
  ///
  /// In en, this message translates to:
  /// **'Please add at least one approved cattle'**
  String get error_addApprovedCattle;

  /// No description provided for @sale_info.
  ///
  /// In en, this message translates to:
  /// **'Sale Information'**
  String get sale_info;

  /// No description provided for @pricing_config.
  ///
  /// In en, this message translates to:
  /// **'Pricing Configuration'**
  String get pricing_config;

  /// No description provided for @hint_enterScanId.
  ///
  /// In en, this message translates to:
  /// **'Enter or scan ID'**
  String get hint_enterScanId;

  /// No description provided for @label_validating.
  ///
  /// In en, this message translates to:
  /// **'Validating...'**
  String get label_validating;

  /// No description provided for @warning_set_min_weight.
  ///
  /// In en, this message translates to:
  /// **'Please configure a minimum weight in the above settings before adding cattle'**
  String get warning_set_min_weight;

  /// No description provided for @label_summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get label_summary;

  /// No description provided for @error_invalid_number.
  ///
  /// In en, this message translates to:
  /// **'Invalid number'**
  String get error_invalid_number;

  /// No description provided for @error_invalid_price.
  ///
  /// In en, this message translates to:
  /// **'Invalid price'**
  String get error_invalid_price;

  /// No description provided for @label_notes_optional.
  ///
  /// In en, this message translates to:
  /// **'Notes (Optional)'**
  String get label_notes_optional;

  /// No description provided for @label_transporter_optional.
  ///
  /// In en, this message translates to:
  /// **'Transporter (Optional)'**
  String get label_transporter_optional;

  /// No description provided for @label_buyer_required.
  ///
  /// In en, this message translates to:
  /// **'Buyer *'**
  String get label_buyer_required;

  /// No description provided for @error_buyer_required.
  ///
  /// In en, this message translates to:
  /// **'Buyer is required'**
  String get error_buyer_required;

  /// No description provided for @label_price_per_kg_required.
  ///
  /// In en, this message translates to:
  /// **'Price / Kg *'**
  String get label_price_per_kg_required;

  /// No description provided for @label_cattle_management.
  ///
  /// In en, this message translates to:
  /// **'Cattle Management'**
  String get label_cattle_management;

  /// No description provided for @tracker_removed.
  ///
  /// In en, this message translates to:
  /// **'Tracker removed'**
  String get tracker_removed;

  /// No description provided for @user_usernameLengthError.
  ///
  /// In en, this message translates to:
  /// **'Username must be between 5 and 50 characters'**
  String get user_usernameLengthError;

  /// No description provided for @user_firstNameLengthError.
  ///
  /// In en, this message translates to:
  /// **'First name must be at most 50 characters'**
  String get user_firstNameLengthError;

  /// No description provided for @user_lastNameLengthError.
  ///
  /// In en, this message translates to:
  /// **'Last name must be at most 50 characters'**
  String get user_lastNameLengthError;

  /// No description provided for @user_passwordLengthError.
  ///
  /// In en, this message translates to:
  /// **'Password must be between 8 and 50 characters'**
  String get user_passwordLengthError;

  /// No description provided for @searchTracker.
  ///
  /// In en, this message translates to:
  /// **'Search tracker...'**
  String get searchTracker;

  /// No description provided for @trackerNotFound.
  ///
  /// In en, this message translates to:
  /// **'Tracker not found'**
  String get trackerNotFound;

  /// No description provided for @trackerNotSelected.
  ///
  /// In en, this message translates to:
  /// **'Tracker not selected'**
  String get trackerNotSelected;

  /// No description provided for @masterListTitle.
  ///
  /// In en, this message translates to:
  /// **'Cattle Master List'**
  String get masterListTitle;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalidEmail;

  /// No description provided for @userCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'User created successfully'**
  String get userCreatedSuccess;

  /// No description provided for @userUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'User updated successfully'**
  String get userUpdatedSuccess;

  /// No description provided for @userDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'User deleted successfully'**
  String get userDeletedSuccess;

  /// No description provided for @userDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete User'**
  String get userDeleteConfirmTitle;

  /// No description provided for @userDeleteConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this user? This action cannot be undone.'**
  String get userDeleteConfirmBody;

  /// No description provided for @noUsersFound.
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get noUsersFound;

  /// No description provided for @error_eartagExist.
  ///
  /// In en, this message translates to:
  /// **'Eartag number already exists for another head of cattle.'**
  String get error_eartagExist;

  /// No description provided for @purchase_dateRequired.
  ///
  /// In en, this message translates to:
  /// **'You must select a purchase date.'**
  String get purchase_dateRequired;

  /// No description provided for @purchase_saveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Purchase saved successfully.'**
  String get purchase_saveSuccess;

  /// No description provided for @purchase_saveError.
  ///
  /// In en, this message translates to:
  /// **'Purchase saving failed.'**
  String get purchase_saveError;

  /// No description provided for @cp_error_noLots.
  ///
  /// In en, this message translates to:
  /// **'You must add at least one lot'**
  String get cp_error_noLots;

  /// No description provided for @cp_error_providerRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select or create a provider.'**
  String get cp_error_providerRequired;

  /// No description provided for @purchase_totalCattle.
  ///
  /// In en, this message translates to:
  /// **'Total cattle'**
  String get purchase_totalCattle;

  /// No description provided for @noPurchasesFound.
  ///
  /// In en, this message translates to:
  /// **'Purchase not found'**
  String get noPurchasesFound;

  /// No description provided for @provider_found.
  ///
  /// In en, this message translates to:
  /// **'Provider found and loaded.'**
  String get provider_found;

  /// No description provided for @provider_willBeCreated.
  ///
  /// In en, this message translates to:
  /// **'A new provider will be created with this NIT.'**
  String get provider_willBeCreated;

  /// No description provided for @provider_nameIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Provider name is required.'**
  String get provider_nameIsRequired;

  /// No description provided for @provider_nitIsRequired.
  ///
  /// In en, this message translates to:
  /// **'NIT is required.'**
  String get provider_nitIsRequired;

  /// No description provided for @provider_createdSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Provider created successfully'**
  String get provider_createdSuccessfully;

  /// No description provided for @provider_nitAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'A provider with that NIT already exists'**
  String get provider_nitAlreadyExists;

  /// No description provided for @provider_creationError.
  ///
  /// In en, this message translates to:
  /// **'Error creating provider'**
  String get provider_creationError;

  /// No description provided for @lot_pricePerHeadRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the average price per head.'**
  String get lot_pricePerHeadRequired;

  /// No description provided for @lot_pricePerHeadInvalid.
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
  /// **'Average weight must be greater than 0.'**
  String get lot_avgWeightInvalid;

  /// No description provided for @lot_pricePerKgRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the price per kilogram'**
  String get lot_pricePerKgRequired;

  /// No description provided for @lot_pricePerKgInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid price per kilogram'**
  String get lot_pricePerKgInvalid;

  /// No description provided for @lot_cattleCountRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the number of cattle in the lot.'**
  String get lot_cattleCountRequired;

  /// No description provided for @lot_cattleCountInvalid.
  ///
  /// In en, this message translates to:
  /// **'The number of cattle in the lot must be greater than 0.'**
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
  /// **'Each lot must have number of cattle, average weight, and price per kg greater than zero.'**
  String get lot_countAvWeightPriceKgRequired;

  /// No description provided for @simpleEventAdded.
  ///
  /// In en, this message translates to:
  /// **'Detail added successfully'**
  String get simpleEventAdded;

  /// No description provided for @simpleEventError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while adding the detail'**
  String get simpleEventError;

  /// No description provided for @simpleEventApplied.
  ///
  /// In en, this message translates to:
  /// **'Active events were applied to cattle number {cattleNumber}'**
  String simpleEventApplied(Object cattleNumber);

  /// No description provided for @applyAtLeastOneSimpleEvent.
  ///
  /// In en, this message translates to:
  /// **'You must apply at least one event.'**
  String get applyAtLeastOneSimpleEvent;

  /// No description provided for @eventsApplicationNotice.
  ///
  /// In en, this message translates to:
  /// **'All events have been applied. If any appear as not applied, make sure you have entered all required information.'**
  String get eventsApplicationNotice;

  /// Shown when trying to close a massive event, but none of its simple events were applied to an animal.
  ///
  /// In en, this message translates to:
  /// **'The massive event cannot be closed because no simple event has been applied to any animal.'**
  String get error_noSimpleEventsApplied;

  /// Shown when the user tries to close or modify a massive event that has already been closed.
  ///
  /// In en, this message translates to:
  /// **'This massive event is already closed and cannot be modified.'**
  String get error_massiveEventAlreadyClosed;

  /// Shown when a massive event has been successfully finished.
  ///
  /// In en, this message translates to:
  /// **'The massive event was finished successfully.'**
  String get event_finishSuccess;

  /// No description provided for @cattle_exists_error.
  ///
  /// In en, this message translates to:
  /// **'Number already exists (Active/Lost)'**
  String get cattle_exists_error;

  /// No description provided for @eartag_exists_error.
  ///
  /// In en, this message translates to:
  /// **'Eartag already exists (Active/Lost)'**
  String get eartag_exists_error;

  /// No description provided for @activeDetails.
  ///
  /// In en, this message translates to:
  /// **'Active events:'**
  String get activeDetails;

  /// No description provided for @noActiveDetails.
  ///
  /// In en, this message translates to:
  /// **'No active details'**
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
  /// **'No inactive events.'**
  String get noInactive;

  /// No description provided for @reactivateTooltip.
  ///
  /// In en, this message translates to:
  /// **'Reactivate'**
  String get reactivateTooltip;

  /// No description provided for @onlyOneType.
  ///
  /// In en, this message translates to:
  /// **'There can only be one event of type {type} in this Massive Event.'**
  String onlyOneType(Object type);

  /// No description provided for @brandAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'The brand \"{brand}\" already exists in this Massive Event.'**
  String brandAlreadyExists(Object brand);

  /// No description provided for @reactivatedInfo.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" was reactivated.'**
  String reactivatedInfo(Object name);

  /// Message shown when locations map fails to load.
  ///
  /// In en, this message translates to:
  /// **'Could not load the locations map.'**
  String get locations_map_loadError;

  /// Message shown when there are no locations to display on the map.
  ///
  /// In en, this message translates to:
  /// **'No locations available.'**
  String get locations_map_empty;

  /// Dialog/overlay title for last known location.
  ///
  /// In en, this message translates to:
  /// **'Last location'**
  String get locations_map_lastLocationTitle;

  /// Required OpenStreetMap attribution text.
  ///
  /// In en, this message translates to:
  /// **'© OpenStreetMap contributors'**
  String get locations_map_osmAttribution;
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
