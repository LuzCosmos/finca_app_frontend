import 'package:finca_app_frontend/l10n/app_localizations.dart';

class ImportLw001ReasonLocalizations {
  const ImportLw001ReasonLocalizations._();

  static String message(AppLocalizations l10n, String reasonCode) {
    switch (reasonCode) {
      case 'IMPORT_HEADERS_INVALID':
        return l10n.importLw001_reason_IMPORT_HEADERS_INVALID;
      case 'DEVEUI_INVALID_LENGTH':
        return l10n.importLw001_reason_DEVEUI_INVALID_LENGTH;
      case 'DEVEUI_DUPLICATE_IN_FILE_UPDATED':
        return l10n.importLw001_reason_DEVEUI_DUPLICATE_IN_FILE_UPDATED;
      case 'DEVEUI_ALREADY_EXISTS_UPDATED':
        return l10n.importLw001_reason_DEVEUI_ALREADY_EXISTS_UPDATED;
      case 'DEVICE_PROFILE_ID_REQUIRED':
        return l10n.importLw001_reason_DEVICE_PROFILE_ID_REQUIRED;
      case 'DEVICE_PROFILE_ID_INVALID':
        return l10n.importLw001_reason_DEVICE_PROFILE_ID_INVALID;
      case 'CHIRPSTACK_PROFILE_ID_REQUIRED':
        return l10n.importLw001_reason_CHIRPSTACK_PROFILE_ID_REQUIRED;
      case 'JOINEUI_INVALID':
        return l10n.importLw001_reason_JOINEUI_INVALID;
      case 'APP_KEY_INVALID':
        return l10n.importLw001_reason_APP_KEY_INVALID;
      case 'APP_KEY_SCIENTIFIC_NOTATION':
        return l10n.importLw001_reason_APP_KEY_SCIENTIFIC_NOTATION;
      case 'NWK_KEY_INVALID':
        return l10n.importLw001_reason_NWK_KEY_INVALID;
      case 'UNSUPPORTED_FILE_FORMAT':
        return l10n.importLw001_reason_UNSUPPORTED_FILE_FORMAT;
      case 'FILE_EMPTY':
        return l10n.importLw001_reason_FILE_EMPTY;
      case 'ROW_PROCESS_FAILED':
        return l10n.importLw001_reason_ROW_PROCESS_FAILED;
      default:
        return l10n.importLw001_reason_unknown(reasonCode);
    }
  }
}
