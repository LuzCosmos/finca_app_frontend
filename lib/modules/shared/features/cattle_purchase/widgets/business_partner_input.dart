import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/cattle_purchase/services/business_partner_service.dart';
import 'package:finca_app_frontend/modules/shared/features/cattle_purchase/models/business_partner.dart';
import 'package:finca_app_frontend/modules/shared/features/sales/widgets/business_partner_autocomplete_field.dart';

class BusinessPartnerInput extends StatefulWidget {
  final void Function(BusinessPartnerModel) onBusinessPartnerSelected;
  final BusinessPartnerService? businessPartnerService;
  final void Function(String message)? onError;
  final void Function(String message)? onSuccess;
  final String? initialBusinessPartnerId;
  final String? initialBusinessPartnerName;

  const BusinessPartnerInput({
    super.key,
    required this.onBusinessPartnerSelected,
    this.businessPartnerService,
    this.onError,
    this.onSuccess,
    this.initialBusinessPartnerId,
    this.initialBusinessPartnerName,
  });

  @override
  State<BusinessPartnerInput> createState() => _BusinessPartnerInputState();
}

class _BusinessPartnerInputState extends State<BusinessPartnerInput> {
  BusinessPartnerModel? _selectedBusinessPartner;

  @override
  void initState() {
    super.initState();
    if (widget.initialBusinessPartnerId != null && widget.initialBusinessPartnerName != null) {
      _selectedBusinessPartner = BusinessPartnerModel(
        id: widget.initialBusinessPartnerId!,
        name: widget.initialBusinessPartnerName!,
        nit: '',
        role: BusinessPartnerRole.PROVIDER,
      );
      widget.onBusinessPartnerSelected(_selectedBusinessPartner!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BusinessPartnerAutocompleteField(
          label: l10n.provider,
          businessPartnerRole: BusinessPartnerRole.PROVIDER.name,
          initialValue: widget.initialBusinessPartnerName,
          required: true,
          validator: (_) {
            if (_selectedBusinessPartner == null) {
              return l10n.cp_error_providerRequired;
            }
            return null;
          },
          onChanged: (id, name) {
            if (id == null || name == null) {
              setState(() => _selectedBusinessPartner = null);
              return;
            }
            final businessPartner = BusinessPartnerModel(
              id: id,
              name: name,
              nit: '',
              role: BusinessPartnerRole.PROVIDER,
            );
            setState(() => _selectedBusinessPartner = businessPartner);
            widget.onBusinessPartnerSelected(businessPartner);
          },
        ),
      ],
    );
  }
}
