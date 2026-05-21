import 'dart:async';
import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'dart:convert';
import 'package:finca_app_frontend/core/services/basic_api_service.dart';
import 'package:finca_app_frontend/modules/shared/features/cattle_purchase/models/business_partner.dart';

/// Provider Autocomplete Field with Create Dialog
///
/// Features:
/// - Search providers by name as user types
/// - Filter by provider type (BUYER/TRANSPORTER)
/// - "Create New Provider" option in dropdown
/// - Opens CreateBusinessPartnerDialog on create
/// - Returns selected/created provider ID
class BusinessPartnerAutocompleteField extends StatefulWidget {
  final String label;
  final String businessPartnerRole; // 'BUYER' or 'TRANSPORTER'
  final String? initialValue;
  final Function(String? businessPartnerId, String? businessPartnerName) onChanged;
  final String? Function(String?)? validator;
  final bool required;

  const BusinessPartnerAutocompleteField({
    super.key,
    required this.label,
    required this.businessPartnerRole,
    required this.onChanged,
    this.initialValue,
    this.validator,
    this.required = false,
  });

  @override
  State<BusinessPartnerAutocompleteField> createState() =>
      _BusinessPartnerAutocompleteFieldState();
}

class _BusinessPartnerAutocompleteFieldState extends State<BusinessPartnerAutocompleteField> {
  static const Duration _searchDebounceDuration = Duration(milliseconds: 350);
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _searchDebounce;
  int _searchRequestId = 0;

  List<Map<String, dynamic>> _businessPartners = [];
  bool _isLoading = false;
  bool _showDropdown = false;
  String? _selectedBusinessPartnerId;
  String? _selectedBusinessPartnerName;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null && widget.initialValue!.isNotEmpty) {
      _controller.text = widget.initialValue!;
    }
    _controller.addListener(_onSearchInputChanged);
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchInputChanged() {
    _searchDebounce?.cancel();
    final query = _controller.text.trim();
    final currentRequestId = ++_searchRequestId;

    if (query.isEmpty) {
      setState(() {
        _businessPartners = [];
        _isLoading = false;
        _showDropdown = false;
      });
      return;
    }

    _searchDebounce = Timer(_searchDebounceDuration, () {
      _performSearch(query, currentRequestId);
    });
  }

  Future<void> _performSearch(String query, int requestId) async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _showDropdown = true;
    });

    try {
      final providers = await _searchBusinessPartners(query);
      if (!mounted || requestId != _searchRequestId) return;
      setState(() {
        _businessPartners = providers;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted || requestId != _searchRequestId) return;
      setState(() {
        _isLoading = false;
        _businessPartners = [];
      });
    }
  }

  Future<List<Map<String, dynamic>>> _searchBusinessPartners(String name) async {
    final baseUrl = BasicApiService.getApiBaseUrl();

    final response = await BasicApiService.authorizedGet(
      Uri.parse(
        '$baseUrl/business-partners/search?name=$name&type=${widget.businessPartnerRole}',
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map(
            (p) => {
              'id': p['id'],
              'name': p['name'],
              'nit': p['nit'],
              'type': p['type'],
            },
          )
          .toList();
    } else {
      throw Exception('Failed to search providers');
    }
  }

  void _selectBusinessPartner(String id, String name) {
    setState(() {
      _selectedBusinessPartnerId = id;
      _selectedBusinessPartnerName = name;
      _controller.text = name;
      _showDropdown = false;
    });
    widget.onChanged(id, name);
  }

  Future<void> _showCreateDialog() async {
    final l10n = AppLocalizations.of(context)!;

    // Unfocus and hide dropdown before showing dialog
    _focusNode.unfocus();
    setState(() => _showDropdown = false);

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: true,
      builder:
          (context) => CreateBusinessPartnerDialog(businessPartnerRole: widget.businessPartnerRole),
    );

    if (result != null && mounted) {
      _selectBusinessPartner(result['id'], result['name']);

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.provider_createdSuccess(_businessPartnerRoleLabel)),
          ),
        );
      }
    }
  }

  String get _businessPartnerRoleLabel {
    final l10n = AppLocalizations.of(context)!;
    var businessPartnerRoleLabel = '';
    if (widget.businessPartnerRole == BusinessPartnerRole.BUYER.name) {
      businessPartnerRoleLabel = l10n.buyer;
    } else if (widget.businessPartnerRole == BusinessPartnerRole.TRANSPORTER.name) {
      businessPartnerRoleLabel = l10n.transporter;
    } else if (widget.businessPartnerRole == BusinessPartnerRole.PROVIDER.name) {
      businessPartnerRoleLabel = l10n.provider;
    }
    return businessPartnerRoleLabel;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    var businessPartnerRoleLabel = _businessPartnerRoleLabel;
    return TapRegion(
      onTapOutside: (event) {
        if (_showDropdown) {
          setState(() {
            _showDropdown = false;
          });
          _focusNode.unfocus();
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _controller,
            focusNode: _focusNode,
            decoration: InputDecoration(
              labelText: widget.label,
              border: const OutlineInputBorder(),
              suffixIcon:
                  _isLoading
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                      : const Icon(Icons.search),
              hintText: l10n.provider_searchByName,
            ),
            validator: widget.validator,
          ),

          // Dropdown overlay
          if (_showDropdown)
            Material(
              elevation: 4,
              child: Container(
                constraints: const BoxConstraints(maxHeight: 200),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4),
                ),
                child:
                    _businessPartners.isEmpty && !_isLoading
                        ? ListTile(
                          leading: const Icon(
                            Icons.add_circle,
                            color: Colors.green,
                          ),
                          title: Text(l10n.createNewSomething(businessPartnerRoleLabel)),
                          onTap: () {
                            _focusNode.unfocus();
                            _showCreateDialog();
                          },
                        )
                        : ListView(
                          shrinkWrap: true,
                          children: [
                            ..._businessPartners.map(
                              (businessPartner) => ListTile(
                                title: Text(businessPartner['name']),
                                subtitle: Text(
                                  '${l10n.nit}: ${businessPartner['nit']}',
                                ),
                                onTap:
                                    () => _selectBusinessPartner(
                                      businessPartner['id'],
                                      businessPartner['name'],
                                    ),
                              ),
                            ),
                            const Divider(),
                            ListTile(
                              leading: const Icon(
                                Icons.add_circle,
                                color: Colors.green,
                              ),
                              title: Text(l10n.createNewSomething(businessPartnerRoleLabel)),
                              onTap: () {
                                _focusNode.unfocus();
                                _showCreateDialog();
                              },
                            ),
                          ],
                        ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Create Provider Dialog
///
/// Allows creating a new provider with:
/// - Name, NIT (required)
/// - Type (auto-filled, readonly)
/// - Address (optional)
/// - Contact person details (optional)
class CreateBusinessPartnerDialog extends StatefulWidget {
  final String businessPartnerRole;

  const CreateBusinessPartnerDialog({super.key, required this.businessPartnerRole});

  @override
  State<CreateBusinessPartnerDialog> createState() => _CreateBusinessPartnerDialogState();
}

class _CreateBusinessPartnerDialogState extends State<CreateBusinessPartnerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nitController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactNameController = TextEditingController();
  final _phone1Controller = TextEditingController();
  final _phone2Controller = TextEditingController();
  final _emailController = TextEditingController();

  bool _isCreating = false;

  @override
  void dispose() {
    _nameController.dispose();
    _nitController.dispose();
    _addressController.dispose();
    _contactNameController.dispose();
    _phone1Controller.dispose();
    _phone2Controller.dispose();
    _emailController.dispose();
    super.dispose();
  }

  String get _businessPartnerRoleLabel {
    final l10n = AppLocalizations.of(context)!;
    var businessPartnerRoleLabel = '';
    if (widget.businessPartnerRole == BusinessPartnerRole.BUYER.name) {
      businessPartnerRoleLabel = l10n.buyer;
    } else if (widget.businessPartnerRole == BusinessPartnerRole.TRANSPORTER.name) {
      businessPartnerRoleLabel = l10n.transporter;
    } else if (widget.businessPartnerRole == BusinessPartnerRole.PROVIDER.name) {
      businessPartnerRoleLabel = l10n.provider;
    }
    return businessPartnerRoleLabel;
  }

  Future<void> _createBusinessPartner() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isCreating = true);

    try {
      final baseUrl = BasicApiService.getApiBaseUrl();

      final response = await BasicApiService.authorizedPost(
        Uri.parse('$baseUrl/business-partners'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': _nameController.text.trim(),
          'nit': _nitController.text.trim(),
          'type': widget.businessPartnerRole,
          'address':
              _addressController.text.trim().isEmpty
                  ? null
                  : _addressController.text.trim(),
          'contactPersonName':
              _contactNameController.text.trim().isEmpty
                  ? null
                  : _contactNameController.text.trim(),
          'phone1':
              _phone1Controller.text.trim().isEmpty
                  ? null
                  : _phone1Controller.text.trim(),
          'phone2':
              _phone2Controller.text.trim().isEmpty
                  ? null
                  : _phone2Controller.text.trim(),
          'email':
              _emailController.text.trim().isEmpty
                  ? null
                  : _emailController.text.trim(),
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        if (mounted) {
          Navigator.of(context).pop({'id': data['id'], 'name': data['name']});
        }
      } else {
        throw Exception('Failed to create provider');
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.provider_createError(_businessPartnerRoleLabel)),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isCreating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final businessPartnerRoleLabel = _businessPartnerRoleLabel;

    return AlertDialog(
      title: Text(l10n.createNewSomething(businessPartnerRoleLabel)),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Provider Name
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText:
                        '${l10n.provider_providerName(businessPartnerRoleLabel)} *',
                    border: const OutlineInputBorder(),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return (l10n.fieldRequired);
                    }
                    if (val.trim().length < 3 || val.trim().length > 50) {
                      return (l10n.provider_nameLengthError);
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // NIT
                TextFormField(
                  controller: _nitController,
                  decoration: InputDecoration(
                    labelText: '${l10n.nit} *',
                    border: const OutlineInputBorder(),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return (l10n.fieldRequired);
                    }
                    if (val.trim().length < 5 || val.trim().length > 20) {
                      return (l10n.provider_nitLengthError);
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Address
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: l10n.address,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),

                // Contact Section
                Text(
                  l10n.contactPersonName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _contactNameController,
                  decoration: InputDecoration(
                    labelText: l10n.contactPersonName,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _phone1Controller,
                  decoration: InputDecoration(
                    labelText: l10n.phone1,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _phone2Controller,
                  decoration: InputDecoration(
                    labelText: l10n.phone2,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: l10n.email,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isCreating ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: _isCreating ? null : _createBusinessPartner,
          child:
              _isCreating
                  ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                  : Text(l10n.create),
        ),
      ],
    );
  }
}
