import 'dart:async';

import 'package:finca_app_frontend/core/models/user_model.dart';
import 'package:finca_app_frontend/core/services/auth_service.dart';

/// AuthService falsificable para tests de [LoginForm] / [LoginPage] + GoRouter.
class FakeAuthService extends AuthService {
  FakeAuthService({this.success, this.throwing})
    : assert(
        success != null || throwing != null,
        'FakeAuthService: indica success o throwing',
      ),
      super();

  final Map<String, dynamic>? success;
  final Object? throwing;

  @override
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
    required String companyUsername,
  }) async {
    if (throwing != null) {
      throw throwing!;
    }
    return success!;
  }
}

/// Registra cada invocación a [login] y los argumentos (útil como spy).
class RecordingAuthService extends AuthService {
  RecordingAuthService({required this.response}) : super();

  final Map<String, dynamic> response;

  int loginCallCount = 0;
  String? lastUsername;
  String? lastPassword;
  String? lastCompanyUsername;

  @override
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
    required String companyUsername,
  }) async {
    loginCallCount++;
    lastUsername = username;
    lastPassword = password;
    lastCompanyUsername = companyUsername;
    return response;
  }
}

/// Devuelve el [Future] del [Completer] para controlar el tiempo del login.
class CompleterAuthService extends AuthService {
  CompleterAuthService(this.completer) : super();

  final Completer<Map<String, dynamic>> completer;

  @override
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
    required String companyUsername,
  }) =>
      completer.future;
}

/// Like [CompleterAuthService] pero cuenta invocaciones a [login].
class RecordingCompleterAuthService extends AuthService {
  RecordingCompleterAuthService(this._completer) : super();

  final Completer<Map<String, dynamic>> _completer;
  int loginCallCount = 0;

  @override
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
    required String companyUsername,
  }) {
    loginCallCount++;
    return _completer.future;
  }
}

/// Siempre lanza [error] en [login].
class ThrowingAuthService extends AuthService {
  ThrowingAuthService(this.error) : super();

  final Object error;

  @override
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
    required String companyUsername,
  }) async {
    throw error;
  }
}

/// Payload mínimo válido para [LoginForm.onLoginSuccess] y [SessionService.saveSession].
Map<String, dynamic> loginSuccessPayload({
  String idTenant = 'tenant-1',
  String idUser = 'u1',
}) {
  final user = User(
    id: idUser,
    username: 'alice',
    firstName: 'A',
    lastName: 'B',
    email: 'a@b.com',
    idTenant: idTenant,
    roles: const [],
  );
  return {
    'user': user,
    'token': 'access-token-test',
    'refreshToken': 'refresh-test',
    'permissions': <String, dynamic>{
      'MASSIVE_EVENTS': {'massive_events': true},
    },
    'idTenant': idTenant,
  };
}

/// Login exitoso sin clave `refreshToken` (persistencia sin refresh).
Map<String, dynamic> loginSuccessPayloadNoRefreshKey({
  String idTenant = 'tenant-1',
  String idUser = 'u1',
}) {
  final m = loginSuccessPayload(idTenant: idTenant, idUser: idUser);
  m.remove('refreshToken');
  return m;
}

/// Login exitoso con `refreshToken: null`.
Map<String, dynamic> loginSuccessPayloadRefreshNull({
  String idTenant = 'tenant-1',
  String idUser = 'u1',
}) {
  final m = loginSuccessPayload(idTenant: idTenant, idUser: idUser);
  m['refreshToken'] = null;
  return m;
}
