import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import '../env/app_env.dart';
import '../errors/api_exception.dart';

final loggerProvider = Provider<Logger>((ref) => Logger());

final dioProvider = Provider<Dio>((ref) {
  final logger = ref.watch(loggerProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: AppEnv.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      headers: <String, String>{'Content-Type': 'application/json'},
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        logger.i('REQ ${options.method} ${options.uri}');
        handler.next(options);
      },
      onResponse: (response, handler) {
        logger.i('RES ${response.statusCode} ${response.requestOptions.uri}');
        handler.next(response);
      },
      onError: (error, handler) {
        logger.e('ERR ${error.requestOptions.uri}: ${error.message}');
        handler.next(error);
      },
    ),
  );

  return dio;
});

ApiException mapDioException(DioException error) {
  final statusCode = error.response?.statusCode;
  final data = error.response?.data;
  final message = switch (data) {
    Map<String, dynamic> map => map['message']?.toString() ?? error.message,
    _ => error.message,
  };

  return ApiException(
    message ?? 'Network request failed',
    statusCode: statusCode,
  );
}
