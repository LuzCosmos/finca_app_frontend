import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/models/import_lw001_result_model.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/services/device_api_service.dart';
import 'package:finca_app_frontend/modules/shared/features/devices/utils/import_lw001_reason_localizations.dart';
import 'package:finca_app_frontend/modules/shared/widgets/finca_scaffold.dart';
import 'package:finca_app_frontend/modules/shared/widgets/message_banner.dart';
import 'package:go_router/go_router.dart';

class ImportLw001DevicesPage extends StatefulWidget {
  const ImportLw001DevicesPage({super.key});

  @override
  State<ImportLw001DevicesPage> createState() => _ImportLw001DevicesPageState();
}

class _ImportLw001DevicesPageState extends State<ImportLw001DevicesPage> {
  List<DeviceProfileOption> _profiles = [];
  String? _selectedProfileId;
  String? _pickedFileName;
  List<int>? _pickedFileBytes;
  bool _loadingProfiles = true;
  bool _submitting = false;
  String? _error;
  ImportLw001ResultModel? _result;

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    setState(() {
      _loadingProfiles = true;
      _error = null;
    });
    try {
      final profiles = await DeviceApiService.listDeviceProfiles();
      if (!mounted) return;
      setState(() {
        _profiles = profiles;
        if (profiles.length == 1) {
          _selectedProfileId = profiles.first.id;
        }
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
    } catch (_) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      setState(() => _error = l10n.devicesList_errorGeneric);
    } finally {
      if (mounted) setState(() => _loadingProfiles = false);
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls', 'csv'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.single;
    final bytes = file.bytes;
    if (bytes == null) return;
    setState(() {
      _pickedFileName = file.name;
      _pickedFileBytes = bytes;
      _result = null;
      _error = null;
    });
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    if (_pickedFileBytes == null || _pickedFileName == null) {
      setState(() => _error = l10n.importLw001_fileRequired);
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });

    try {
      final result = await DeviceApiService.importLw001(
        fileBytes: _pickedFileBytes!,
        filename: _pickedFileName!,
        deviceProfileId:
            (_selectedProfileId != null && _selectedProfileId!.isNotEmpty)
            ? _selectedProfileId
            : null,
      );
      if (!mounted) return;
      setState(() => _result = result);
    } on ApiException catch (e) {
      if (!mounted) return;
      final message = ImportLw001ReasonLocalizations.message(l10n, e.code);
      setState(() => _error = message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = l10n.devicesList_errorGeneric);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return FincaScaffold(
      title: l10n.importLw001_pageTitle,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_error != null) ...[
              MessageBanner.error(_error!),
              const SizedBox(height: 12),
            ],
            Text(l10n.importLw001_helpIntro),
            const SizedBox(height: 8),
            Text(
              l10n.importLw001_helpHeadersList,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 12),
            Text(l10n.importLw001_helpOptionalCells),
            const SizedBox(height: 12),
            Text(l10n.importLw001_helpMultiSheet),
            const SizedBox(height: 24),
            if (_loadingProfiles)
              const Center(child: CircularProgressIndicator())
            else
              DropdownButtonFormField<String>(
                initialValue: _selectedProfileId,
                decoration: InputDecoration(
                  labelText: l10n.importLw001_defaultProfile,
                  border: const OutlineInputBorder(),
                ),
                items: _profiles
                    .map(
                      (p) => DropdownMenuItem<String>(
                        value: p.id,
                        child: Text(p.name),
                      ),
                    )
                    .toList(),
                onChanged: _submitting
                    ? null
                    : (value) => setState(() => _selectedProfileId = value),
              ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _submitting ? null : _pickFile,
              icon: const Icon(Icons.upload_file),
              label: Text(l10n.importLw001_selectFile),
            ),
            if (_pickedFileName != null) ...[
              const SizedBox(height: 8),
              Text(_pickedFileName!, style: Theme.of(context).textTheme.bodySmall),
            ],
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _submitting ? null : _submit,
              icon: _submitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.cloud_upload_outlined),
              label: Text(l10n.importLw001_submit),
            ),
            if (_result != null) ...[
              const SizedBox(height: 24),
              _ImportSummary(result: _result!, l10n: l10n),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.pop(true),
                child: Text(l10n.importLw001_backToList),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ImportSummary extends StatelessWidget {
  const _ImportSummary({required this.result, required this.l10n});

  final ImportLw001ResultModel result;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.importLw001_summaryTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(l10n.importLw001_summaryTotalRows(result.totalRows)),
            Text(l10n.importLw001_summaryCreated(result.created)),
            Text(l10n.importLw001_summaryUpdated(result.updated)),
            if (result.duplicateDeveuisInFile.isNotEmpty)
              Text(
                l10n.importLw001_summaryDuplicates(
                  result.duplicateDeveuisInFile.join(', '),
                ),
              ),
            if (result.warnings.isNotEmpty) ...[
              const SizedBox(height: 12),
              for (final issue in result.warnings)
                ListTile(
                  leading: const Icon(Icons.warning_amber_outlined),
                  dense: true,
                  title: Text(
                    l10n.importLw001_rowIssue(
                      issue.row,
                      ImportLw001ReasonLocalizations.message(l10n, issue.reason),
                    ),
                  ),
                  subtitle: issue.detail != null ? Text(issue.detail!) : null,
                ),
            ],
            if (result.errors.isNotEmpty) ...[
              const SizedBox(height: 12),
              for (final issue in result.errors)
                ListTile(
                  leading: Icon(
                    Icons.error_outline,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  dense: true,
                  title: Text(
                    l10n.importLw001_rowIssue(
                      issue.row,
                      ImportLw001ReasonLocalizations.message(l10n, issue.reason),
                    ),
                  ),
                  subtitle: issue.detail != null ? Text(issue.detail!) : null,
                ),
            ],
          ],
        ),
      ),
    );
  }
}
