import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class JsonHeaderInterceptor extends Interceptor {
  JsonHeaderInterceptor(
    this._secureStorage,
  );

  final FlutterSecureStorage _secureStorage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    return super.onRequest(options, handler);
  }

  @override
  Future<void> onError(
    DioError err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 403) {
      await Future.wait([
        _secureStorage.delete(key: 'guest_login'),
        _secureStorage.delete(key: 'cart_id')
      ]);
      return;
    }
    super.onError(err, handler);
  }
}
