import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/widgets/finca_scaffold.dart';
import 'package:finca_app_frontend/modules/shared/widgets/message_banner.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';
import '../models/user_model.dart';
import '../models/role_model.dart';
import '../services/users_api_service.dart';

class UserFormPage extends StatefulWidget {
  final UserModel? user; // If null, create mode

  const UserFormPage({super.key, this.user});

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _api = UsersApiService();

  late TextEditingController _usernameCtrl;
  late TextEditingController _firstNameCtrl;
  late TextEditingController _lastNameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _passwordCtrl;
  late TextEditingController _confirmPasswordCtrl;

  List<RoleModel> _availableRoles = [];
  RoleModel? _selectedRole;
  bool _loadingRoles = true;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _usernameCtrl = TextEditingController(text: widget.user?.username ?? '');
    _firstNameCtrl = TextEditingController(text: widget.user?.firstName ?? '');
    _lastNameCtrl = TextEditingController(text: widget.user?.lastName ?? '');
    _emailCtrl = TextEditingController(text: widget.user?.email ?? '');
    _passwordCtrl = TextEditingController();
    _confirmPasswordCtrl = TextEditingController();

    _loadRoles();
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadRoles() async {
    try {
      final roles = await _api.getRoles();
      setState(() {
        _availableRoles = roles;
        _loadingRoles = false;

        if (widget.user != null && widget.user!.roles.isNotEmpty) {
          // Preselect role if editing
          // Assumes single role selection for now as per "roleIds" array request but dropdown implies separate handling
          // User request said "cargar los roles como un dropdown", usually single selection but API sends array "roleIds".
          // I will support single role selection in UI for now, sending array of 1 ID.
          final userRoleId = widget.user!.roles.first.id;
          try {
            _selectedRole = roles.firstWhere((r) => r.id == userRoleId);
          } catch (_) {}
        }
      });
    } on ApiException catch (e) {
      if (mounted) {
        final code = ApiExceptionCode.fromString(e.code);
        setState(() {
          _error = code.asText(
            context,
            objectName: AppLocalizations.of(context)!.role,
          ); // roles or generic?
          _loadingRoles = false;
        });
      }
      debugPrint('Load roles error: $e');
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loadingRoles = false;
      });
      debugPrint(e.toString());
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedRole == null) {
      setState(() => _error = AppLocalizations.of(context)!.fieldRequired);
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      final roleIds = [_selectedRole!.id];
      final Map<String, dynamic> data = {
        'username': _usernameCtrl.text.trim(),
        'firstName': _firstNameCtrl.text.trim(),
        'lastName': _lastNameCtrl.text.trim(),
        'email': _emailCtrl.text.trim(),
        'roleIds': roleIds,
      };

      if (widget.user == null) {
        // Create
        data['password'] = _passwordCtrl.text;
        await _api.create(data);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.userCreatedSuccess),
            ),
          );
          Navigator.pop(context, true);
        }
      } else {
        // Update
        if (_passwordCtrl.text.isNotEmpty) {
          data['password'] = _passwordCtrl.text;
        }
        await _api.update(widget.user!.id, data);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.userUpdatedSuccess),
            ),
          );
          Navigator.pop(context, true);
        }
      }
    } on ApiException catch (e) {
      if (mounted) {
        final code = ApiExceptionCode.fromString(e.code);
        final errorText = code.asText(
          context,
          objectName: AppLocalizations.of(context)!.users,
        );
        setState(() => _error = errorText);
      }
      debugPrint('User form error: $e'); // Log to console
    } catch (e) {
      setState(() => _error = e.toString());
      debugPrint(e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = widget.user != null;

    return FincaScaffold(
      title: isEditing ? l10n.editSomething(l10n.user) : l10n.createSomething(l10n.user),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_error != null) MessageBanner.error(_error!),
              const SizedBox(height: 16),

              TextFormField(
                controller: _usernameCtrl,
                decoration: InputDecoration(labelText: l10n.username),
                validator: (v) {
                  if (v == null || v.isEmpty) return l10n.fieldRequired;
                  if (v.length < 5 || v.length > 50) {
                    return l10n.user_usernameLengthError;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _firstNameCtrl,
                decoration: InputDecoration(labelText: l10n.firstName),
                validator: (v) {
                  if (v == null || v.isEmpty) return l10n.fieldRequired;
                  if (v.length > 50) return l10n.user_firstNameLengthError;
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _lastNameCtrl,
                decoration: InputDecoration(labelText: l10n.lastName),
                validator: (v) {
                  if (v == null || v.isEmpty) return l10n.fieldRequired;
                  if (v.length > 50) return l10n.user_lastNameLengthError;
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _emailCtrl,
                decoration: InputDecoration(labelText: l10n.email),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.isEmpty) return l10n.fieldRequired;
                  // Basic email validation
                  if (!v.contains('@') || !v.contains('.')) {
                    return l10n.invalidEmail;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              if (_loadingRoles)
                const Center(child: CircularProgressIndicator())
              else
                DropdownButtonFormField<RoleModel>(
                  initialValue: _selectedRole,
                  decoration: InputDecoration(labelText: l10n.role),
                  items:
                      _availableRoles.map((r) {
                        return DropdownMenuItem(value: r, child: Text(r.name));
                      }).toList(),
                  onChanged: (v) => setState(() => _selectedRole = v),
                  validator: (v) => v == null ? l10n.fieldRequired : null,
                ),
              const SizedBox(height: 16),

              if (!isEditing) ...[
                TextFormField(
                  controller: _passwordCtrl,
                  decoration: InputDecoration(labelText: l10n.password),
                  obscureText: true,
                  validator: (v) {
                    if (v == null || v.isEmpty) return l10n.fieldRequired;
                    if (v.length < 8 || v.length > 50) {
                      return l10n.user_passwordLengthError;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordCtrl,
                  decoration: InputDecoration(labelText: l10n.confirmPassword),
                  obscureText: true,
                  validator: (v) {
                    if (v != _passwordCtrl.text) return l10n.passwordMismatch;
                    return null;
                  },
                ),
              ],
              if (isEditing) ...[
                TextFormField(
                  controller: _passwordCtrl,
                  decoration: InputDecoration(
                    labelText: '${l10n.password} (${l10n.optional})',
                  ),
                  obscureText: true,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),
                if (_passwordCtrl.text.isNotEmpty) ...[
                  TextFormField(
                    controller: _confirmPasswordCtrl,
                    decoration: InputDecoration(labelText: l10n.confirmPassword),
                    obscureText: true,
                    validator: (v) {
                      if (v != _passwordCtrl.text) return l10n.passwordMismatch;
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ],

              const SizedBox(height: 24),
              FilledButton(
                onPressed: _saving ? null : _save,
                child:
                    _saving
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(l10n.save),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
