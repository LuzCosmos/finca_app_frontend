import 'package:flutter/material.dart';
import 'package:finca_app_frontend/l10n/app_localizations.dart';
import 'package:finca_app_frontend/modules/shared/widgets/finca_scaffold.dart';
import 'package:finca_app_frontend/modules/shared/widgets/message_banner.dart';
import 'package:finca_app_frontend/core/services/api_exception.dart';
import '../models/user_model.dart';
import '../services/users_api_service.dart';
import 'user_form_page.dart';

class UsersListPage extends StatefulWidget {
  const UsersListPage({super.key});

  @override
  State<UsersListPage> createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  final _api = UsersApiService();
  static const _allowedPageSizes = [10, 20, 50, 100];

  // Filters
  final _usernameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();

  // Pagination
  int _page = 1;
  int _limit = 10;
  int _total = 0;
  bool _loading = true;
  String? _error;
  
  List<UserModel> _items = [];
  bool _didInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInit) {
      _didInit = true;
      _load();
    }
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _lastNameCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final res = await _api.list(
        page: _page, 
        limit: _limit,
        username: _usernameCtrl.text.trim().isEmpty ? null : _usernameCtrl.text.trim(),
        lastName: _lastNameCtrl.text.trim().isEmpty ? null : _lastNameCtrl.text.trim(),
      );
      if (mounted) {
        setState(() {
          _items = res.items;
          _total = res.total;
        });
      }
    } on ApiException catch (e) {
       final code = ApiExceptionCode.fromString(e.code);
      if (mounted) {
        final errorText = code.asText(context, objectName: AppLocalizations.of(context)!.users);
        setState(() => _error = errorText);
      }
      debugPrint('Users error: $e');
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
      debugPrint('Users unexpected error: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _deleteUser(UserModel user) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.userDeleteConfirmTitle),
        content: Text(l10n.userDeleteConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.deleteSomething(l10n.user)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _api.delete(user.id);
         if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text(l10n.userDeletedSuccess)),
           );
           _load();
        }
      } on ApiException catch (e) {
         if (mounted) {
            final code = ApiExceptionCode.fromString(e.code);
            final errorText = code.asText(context, objectName: l10n.users);
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(errorText), backgroundColor: Colors.red),
            );
         }
         debugPrint('Delete user error: $e');
      } catch (e) {
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
           );
        }
        debugPrint('Delete user unexpected error: $e');
      }
    }
  }

  int get _pageCount => (_total == 0) ? 1 : ((_total + _limit - 1) ~/ _limit);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return FincaScaffold(
      title: l10n.listSomething(l10n.users),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            if (_error != null) MessageBanner.error(_error!),
            
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => const UserFormPage()))
                      .then((v) {
                         if (v == true) _load();
                      });
                },
                icon: const Icon(Icons.add),
                label: Text(l10n.createSomething(l10n.user)),
              ),
            ),
            const SizedBox(height: 8),

            // Filters
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: _usernameCtrl,
                        decoration: InputDecoration(labelText: l10n.username),
                        onSubmitted: (_) {
                          _page = 1;
                          _load();
                        },
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: _lastNameCtrl,
                        decoration: InputDecoration(labelText: l10n.lastName),
                        onSubmitted: (_) {
                          _page = 1;
                          _load();
                        },
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: () {
                        _page = 1;
                        _load();
                      },
                      icon: const Icon(Icons.search),
                      label: Text(l10n.search), // Reuse search or refresh? 'search' key might exist, or use refresh icon
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Table
            Expanded(
              child: _loading 
                ? const Center(child: CircularProgressIndicator())
                : Card(
                  child: _items.isEmpty
                    ? Center(child: Text(l10n.noUsersFound))
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text(l10n.username)),
                            DataColumn(label: Text(l10n.firstName)),
                            DataColumn(label: Text(l10n.lastName)),
                            DataColumn(label: Text(l10n.email)),
                            const DataColumn(label: SizedBox()),
                          ],
                          rows: _items.map((user) => DataRow(
                            cells: [
                              DataCell(Text(user.username)),
                              DataCell(Text(user.firstName)),
                              DataCell(Text(user.lastName)),
                              DataCell(Text(user.email)),
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      tooltip: l10n.editSomething(l10n.user),
                                      onPressed: () {
                                         Navigator.of(context)
                                            .push(MaterialPageRoute(builder: (_) => UserFormPage(user: user)))
                                            .then((v) {
                                               if (v == true) _load();
                                            });
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      tooltip: l10n.deleteSomething(l10n.user),
                                      onPressed: () => _deleteUser(user),
                                    ),
                                  ],
                                )
                              ),
                            ],
                          )).toList(),
                        ),
                      ),
                ),
            ),
             
             const SizedBox(height: 8),

             // Pagination
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Row(
                   children: [
                     Text(l10n.rowsPerPage),
                     const SizedBox(width: 8),
                     DropdownButton<int>(
                       value: _allowedPageSizes.contains(_limit) ? _limit : 10,
                       onChanged: (v) {
                         if (v == null) return;
                         setState(() {
                           _limit = v;
                           _page = 1;
                         });
                         _load();
                       },
                       items: _allowedPageSizes.map((n) => DropdownMenuItem(value: n, child: Text('$n'))).toList(),
                     ),
                   ],
                 ),
                 Text('${l10n.page} $_page / $_pageCount ($_total ${l10n.results})'),
                 Row(
                   children: [
                     IconButton(
                       icon: const Icon(Icons.chevron_left),
                       onPressed: _page > 1 ? () {
                         setState(() => _page--);
                         _load();
                       } : null,
                     ),
                     IconButton(
                       icon: const Icon(Icons.chevron_right),
                       onPressed: _page < _pageCount ? () {
                         setState(() => _page++);
                         _load();
                       } : null,
                     ),
                   ],
                 )
               ],
             ),
          ],
        ),
      ),
    );
  }
}
