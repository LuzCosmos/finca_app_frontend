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
      setState(() {
        _items = res.items;
        _total = res.total;
      });
    } on ApiException catch (e) {
       final code = ApiExceptionCode.values.firstWhere(
        (el) => el.name == (e.code),
        orElse: () => ApiExceptionCode.unknownError,
      );
      final errorText = code.asText(context, objectName: AppLocalizations.of(context)!.users);
      setState(() => _error = errorText);
      print('Users error: $e'); // Log to console as requested
    } catch (e) {
      setState(() => _error = e.toString());
      print(e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _deleteUser(UserModel user) async {
    final t = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.userDeleteConfirmTitle),
        content: Text(t.userDeleteConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(t.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(t.deleteUser),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _api.delete(user.id);
         if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text(t.userDeletedSuccess)),
           );
           _load();
        }
      } on ApiException catch (e) {
         if (mounted) {
            final code = ApiExceptionCode.values.firstWhere(
                (el) => el.name == (e.code),
                orElse: () => ApiExceptionCode.unknownError,
            );
            final errorText = code.asText(context, objectName: t.users);
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(errorText), backgroundColor: Colors.red),
            );
         }
         print('Delete user error: $e');
      } catch (e) {
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
           );
        }
        print(e);
      }
    }
  }

  int get _pageCount => (_total == 0) ? 1 : ((_total + _limit - 1) ~/ _limit);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return FincaScaffold(
      title: t.usersList,
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
                label: Text(t.createUser),
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
                        decoration: InputDecoration(labelText: t.username),
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
                        decoration: InputDecoration(labelText: t.lastName),
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
                      label: Text(t.search), // Reuse search or refresh? 'search' key might exist, or use refresh icon
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
                    ? Center(child: Text(t.noUsersFound))
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text(t.username)),
                            DataColumn(label: Text(t.firstName)),
                            DataColumn(label: Text(t.lastName)),
                            DataColumn(label: Text(t.email)),
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
                                      tooltip: t.editUser,
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
                                      tooltip: t.deleteUser,
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
                     Text(t.rowsPerPage),
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
                 Text('${t.page} $_page / $_pageCount ($_total ${t.results})'),
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
