import 'package:dio/dio.dart';

abstract final class QuoteHttpClient {
  static const timeout = Duration(seconds: 5);

  /// HTTPS-only client for public quote APIs: 5 s timeouts, no cookies and
  /// no identifying headers (spec 6.2 rule 5).
  static Dio create() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: timeout,
        receiveTimeout: timeout,
        sendTimeout: timeout,
        headers: {'Accept': 'application/json'},
      ),
    );
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (options.uri.scheme != 'https') {
            handler.reject(
              DioException(
                requestOptions: options,
                message: 'Only HTTPS is allowed',
              ),
            );
            return;
          }
          options.headers.remove('cookie');
          handler.next(options);
        },
      ),
    );
    return dio;
  }
}
