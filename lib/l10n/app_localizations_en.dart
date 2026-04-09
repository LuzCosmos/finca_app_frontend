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
  String get create => 'Create';

  @override
  String createSomething(Object object) {
    return 'Create $object';
  }

  @override
  String createNewSomething(Object object) {
    return 'Create new $object';
  }

  @override
  String get add => 'Add';

  @override
  String addSomething(Object object) {
    return 'Add $object';
  }

  @override
  String get edit => 'Edit';

  @override
  String editSomething(Object object) {
    return 'Edit $object';
  }

  @override
  String get update => 'Update';

  @override
  String updateSomething(Object object) {
    return 'Update $object';
  }

  @override
  String get refresh => 'Refresh';

  @override
  String get delete => 'Delete';

  @override
  String deleteSomething(Object object) {
    return 'Delete $object';
  }

  @override
  String get remove => 'Remove';

  @override
  String removeSomething(Object object) {
    return 'Remove $object';
  }

  @override
  String get save => 'Save';

  @override
  String saveSomething(Object object) {
    return 'Save $object';
  }

  @override
  String get select => 'Select';

  @override
  String selectSomething(Object object) {
    return 'Select $object';
  }

  @override
  String get assign => 'Assign';

  @override
  String assignSomething(Object object) {
    return 'Assign $object';
  }

  @override
  String get apply => 'Apply';

  @override
  String get cancel => 'Cancel';

  @override
  String get finish => 'Finish';

  @override
  String get close => 'Close';

  @override
  String get accept => 'Accept';

  @override
  String get open => 'Open';

  @override
  String get view => 'View';

  @override
  String get search => 'Search';

  @override
  String get filter => 'Filter';

  @override
  String get receive => 'Receive';

  @override
  String get approve => 'Approve';

  @override
  String get reject => 'Reject';

  @override
  String get retry => 'Retry';

  @override
  String get sort => 'Sort';

  @override
  String get export => 'Export';

  @override
  String get import => 'Import';

  @override
  String get print => 'Print';

  @override
  String get download => 'Download';

  @override
  String get upload => 'Upload';

  @override
  String get optional => 'Optional';

  @override
  String get actions => 'Actions';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get l10n_of => 'of';

  @override
  String get page => 'Page';

  @override
  String get results => 'results';

  @override
  String get previous => 'Previous';

  @override
  String get next => 'Next';

  @override
  String get rowsPerPage => 'Rows per page';

  @override
  String get fieldRequired => 'This field is required.';

  @override
  String get invalidValue => 'Invalid value.';

  @override
  String get all => 'All';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get notApplied => 'Not applied';

  @override
  String get numberFormat => '#,##0.##';

  @override
  String get numberFormat_country => 'en_US';

  @override
  String get fixErrors => 'Please fix the errors highlighted in red.';

  @override
  String get error_readingObject =>
      'An unexpected error occurred while reading.';

  @override
  String get error_savingObject => 'An unexpected error occurred while saving.';

  @override
  String get error_badRequest =>
      'The request is not valid. Check the data and try again.';

  @override
  String get error_unauthorized =>
      'Your session has expired or you do not have access. Please log in again.';

  @override
  String get error_forbidden =>
      'You do not have permission to perform this action.';

  @override
  String error_notFound(Object object) {
    return '$object was not found.';
  }

  @override
  String get error_methodNotAllowed =>
      'This action is not allowed at this time.';

  @override
  String get error_conflict => 'The record already exists.';

  @override
  String get error_preconditionFailed =>
      'The conditions to perform this action are not met.';

  @override
  String get error_unprocessableEntity =>
      'Some data is not valid. Please correct it and try again.';

  @override
  String get error_locked =>
      'The resource is locked by another operation in progress. Try again later.';

  @override
  String get error_tooManyRequests =>
      'You have made too many requests. Try again later.';

  @override
  String get error_serverConnection =>
      'Could not connect to the server. Check your internet connection or try again later.';

  @override
  String get error_server => 'Internal server error. Try later.';

  @override
  String get error_generic => 'An unexpected error has occurred.';

  @override
  String get error_cattleIsNotActive => 'The cattle is not active.';

  @override
  String get error_soldCattleMissingSaleDetail =>
      'Sold cattle must have an associated sale detail.';

  @override
  String get error_saleFieldsOnlyForSoldCattle =>
      'Sale price and weight can only be updated for cattle in SOLD status.';

  @override
  String get error_invalidSalePrice => 'Invalid sale price.';

  @override
  String get error_invalidSaleWeight => 'Invalid sale weight.';

  @override
  String error_savingField(Object error) {
    return 'Error saving: $error';
  }

  @override
  String get noData => 'No data available';

  @override
  String noDataSomething(Object object) {
    return 'No $object data available';
  }

  @override
  String noDataFiltered(Object object) {
    return 'No $object found with the current filters';
  }

  @override
  String get tryAdjustFilters => 'Try adjusting your filters';

  @override
  String get clearFilters => 'Clear Filters';

  @override
  String get home_title => 'Home';

  @override
  String get date => 'Date';

  @override
  String dateSomething(Object object) {
    return '$object Date';
  }

  @override
  String get username => 'Username';

  @override
  String get user => 'User';

  @override
  String get users => 'Users';

  @override
  String listSomething(Object object) {
    return '$object List';
  }

  @override
  String get cattle => 'Cattle';

  @override
  String get cattles => 'Cattle';

  @override
  String get animal => 'Animal';

  @override
  String get animals => 'Animals';

  @override
  String get lot => 'Lot';

  @override
  String get lots => 'Lots';

  @override
  String get withoutLot => 'Without lot';

  @override
  String get purchase => 'Purchase';

  @override
  String get purchases => 'Purchases';

  @override
  String get cattlePurchase => 'Cattle Purchase';

  @override
  String get massiveEvent => 'Massive Event';

  @override
  String get massiveEvents => 'Massive Events';

  @override
  String get massiveEventPendingSync =>
      'This event is saved on the device and is pending synchronization with the server.';

  @override
  String get syncNow => 'Sync now';

  @override
  String get event => 'Event';

  @override
  String get events => 'Events';

  @override
  String get sale => 'Sale';

  @override
  String get sales => 'Sales';

  @override
  String get role => 'Role';

  @override
  String get roles => 'Roles';

  @override
  String get brand => 'Brand';

  @override
  String get brands => 'Brands';

  @override
  String get provider => 'Provider';

  @override
  String get providers => 'Providers';

  @override
  String get buyer => 'Buyer';

  @override
  String get buyers => 'Buyers';

  @override
  String get transporter => 'Transporter';

  @override
  String get transporters => 'Transporters';

  @override
  String get purchaseReception => 'Purchase Reception';

  @override
  String get reception => 'Reception';

  @override
  String get cattleStatusActive => 'Active';

  @override
  String get cattleStatusSold => 'Sold';

  @override
  String get cattleStatusDead => 'Dead';

  @override
  String get cattleStatusLost => 'Lost';

  @override
  String get eventTypeWeight => 'Weight';

  @override
  String get eventTypeCastration => 'Castration';

  @override
  String get eventTypeTracker => 'Assign Tracker';

  @override
  String get eventTypeEartag => 'Apply Eartag';

  @override
  String get eventTypeMedication => 'Medication';

  @override
  String get eventTypeBrand => 'Branding';

  @override
  String get gender => 'Gender';

  @override
  String get genderMale => 'Male';

  @override
  String get genderFemale => 'Female';

  @override
  String get color => 'Color';

  @override
  String get colors => 'Colors';

  @override
  String get colorBlack => 'Black';

  @override
  String get colorWhite => 'White';

  @override
  String get colorBrown => 'Brown';

  @override
  String get colorBlackBrown => 'Black-Brown';

  @override
  String get colorLightBrown => 'Light Brown';

  @override
  String get colorGrey => 'Grey';

  @override
  String get characteristic => 'Characteristic';

  @override
  String get characteristics => 'Characteristics';

  @override
  String get charBlackBelly => 'Black Belly';

  @override
  String get charWhiteBelly => 'White Belly';

  @override
  String get charBrownBelly => 'Brown Belly';

  @override
  String get charLightBrownBelly => 'Light Brown Belly';

  @override
  String get charGreyBelly => 'Grey Belly';

  @override
  String get charBlackHead => 'Black Head';

  @override
  String get charWhiteHead => 'White Head';

  @override
  String get charBrownHead => 'Brown Head';

  @override
  String get charLightBrownHead => 'Light Brown Head';

  @override
  String get charGreyHead => 'Grey Head';

  @override
  String get charBlackHalfHead => 'Half Black Head';

  @override
  String get charWhiteHalfHead => 'Half White Head';

  @override
  String get charBrownHalfHead => 'Half Brown Head';

  @override
  String get charLightBrownHalfHead => 'Half Light Brown Head';

  @override
  String get charGreyHalfHead => 'Half Grey Head';

  @override
  String get charBlackLegs => 'Black Legs';

  @override
  String get charWhiteLegs => 'White Legs';

  @override
  String get charBrownLegs => 'Brown Legs';

  @override
  String get charLightBrownLegs => 'Light Brown Legs';

  @override
  String get charGreyLegs => 'Grey Legs';

  @override
  String get charBlackFeet => 'Black Feet';

  @override
  String get charWhiteFeet => 'White Feet';

  @override
  String get charBrownFeet => 'Brown Feet';

  @override
  String get charLightBrownFeet => 'Light Brown Feet';

  @override
  String get charGreyFeet => 'Grey Feet';

  @override
  String get charBlackSpots => 'Black Spots';

  @override
  String get charBrownSpots => 'Brown Spots';

  @override
  String get charLightBrownSpots => 'Light Brown Spots';

  @override
  String get charGreySpots => 'Grey Spots';

  @override
  String get charBlackPattern => 'Black Pattern';

  @override
  String get charBrownPattern => 'Brown Pattern';

  @override
  String get status => 'Status';

  @override
  String get purchaseStatusOpen => 'Open';

  @override
  String get purchaseStatusReceived => 'Received';

  @override
  String get received => 'Received';

  @override
  String get purchased => 'Purchased';

  @override
  String get sold => 'Sold';

  @override
  String get name => 'Name';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get company => 'Company';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get passwordMismatch => 'Passwords do not match';

  @override
  String get address => 'Address';

  @override
  String get contactPersonName => 'Contact Name';

  @override
  String get phone1 => 'Phone 1';

  @override
  String get phone2 => 'Phone 2 (Optional)';

  @override
  String get type => 'Type';

  @override
  String get login => 'Log In';

  @override
  String get logout => 'Log Out';

  @override
  String get login_usernameRequired => 'Enter your username';

  @override
  String get login_passwordRequired => 'Enter your password';

  @override
  String get login_loginError => 'Login error, please try again';

  @override
  String get login_invalidCredentials =>
      'Invalid credentials. Please try again.';

  @override
  String get login_unexpectedError =>
      'An unexpected error occurred. Please try later.';

  @override
  String get systemNumber => 'System No.';

  @override
  String get cattleNumber => 'Cattle Number';

  @override
  String get animalNumber => 'Animal Number';

  @override
  String get number => 'Number';

  @override
  String get lastWeightKg => 'Last Weight (kg)';

  @override
  String get estimatedWeightKg => 'Estimated Weight (kg)';

  @override
  String get eartag => 'Eartag';

  @override
  String get eartagLeft => 'Left Eartag';

  @override
  String get eartagRight => 'Right Eartag';

  @override
  String get horns => 'Horns';

  @override
  String get castrated => 'Castrated';

  @override
  String get age => 'Age';

  @override
  String get approxBirthDate => 'Approx. Birth Date';

  @override
  String get newFeedStartDate => 'New feed start date';

  @override
  String get averageDailyGain => 'Avg. daily gain';

  @override
  String get tracker => 'Tracker';

  @override
  String get comments => 'Comments';

  @override
  String get receivedAt => 'Received at';

  @override
  String get purchaseCommission => 'Commission';

  @override
  String get purchasePrice => 'Purchase Price';

  @override
  String get purchaseWeightKg => 'Purchase Weight';

  @override
  String get receivedWeightKg => 'Received Weight';

  @override
  String get saleWeightKg => 'Sale Weight';

  @override
  String get salePrice => 'Sale Price';

  @override
  String get weightHistory => 'Weight Hist.';

  @override
  String get medicationHistory => 'Medication Hist.';

  @override
  String get count => 'Count';

  @override
  String countSomething(Object object) {
    return 'Count of $object';
  }

  @override
  String countAdjetive(Object adjetive) {
    return '$adjetive Count';
  }

  @override
  String get price => 'Price';

  @override
  String get weightKg => 'Weight (kg)';

  @override
  String get totalWeightKg => 'Total Weight (kg)';

  @override
  String get avgWeightKg => 'Avg. Weight (kg)';

  @override
  String get pricePerKg => 'Price per Kg';

  @override
  String get totalPrice => 'Total Price';

  @override
  String get pricePerHead => 'Avg. Price per Head';

  @override
  String get minWeightKg => 'Min. Weight (Kg)';

  @override
  String get purchasedAvgWeight => 'Purchased Avg. Weight (kg)';

  @override
  String get receivedAvgWeight => 'Received Avg. Weight (kg)';

  @override
  String get unassignedCattle => 'Cattle without an identified lot';

  @override
  String get lotNumber => 'Lot Number';

  @override
  String get origin => 'Origin';

  @override
  String get total => 'Total';

  @override
  String get average => 'Average';

  @override
  String get nit => 'NIT';

  @override
  String get dosage => 'Dosage';

  @override
  String get route => 'Administration route';

  @override
  String get medicationLot => 'Manufacturing lot';

  @override
  String get appliedBy => 'Applied by';

  @override
  String get recordedBy => 'Recorded by';

  @override
  String get medication => 'Medication';

  @override
  String get selectBrand => 'Select a brand';

  @override
  String get createNewBrand => 'Create new brand';

  @override
  String get createNewBrandTitle => 'Create New Brand';

  @override
  String get selectImage => 'Select image';

  @override
  String get imageRequired => 'Image is required';

  @override
  String get eventConfigTitle => 'Event Configuration';

  @override
  String get noAnimals => 'No animals have been added yet';

  @override
  String get tableSynced => 'Synced';

  @override
  String get purchaseReceptionTitle => 'Purchase Reception';

  @override
  String get purchaseBatchesTitle => 'Purchase Lots';

  @override
  String get cattleOfSelection => 'Selected Cattle';

  @override
  String get simpleEventsTitle => 'Simple Events';

  @override
  String get selectAnimalHint => 'Select a head of cattle to view its events';

  @override
  String get appliedEvents => 'Applied';

  @override
  String get availableEvents => 'Available';

  @override
  String get receivedOk => 'Cattle received';

  @override
  String cattleCountLabel(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cattle',
      one: '1 head',
      zero: '0 cattle',
    );
    return '$_temp0';
  }

  @override
  String purchaseCountLabel(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cattle',
      one: '1 head',
      zero: '0 cattle',
    );
    return '$_temp0';
  }

  @override
  String get receptionDate => 'Reception date';

  @override
  String get initialCattleNumber => 'Initial cattle number';

  @override
  String get numberInUse => 'This number is already in use';

  @override
  String get hasHorns => 'Has horns';

  @override
  String get isCastrated => 'Is castrated';

  @override
  String get receiveCattle => 'Receive cattle';

  @override
  String get eventsApplied => 'Applied Events';

  @override
  String get noEventsApplied => 'No applied events';

  @override
  String get receivedCount => 'Received';

  @override
  String get purchasedCount => 'Purchased';

  @override
  String get sales_searchPlaceholder => 'Search sales...';

  @override
  String get sales_dateRange => 'Date Range';

  @override
  String get sales_createFirstSale => 'Create your first sale to get started';

  @override
  String get sales_amount => 'Amount';

  @override
  String get sales_viewDetails => 'View Details';

  @override
  String get sales_showing => 'Showing';

  @override
  String get sales_saleDetails => 'Sale Details';

  @override
  String get sales_transactionDate => 'Transaction Date';

  @override
  String get sales_totalAmount => 'Total Amount';

  @override
  String get sales_cattleList => 'Cattle List';

  @override
  String get sales_noDetails => 'No details available.';

  @override
  String get sales_errorLoading => 'Error loading sales';

  @override
  String get provider_selectOrCreate => 'Select or create provider';

  @override
  String get provider_searchByName => 'Search by name...';

  @override
  String provider_providerName(Object providerTypeLabel) {
    return '$providerTypeLabel Name';
  }

  @override
  String get provider_creating => 'Creating...';

  @override
  String provider_createdSuccess(Object providerTypeLabel) {
    return '$providerTypeLabel created successfully';
  }

  @override
  String provider_createError(Object providerTypeLabel) {
    return 'Error creating $providerTypeLabel';
  }

  @override
  String get provider_nitLengthError =>
      'NIT must be between 5 and 20 characters';

  @override
  String get provider_nameLengthError =>
      'Name must be between 3 and 50 characters';

  @override
  String get cattle_validation_validating => 'Validating cattle...';

  @override
  String get cattle_validation_invalid => 'Invalid cattle number';

  @override
  String get cattle_validation_notFound => 'Cattle not found';

  @override
  String get cattle_validation_notActive => 'The cattle is not ACTIVE';

  @override
  String get cattle_validation_sold => 'This cattle has already been sold';

  @override
  String get cattle_validation_dead => 'This cattle is marked as dead';

  @override
  String get cattle_validation_lost => 'This cattle is marked as lost';

  @override
  String get cattle_weightUnderMin => 'Weight Below Minimum';

  @override
  String cattle_weightUnderMinMessage(Object measured, Object min) {
    return 'The measured weight ($measured kg) is below the minimum weight ($min kg). This cattle will use the minimum weight for price calculation.';
  }

  @override
  String get cattle_approveQuestion =>
      'Do you want to approve or reject this cattle?';

  @override
  String get cattle_approved_title => 'Cattle Approved';

  @override
  String get cattle_rejected_title => 'Cattle Rejected';

  @override
  String cattle_approved_count(Object count) {
    return 'Approved ($count)';
  }

  @override
  String cattle_rejected_count(Object count) {
    return 'Rejected ($count)';
  }

  @override
  String get cattle_noApproved => 'There is no approved cattle yet';

  @override
  String get cattle_noRejected => 'There is no rejected cattle';

  @override
  String get cattle_rejectionReason => 'Insufficient weight';

  @override
  String get sale_confirm_title => 'Confirm Sale Creation';

  @override
  String sale_confirm_message(Object count) {
    return 'The following $count approved cattle will be marked as SOLD:';
  }

  @override
  String get sale_confirm_warning => 'This action cannot be undone. Continue?';

  @override
  String get sale_confirm_proceed => 'Confirm and Create Sale';

  @override
  String get sale_creating => 'Creating sale...';

  @override
  String get sale_created => 'Sale created successfully';

  @override
  String get sale_createError => 'Error creating sale';

  @override
  String get user_editUserPageMessage => 'This feature is under development';

  @override
  String get saleSavedSuccess => 'Sale saved successfully';

  @override
  String get cattleFoundPending => 'Cattle found (Implementation pending)';

  @override
  String get scanEnterNumber => 'Scan/Enter Number';

  @override
  String get salesDashboard => 'Sales Dashboard';

  @override
  String get noOfflineSales => 'There are no offline sales pending sync.';

  @override
  String saleWithDate(Object date) {
    return 'Sale $date';
  }

  @override
  String totalWithAmount(Object amount) {
    return 'Total: $amount';
  }

  @override
  String get label_measuredWeight => 'Measured Weight';

  @override
  String get label_totalCattle => 'Total Cattle';

  @override
  String get allPurchasedCattleReceived =>
      'All purchased animals have been received';

  @override
  String get lotAssignedSuccessfully => 'Lot assigned successfully';

  @override
  String get error_enterCattleNumberWeight =>
      'Please enter the cattle number and weight';

  @override
  String get error_enterValidWeight => 'Please enter a valid weight';

  @override
  String get error_addApprovedCattle =>
      'Please add at least one approved cattle';

  @override
  String get sale_info => 'Sale Information';

  @override
  String get pricing_config => 'Pricing Configuration';

  @override
  String get hint_enterScanId => 'Enter or scan ID';

  @override
  String get label_validating => 'Validating...';

  @override
  String get warning_set_min_weight =>
      'Please configure a minimum weight in the above settings before adding cattle';

  @override
  String get label_summary => 'Summary';

  @override
  String get error_invalid_number => 'Invalid number';

  @override
  String get error_invalid_price => 'Invalid price';

  @override
  String get label_notes_optional => 'Notes (Optional)';

  @override
  String get label_transporter_optional => 'Transporter (Optional)';

  @override
  String get label_buyer_required => 'Buyer *';

  @override
  String get error_buyer_required => 'Buyer is required';

  @override
  String get label_price_per_kg_required => 'Price / Kg *';

  @override
  String get label_cattle_management => 'Cattle Management';

  @override
  String get tracker_removed => 'Tracker removed';

  @override
  String get user_usernameLengthError =>
      'Username must be between 5 and 50 characters';

  @override
  String get user_firstNameLengthError =>
      'First name must be at most 50 characters';

  @override
  String get user_lastNameLengthError =>
      'Last name must be at most 50 characters';

  @override
  String get user_passwordLengthError =>
      'Password must be between 8 and 50 characters';

  @override
  String get searchTracker => 'Search tracker...';

  @override
  String get trackerNotFound => 'Tracker not found';

  @override
  String get trackerNotSelected => 'Tracker not selected';

  @override
  String get masterListTitle => 'Cattle Master List';

  @override
  String get invalidEmail => 'Invalid email';

  @override
  String get userCreatedSuccess => 'User created successfully';

  @override
  String get userUpdatedSuccess => 'User updated successfully';

  @override
  String get userDeletedSuccess => 'User deleted successfully';

  @override
  String get userDeleteConfirmTitle => 'Delete User';

  @override
  String get userDeleteConfirmBody =>
      'Are you sure you want to delete this user? This action cannot be undone.';

  @override
  String get noUsersFound => 'No users found';

  @override
  String get error_eartagExist =>
      'Eartag number already exists for another head of cattle.';

  @override
  String get purchase_dateRequired => 'You must select a purchase date.';

  @override
  String get purchase_saveSuccess => 'Purchase saved successfully.';

  @override
  String get purchase_saveError => 'Purchase saving failed.';

  @override
  String get cp_error_noLots => 'You must add at least one lot';

  @override
  String get cp_error_providerRequired => 'Please select or create a provider.';

  @override
  String get purchase_totalCattle => 'Total cattle';

  @override
  String get noPurchasesFound => 'Purchase not found';

  @override
  String get provider_found => 'Provider found and loaded.';

  @override
  String get provider_willBeCreated =>
      'A new provider will be created with this NIT.';

  @override
  String get provider_nameIsRequired => 'Provider name is required.';

  @override
  String get provider_nitIsRequired => 'NIT is required.';

  @override
  String get provider_createdSuccessfully => 'Provider created successfully';

  @override
  String get provider_nitAlreadyExists =>
      'A provider with that NIT already exists';

  @override
  String get provider_creationError => 'Error creating provider';

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
  String get lot_avgWeightInvalid => 'Average weight must be greater than 0.';

  @override
  String get lot_pricePerKgRequired => 'Please enter the price per kilogram';

  @override
  String get lot_pricePerKgInvalid => 'Enter a valid price per kilogram';

  @override
  String get lot_cattleCountRequired =>
      'Please enter the number of cattle in the lot.';

  @override
  String get lot_cattleCountInvalid =>
      'The number of cattle in the lot must be greater than 0.';

  @override
  String get lot_totalWeightRequired => 'Please enter the total weight.';

  @override
  String get lot_totalWeightInvalid => 'Enter a valid total weight';

  @override
  String get lot_countAvWeightPriceKgRequired =>
      'Each lot must have number of cattle, average weight, and price per kg greater than zero.';

  @override
  String get simpleEventAdded => 'Detail added successfully';

  @override
  String get simpleEventError => 'An error occurred while adding the detail';

  @override
  String simpleEventApplied(Object cattleNumber) {
    return 'Active events were applied to cattle number $cattleNumber';
  }

  @override
  String get applyAtLeastOneSimpleEvent => 'You must apply at least one event.';

  @override
  String get eventsApplicationNotice =>
      'All events have been applied. If any appear as not applied, make sure you have entered all required information.';

  @override
  String get error_noSimpleEventsApplied =>
      'The massive event cannot be closed because no simple event has been applied to any animal.';

  @override
  String get error_massiveEventAlreadyClosed =>
      'This massive event is already closed and cannot be modified.';

  @override
  String get event_finishSuccess =>
      'The massive event was finished successfully.';

  @override
  String get cattle_exists_error => 'Number already exists (Active/Lost)';

  @override
  String get eartag_exists_error => 'Eartag already exists (Active/Lost)';

  @override
  String get activeDetails => 'Active events:';

  @override
  String get noActiveDetails => 'No active details';

  @override
  String get deactivateTooltip => 'Deactivate';

  @override
  String get inactiveTitle => 'Inactive:';

  @override
  String get noInactive => 'No inactive events.';

  @override
  String get reactivateTooltip => 'Reactivate';

  @override
  String onlyOneType(Object type) {
    return 'There can only be one event of type $type in this Massive Event.';
  }

  @override
  String brandAlreadyExists(Object brand) {
    return 'The brand \"$brand\" already exists in this Massive Event.';
  }

  @override
  String reactivatedInfo(Object name) {
    return '\"$name\" was reactivated.';
  }
}
