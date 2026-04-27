import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../../core/network/api_client.dart';

class PushNotificationService {
  PushNotificationService._();

  static final _messaging = FirebaseMessaging.instance;
  static final _apiClient = ApiClient();
  static bool _isConfigured = false;

  static Future<void> initialize({
    required Future<void> Function(RemoteMessage) backgroundHandler,
  }) async {
    try {
      await Firebase.initializeApp();
      FirebaseMessaging.onBackgroundMessage(backgroundHandler);
      _isConfigured = true;

      await _messaging.requestPermission();
      await _registerCurrentToken();

      _messaging.onTokenRefresh.listen((token) {
        unawaited(_registerToken(token));
      });
    } catch (error) {
      _isConfigured = false;
      debugPrint('Push notifications are not configured: $error');
    }
  }

  static Future<void> registerForSignedInUser() async {
    if (!_isConfigured) {
      return;
    }

    try {
      await _registerCurrentToken();
    } catch (error) {
      debugPrint('Push token registration failed: $error');
    }
  }

  static Future<void> _registerCurrentToken() async {
    final token = await _messaging.getToken();
    if (token == null || token.isEmpty) {
      return;
    }

    await _registerToken(token);
  }

  static Future<void> _registerToken(String token) async {
    try {
      await _apiClient.post(
        '/api/users/push-token',
        body: {'token': token},
        authenticated: true,
      );
    } on ApiException catch (error) {
      if (error.statusCode != 401) {
        rethrow;
      }
    }
  }
}
