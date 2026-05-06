import 'package:flutter_test/flutter_test.dart';
import 'package:finca_app_frontend/modules/shared/features/users/models/role_model.dart';
import 'package:finca_app_frontend/modules/shared/features/users/models/user_model.dart';

void main() {
  group('UserModel.rolesTableCellText', () {
    test('returns em dash when there are no roles', () {
      final user = UserModel(
        id: '1',
        username: 'u',
        firstName: 'a',
        lastName: 'b',
        email: 'e@e.com',
        roles: [],
      );
      expect(user.rolesTableCellText, '\u2014');
    });

    test('returns single role name', () {
      final user = UserModel(
        id: '1',
        username: 'u',
        firstName: 'a',
        lastName: 'b',
        email: 'e@e.com',
        roles: [
          RoleModel(id: 'r1', code: 'MGR', name: 'Manager'),
        ],
      );
      expect(user.rolesTableCellText, 'Manager');
    });

    test('joins multiple role names with comma and space', () {
      final user = UserModel(
        id: '1',
        username: 'u',
        firstName: 'a',
        lastName: 'b',
        email: 'e@e.com',
        roles: [
          RoleModel(id: 'r1', code: 'A', name: 'Alpha'),
          RoleModel(id: 'r2', code: 'B', name: 'Beta'),
        ],
      );
      expect(user.rolesTableCellText, 'Alpha, Beta');
    });

    test('returns em dash when role names are only whitespace', () {
      final user = UserModel(
        id: '1',
        username: 'u',
        firstName: 'a',
        lastName: 'b',
        email: 'e@e.com',
        roles: [
          RoleModel(id: 'r1', code: 'X', name: '  '),
        ],
      );
      expect(user.rolesTableCellText, '\u2014');
    });
  });
}
