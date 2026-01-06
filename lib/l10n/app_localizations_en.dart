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
  String get invalidValue => 'Invalid value.';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get numberFormat => '#,##0.##';

  @override
  String get numberFormat_country => 'en_US';

  @override
  String get fixErrors => 'Please fix the errors highlighted in red.';

  @override
  String get error_savingObject => 'An unexpected error occurred while saving.';

  @override
  String get error_badRequest =>
      'The request is invalid. Please check the data and try again.';

  @override
  String get error_unauthorized =>
      'Your session has expired or you do not have access. Please log in again.';

  @override
  String get error_forbidden =>
      'You do not have permission to perform this action.';

  @override
  String error_notFound(Object object) {
    return '$object not found.';
  }

  @override
  String get error_methodNotAllowed =>
      'This action is not allowed at the moment.';

  @override
  String get error_conflict => 'This item already exists.';

  @override
  String get error_preconditionFailed =>
      'The conditions to perform this action are not met.';

  @override
  String get error_unprocessableEntity =>
      'Some data is invalid. Please correct it and try again.';

  @override
  String get error_locked =>
      'The resource is currently locked by another operation. Please try again later.';

  @override
  String get error_tooManyRequests =>
      'You have made too many requests. Please try again later.';

  @override
  String get error_serverConnection =>
      'Unable to connect to the server. Please check your internet connection or try again later.';

  @override
  String get error_server => 'Internal server error. Please try again later.';

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
  String get home_reception => 'Reception';

  @override
  String get cattle => 'Cattle';

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
  String get purchase_totalWeightKg => 'Total weight (Kg)';

  @override
  String get purchase_totalCattle => 'Total Cattle';

  @override
  String get noPurchasesFound => 'Purchase not found';

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
  String get eventDate => 'Event Date';

  @override
  String get eventFinish => 'Finish';

  @override
  String get addEventDetail => 'Add Event';

  @override
  String get activeDetails => 'Active Events:';

  @override
  String get noActiveDetails => 'No active Events';

  @override
  String get deactivateTooltip => 'Deactivate';

  @override
  String get inactiveTitle => 'Inactive:';

  @override
  String get noInactive => 'No inactive Events';

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
  String get tableEartag => 'Eartag';

  @override
  String get tableBrand => 'Brand';

  @override
  String get tableMedication => 'Medication';

  @override
  String get tableCastration => 'Castrated';

  @override
  String get tableSynced => 'Synced';

  @override
  String get simpleEventAdded => 'Detail successfully added';

  @override
  String get simpleEventError => 'An error occurred while adding detail';

  @override
  String simpleEventApplied(Object cattleNumber) {
    return 'Active events applied to number $cattleNumber';
  }

  @override
  String get applyAtLeastOneSimpleEvent => 'Apply at least one event.';

  @override
  String get eventsApplicationNotice =>
      'All events have been applied. If any event appears unapplied, please make sure the required information is filled in.';

  @override
  String get error_noSimpleEventsApplied =>
      'The massive event cannot be closed because no simple events have been applied to any animal.';

  @override
  String get error_massiveEventAlreadyClosed =>
      'This massive event is already closed and cannot be modified.';

  @override
  String get event_finishSuccess =>
      'The massive event was successfully finished.';

  @override
  String get purchaseReceptionTitle => 'Purchase Reception';

  @override
  String get purchaseBatchesTitle => 'Purchase Lots';

  @override
  String get withoutLot => 'No lot';

  @override
  String get cattleOfSelection => 'Selected cattle';

  @override
  String get simpleEventsTitle => 'Simple events';

  @override
  String get selectAnimalHint => 'Select an animal to view its events';

  @override
  String get appliedEvents => 'Applied';

  @override
  String get availableEvents => 'Available';

  @override
  String get assignLot => 'Assign lot';

  @override
  String get receivedOk => 'Cattle received';

  @override
  String get cattleNumber => 'Number';

  @override
  String get weightKg => 'Weight (kg)';

  @override
  String get color => 'Color';

  @override
  String get characteristics => 'Characteristics';

  @override
  String get eartag => 'Eartag';

  @override
  String get trackerId => 'Tracker';

  @override
  String get addCattle => 'Add animal';

  @override
  String cattleCountLabel(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count head',
      one: '1 head',
      zero: '0 head',
    );
    return '$_temp0';
  }

  @override
  String purchaseCountLabel(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count head',
      one: '1 head',
      zero: '0 head',
    );
    return '$_temp0';
  }

  @override
  String get receptionDate => 'Reception Date';

  @override
  String get initialCattleNumber => 'Initial Cattle Number';

  @override
  String get numberInUse => 'This number is already in use';

  @override
  String get hasHorns => 'Has Horns';

  @override
  String get isCastrated => 'Is Castrated';

  @override
  String get comments => 'Comments';

  @override
  String get receiveCattle => 'Receive Cattle';

  @override
  String get purchasedAvgWeight => 'Purchased Avg Weight (kg)';

  @override
  String get receivedAvgWeight => 'Received Avg Weight (kg)';

  @override
  String get unassignedCattle => 'Cattle without Identified Lot';

  @override
  String get assignLotTitle => 'Assign Lot';

  @override
  String get selectLot => 'Select Lot';

  @override
  String get providerName => 'Provider';

  @override
  String get eventsApplied => 'Events Applied';

  @override
  String get noEventsApplied => 'No events applied';

  @override
  String get receivedCount => 'Received';

  @override
  String get purchasedCount => 'Purchased';

  @override
  String get actions => 'Actions';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get all => 'All';

  @override
  String get pending => 'Pending';

  @override
  String get received => 'Received';

  @override
  String get receiveAction => 'Receive';

  @override
  String get rowsPerPage => 'Rows per page';

  @override
  String get page => 'Page';

  @override
  String get results => 'results';

  @override
  String get previous => 'Previous';

  @override
  String get next => 'Next';

  @override
  String get receivedCattle => 'Received qty';

  @override
  String get refresh => 'Refresh';

  @override
  String get sales_title => 'Sales';

  @override
  String get sales_addSale => 'Add Sale';

  @override
  String get sales_searchPlaceholder => 'Search sales...';

  @override
  String get sales_dateRange => 'Date Range';

  @override
  String get sales_clearFilters => 'Clear Filters';

  @override
  String get sales_rowsPerPage => 'Rows per page:';

  @override
  String get sales_refresh => 'Refresh';

  @override
  String get sales_noData => 'No sales data available';

  @override
  String get sales_noDataFiltered => 'No sales found with the current filters';

  @override
  String get sales_tryAdjustFilters => 'Try adjusting your filters';

  @override
  String get sales_createFirstSale => 'Create your first sale to get started';

  @override
  String get sales_date => 'Date';

  @override
  String get sales_buyer => 'Buyer';

  @override
  String get sales_items => 'Items';

  @override
  String get sales_weight => 'Weight (kg)';

  @override
  String get sales_amount => 'Amount';

  @override
  String get sales_actions => 'Actions';

  @override
  String get sales_viewDetails => 'View Details';

  @override
  String get sales_edit => 'Edit';

  @override
  String get sales_page => 'Page';

  @override
  String get sales_of => 'of';

  @override
  String get sales_showing => 'Showing';

  @override
  String get sales_editSale => 'Edit Sale';

  @override
  String get sales_saleDetails => 'Sale Details';

  @override
  String get sales_transactionDate => 'Transaction Date';

  @override
  String get sales_totalAmount => 'Total Amount';

  @override
  String get sales_totalWeight => 'Total Weight';

  @override
  String get sales_animals => 'Animals';

  @override
  String get sales_notes => 'Notes';

  @override
  String get sales_cattleList => 'Cattle List';

  @override
  String get sales_noDetails => 'No details available.';

  @override
  String get sales_cattleId => 'Cattle ID';

  @override
  String get sales_price => 'Price';

  @override
  String get sales_close => 'Close';

  @override
  String get sales_cancel => 'Cancel';

  @override
  String get sales_save => 'Save';

  @override
  String get sales_errorLoading => 'Error loading sales';

  @override
  String get sales_retry => 'Retry';

  @override
  String get sales_previousPage => 'Previous Page';

  @override
  String get sales_nextPage => 'Next Page';

  @override
  String get provider_selectOrCreate => 'Select or create provider';

  @override
  String get provider_searchByName => 'Search by name...';

  @override
  String get provider_createNew => 'Create New Provider';

  @override
  String get provider_providerName => 'Provider Name';

  @override
  String get provider_address => 'Address';

  @override
  String get provider_contactPersonName => 'Contact Person Name';

  @override
  String get provider_phone1 => 'Phone 1';

  @override
  String get provider_phone2 => 'Phone 2 (Optional)';

  @override
  String get provider_email => 'Email';

  @override
  String get provider_buyer => 'Buyer';

  @override
  String get provider_transporter => 'Transporter';

  @override
  String get provider_providerType => 'Provider Type';

  @override
  String get provider_creating => 'Creating...';

  @override
  String get provider_createdSuccess => 'Provider created successfully';

  @override
  String get provider_createError => 'Error creating provider';

  @override
  String get cattle_validation_validating => 'Validating cattle...';

  @override
  String get cattle_validation_invalid => 'Invalid cattle number';

  @override
  String get cattle_validation_notFound => 'Cattle not found for this tenant';

  @override
  String get cattle_validation_notActive => 'Cattle is not ACTIVE';

  @override
  String get cattle_validation_sold => 'This cattle has already been sold';

  @override
  String get cattle_validation_dead => 'This cattle is marked as dead';

  @override
  String get cattle_validation_lost => 'This cattle is marked as lost';

  @override
  String get cattle_number => 'Cattle Number';

  @override
  String get cattle_weight => 'Weight (kg)';

  @override
  String get cattle_addButton => 'Add';

  @override
  String get cattle_weightUnderMin => 'Weight Below Minimum';

  @override
  String cattle_weightUnderMinMessage(Object measured, Object min) {
    return 'The measured weight ($measured kg) is below the minimum weight ($min kg). This cattle will receive the minimum weight for pricing.';
  }

  @override
  String get cattle_approveQuestion =>
      'Do you want to approve or reject this cattle?';

  @override
  String get cattle_approve => 'Approve';

  @override
  String get cattle_reject => 'Reject';

  @override
  String get cattle_approved_title => 'Approved Cattle';

  @override
  String get cattle_rejected_title => 'Rejected Cattle';

  @override
  String cattle_approved_count(Object count) {
    return 'Approved ($count)';
  }

  @override
  String cattle_rejected_count(Object count) {
    return 'Rejected ($count)';
  }

  @override
  String get cattle_noApproved => 'No approved cattle yet';

  @override
  String get cattle_noRejected => 'No rejected cattle';

  @override
  String get cattle_remove => 'Remove';

  @override
  String get cattle_rejectionReason => 'Underweight';

  @override
  String get sale_confirm_title => 'Confirm Sale Creation';

  @override
  String sale_confirm_message(Object count) {
    return 'The following $count approved cattle will be marked as SOLD:';
  }

  @override
  String get sale_confirm_warning => 'This action cannot be undone. Continue?';

  @override
  String get sale_confirm_proceed => 'Confirm & Create Sale';

  @override
  String get sale_creating => 'Creating sale...';

  @override
  String get sale_created => 'Sale created successfully';

  @override
  String get sale_createError => 'Error creating sale';

  @override
  String get user_editUser => 'Edit User';

  @override
  String get user_logout => 'Logout';

  @override
  String get user_editUserPageTitle => 'Edit User';

  @override
  String get user_editUserPageMessage => 'This feature is under development';

  @override
  String get newSale => 'New Sale';

  @override
  String get saleSavedSuccess => 'Sale saved successfully';

  @override
  String get cattleFoundPending => 'Cattle found (Implementation pending)';

  @override
  String get minWeightKg => 'Min Weight (Kg)';

  @override
  String get scanEnterNumber => 'Scan/Enter Number';

  @override
  String get salesDashboard => 'Sales Dashboard';

  @override
  String get noOfflineSales => 'No offline sales pending sync.';

  @override
  String saleWithDate(String date) {
    return 'Sale $date';
  }

  @override
  String totalWithAmount(String amount) {
    return 'Total: $amount';
  }

  @override
  String get label_measuredWeight => 'Measured Weight';

  @override
  String get label_minimumWeight => 'Minimum Weight';

  @override
  String get label_totalCattle => 'Total Cattle';

  @override
  String get error_enterCattleNumberWeight =>
      'Please enter cattle number and weight';

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
      'Please set a minimum weight in the pricing configuration above before adding cattle';

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
}
