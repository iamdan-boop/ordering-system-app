import 'dart:async';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ordering_system/infrastructure/api.dart';
import 'package:ordering_system/infrastructure/inputs/register_request.dart';
import 'package:ordering_system/infrastructure/models/auth_token.dart';

enum AuthenticationStatus {
  unknown,
  authenticated,
  unauthenticated,
  badRequest,
  guest,
}

class AuthenticationStatusState extends Equatable {
  const AuthenticationStatusState(this.authenticationStatus, this.isGuest);

  final AuthenticationStatus authenticationStatus;
  final bool isGuest;

  @override
  List<Object?> get props => [authenticationStatus, isGuest];
}

class AuthenticationRepository {
  AuthenticationRepository(this._client, this._secureStorage);

  final OrderingClient _client;
  final FlutterSecureStorage _secureStorage;

  final _controller = StreamController<AuthenticationStatusState>();

  Stream<AuthenticationStatusState> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield const AuthenticationStatusState(
      AuthenticationStatus.unauthenticated,
      false,
    );

    yield* _controller.stream;
  }

  Future<void> me() async {
    try {
      final token = await _client.me();
      await _secureStorage.write(key: 'authToken', value: token.authToken);
      return _controller.add(
        const AuthenticationStatusState(
          AuthenticationStatus.authenticated,
          false,
        ),
      );
    } on DioError catch (_) {
      return _controller.add(
        const AuthenticationStatusState(
          AuthenticationStatus.unauthenticated,
          false,
        ),
      );
    }
  }

  Future<void> loginAsGuest({
    required String guest,
  }) async {
    try {
      final cart = await _client.loginGuest(email: guest);
      // print(cart);
      await Future.wait([
        _secureStorage.write(key: 'guest_login', value: guest),
        _secureStorage.write(key: 'cart_id', value: cart.id.toString())
      ]);

      _controller.add(
        const AuthenticationStatusState(
          AuthenticationStatus.authenticated,
          true,
        ),
      );
    } on DioError catch (e) {
      return handleError(e);
    }
  }

  Future<void> guestCheck() async {
    final guest = await _secureStorage.read(key: 'guest_login');
    if (guest != null && guest.isNotEmpty) {
      try {
        final cart = await _client.guestCheck();
        await _secureStorage.write(key: 'cart_id', value: cart.id.toString());
        return _controller.add(const AuthenticationStatusState(
          AuthenticationStatus.authenticated,
          true,
        ));
      } on DioError catch (e) {
        await Future.wait([
          _secureStorage.delete(key: 'guest_login'),
          _secureStorage.delete(key: 'cart_id'),
        ]);
        return handleError(e);
      }
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      final token = await _client.login(email: email, password: password);
      await saveToken(token);
      return _controller.add(
        const AuthenticationStatusState(
          AuthenticationStatus.authenticated,
          false,
        ),
      );
    } on DioError catch (e) {
      handleError(e);
      rethrow;
    }
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'authToken');
    return _controller.add(
      const AuthenticationStatusState(
        AuthenticationStatus.unauthenticated,
        false,
      ),
    );
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final token = await _client.register(
        registerRequest: RegisterRequest(
          name: name,
          email: email,
          password: password,
        ),
      );
      await saveToken(token);
      return _controller.add(
        const AuthenticationStatusState(
          AuthenticationStatus.authenticated,
          false,
        ),
      );
    } on DioError catch (e) {
      handleError(e);
      rethrow;
    }
  }

  void handleError(DioError e) {
    final responseCode = e.response?.statusCode;
    if (responseCode == 400) {
      return _controller.add(
        const AuthenticationStatusState(
          AuthenticationStatus.badRequest,
          false,
        ),
      );
    }
    if (responseCode == 500) {
      return _controller.add(
        const AuthenticationStatusState(
          AuthenticationStatus.unknown,
          false,
        ),
      );
    }
    return _controller.add(
      const AuthenticationStatusState(
        AuthenticationStatus.unauthenticated,
        false,
      ),
    );
  }

  Future<void> saveToken(AuthToken token) async {
    return _secureStorage.write(key: 'authToken', value: token.authToken);
  }

  void dispose() => _controller.close();
}
