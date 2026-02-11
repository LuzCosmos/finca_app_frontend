import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:finca_app_frontend/core/services/basic_api_service.dart';
import 'package:finca_app_frontend/modules/web/features/cattle_purchase/models/provider.dart';

/// Provider Autocomplete Field with Create Dialog
///
/// Features:
/// - Search providers by name as user types
/// - Filter by provider type (BUYER/TRANSPORTER)
/// - "Create New Provider" option in dropdown
/// - Opens CreateProviderDialog on create
/// - Returns selected/created provider ID
class ProviderAutocompleteField extends StatefulWidget {
  final String label;
  final String providerType; // 'BUYER' or 'TRANSPORTER'
  final String? initialValue;
  final Function(String? providerId, String? providerName) onChanged;
  final String? Function(String?)? validator;
  final bool required;

  const ProviderAutocompleteField({
    super.key,
    required this.label,
    required this.providerType,
    required this.onChanged,
    this.initialValue,
    this.validator,
    this.required = false,
  });

  @override
  State<ProviderAutocompleteField> createState() =>
      _ProviderAutocompleteFieldState();
}

class _ProviderAutocompleteFieldState extends State<ProviderAutocompleteField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  List<Map<String, dynamic>> _providers = [];
  bool _isLoading = false;
  bool _showDropdown = false;
  String? _selectedProviderId;
  String? _selectedProviderName;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _onSearchChanged() async {
    final query = _controller.text.trim();

    if (query.isEmpty) {
      setState(() {
        _providers = [];
        _showDropdown = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _showDropdown = true;
    });

    try {
      final providers = await _searchProviders(query);
      setState(() {
        _providers = providers;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _providers = [];
      });
    }
  }

  Future<List<Map<String, dynamic>>> _searchProviders(String name) async {
    final token = await BasicApiService.getToken();
    final baseUrl = BasicApiService.getApiBaseUrl();

    final response = await http.get(
      Uri.parse(
        '$baseUrl/providers/search?name=$name&type=${widget.providerType}',
      ),
      headers: {'Authorization': 'Bearer $token'},
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

  void _selectProvider(String id, String name) {
    setState(() {
      _selectedProviderId = id;
      _selectedProviderName = name;
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
          (context) => CreateProviderDialog(providerType: widget.providerType),
    );

    if (result != null && mounted) {
      _selectProvider(result['id'], result['name']);

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.provider_createdSuccess(_providerTypeLabel)),
          ),
        );
      }
    }
  }

  String get _providerTypeLabel {
    final l10n = AppLocalizations.of(context)!;
    var providerTypeLabel = '';
    if (widget.providerType == ProviderType.BUYER.name) {
      providerTypeLabel = l10n.buyer;
    } else if (widget.providerType == ProviderType.TRANSPORTER.name) {
      providerTypeLabel = l10n.transporter;
    } else if (widget.providerType == ProviderType.PROVIDER.name) {
      providerTypeLabel = l10n.provider;
    }
    return providerTypeLabel;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    var providerTypeLabel = _providerTypeLabel;
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
                    _providers.isEmpty && !_isLoading
                        ? ListTile(
                          leading: const Icon(
                            Icons.add_circle,
                            color: Colors.green,
                          ),
                          title: Text(l10n.createNewSomething(providerTypeLabel)),
                          onTap: () {
                            _focusNode.unfocus();
                            _showCreateDialog();
                          },
                        )
                        : ListView(
                          shrinkWrap: true,
                          children: [
                            ..._providers.map(
                              (provider) => ListTile(
                                title: Text(provider['name']),
                                subtitle: Text(
                                  '${l10n.nit}: ${provider['nit']}',
                                ),
                                onTap:
                                    () => _selectProvider(
                                      provider['id'],
                                      provider['name'],
                                    ),
                              ),
                            ),
                            const Divider(),
                            ListTile(
                              leading: const Icon(
                                Icons.add_circle,
                                color: Colors.green,
                              ),
                              title: Text(l10n.createNewSomething(providerTypeLabel)),
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
class CreateProviderDialog extends StatefulWidget {
  final String providerType;

  const CreateProviderDialog({super.key, required this.providerType});

  @override
  State<CreateProviderDialog> createState() => _CreateProviderDialogState();
}

class _CreateProviderDialogState extends State<CreateProviderDialog> {
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

  String get _providerTypeLabel {
    final l10n = AppLocalizations.of(context)!;
    var providerTypeLabel = '';
    if (widget.providerType == ProviderType.BUYER.name) {
      providerTypeLabel = l10n.buyer;
    } else if (widget.providerType == ProviderType.TRANSPORTER.name) {
      providerTypeLabel = l10n.transporter;
    } else if (widget.providerType == ProviderType.PROVIDER.name) {
      providerTypeLabel = l10n.provider;
    }
    return providerTypeLabel;
  }

  Future<void> _createProvider() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isCreating = true);

    try {
      final token = await BasicApiService.getToken();
      final baseUrl = BasicApiService.getApiBaseUrl();

      final response = await http.post(
        Uri.parse('$baseUrl/providers'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': _nameController.text.trim(),
          'nit': _nitController.text.trim(),
          'type': widget.providerType,
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
            content: Text(l10n.provider_createError(_providerTypeLabel)),
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
    final providerTypeLabel = _providerTypeLabel;

    return AlertDialog(
      title: Text(l10n.createNewSomething(providerTypeLabel)),
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
                        '${l10n.provider_providerName(providerTypeLabel)} *',
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
          onPressed: _isCreating ? null : _createProvider,
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
