import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:my_app/network/settings/settings_api.dart';
import 'package:my_app/screens/login_screen.dart';
import 'package:my_app/services/auth_storage.dart';
import 'package:my_app/services/logger.dart';
import 'package:my_app/services/user_storage.dart';

class ApiClient {
  static final String _baseUrl = ADDRESS_SERVER;
  static final http.Client _client = http.Client();

  static bool _isRefreshing = false;
  static final List<Completer<void>> _queue = [];

  static Future<void> _waitForRefresh() {
    final completer = Completer<void>();
    _queue.add(completer);
    return completer.future;
  }

  static void _completeQueue() {
    for (final completer in _queue) {
      completer.complete();
    }
    _queue.clear();
  }

  static Future<http.Response> _request(
    String path,
    String method, {
    BuildContext? context,
    String? body,
    bool customUrl = false,
    bool authCheck = true,
    Map<String, dynamic>? queryPar,
  }) async {
    final uri = customUrl ? Uri.parse(path) : Uri.parse('$_baseUrl$path');
    final token = await AuthStorage.getAccessToken();

    if (debugLog) {
      logger.i('HTTP $method -> $uri \nBody: ${body ?? {}}');
    }

    late http.Response response;

    try {
      switch (method.toUpperCase()) {
        case 'GET':
          response = await _client
              .get(uri.replace(queryParameters: queryPar), headers: _headers(token))
              .timeout(const Duration(seconds: 5));
          break;

        case 'POST':
          response = await _client
              .post(uri.replace(queryParameters: queryPar),
                  headers: _headers(token), body: body)
              .timeout(const Duration(seconds: 5));
          break;

        case 'PUT':
          response = await _client
              .put(uri.replace(queryParameters: queryPar),
                  headers: _headers(token), body: body)
              .timeout(const Duration(seconds: 5));
          break;

        case 'PATCH':
          response = await _client
              .patch(uri.replace(queryParameters: queryPar),
                  headers: _headers(token), body: body)
              .timeout(const Duration(seconds: 5));
          break;

        case 'DELETE':
          response = await _client
              .delete(uri.replace(queryParameters: queryPar),
                  headers: _headers(token), body: body)
              .timeout(const Duration(seconds: 5));
          break;

        default:
          throw Exception('Unsupported HTTP method: $method');
      }

      if (response.statusCode == 401 && authCheck) {
        if (_isRefreshing) {
          await _waitForRefresh();
          return await _request(
            path,
            method,
            context: context,
            body: body,
            customUrl: customUrl,
            authCheck: false,
            queryPar: queryPar,
          );
        }

        _isRefreshing = true;

        final success = await _refreshLogin(context);

        _isRefreshing = false;
        _completeQueue();

        if (success) {
          return await _request(
            path,
            method,
            context: context,
            body: body,
            customUrl: customUrl,
            authCheck: false,
            queryPar: queryPar,
          );
        } else {
          return response;
        }
      }

      if (debugLog) {
        logger.i('HTTP $method <- ${response.statusCode}\nBody: ${response.body}');
      }

      return response;

    } on TimeoutException {
      if (debugLog) logger.e('Timeout: $uri');
      return Response('Timeout', 408);

    } on SocketException {
      if (debugLog) logger.e('No Internet');
      return Response('No Internet', 503);

    } catch (e) {
      if (debugLog) logger.e('Error: $e');
      return Response('', 500);
    }
  }

  static Map<String, String> _headers(String? token) {
    final headers = {
      'Content-Type': 'application/json',
      'Origin': 'https://journal.top-academy.ru',
      'Referer': 'https://journal.top-academy.ru/',
      'User-Agent': 'Mozilla/5.0',
    };

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = "Bearer $token";
    }

    return headers;
  }

  static Future<bool> _refreshLogin(BuildContext? context) async {
    final password = await UserStorage.getPassword();
    final username = await UserStorage.getUsername();

    final response = await _client.post(
      Uri.parse('${_baseUrl}auth/login'),
      headers: _headers(null),
      body: jsonEncode({
        "application_key": "6a56a5df2667e65aab73ce76d1dd737f7d1faef9c52e8b8c55ac75f565d8e8a6",
        "id_city": null,
        "password": password,
        "username": username,
      }),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      await AuthStorage.saveTokens(
        body['access_token'],
        body['refresh_token'],
      );

      if (debugLog) logger.i('Token refreshed');

      return true;
    } else {
      if (context != null && context.mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, _, _) => const Loginscreen(),
          ),
        );
      }

      if (debugLog) {
        logger.e('Refresh failed: ${response.body}');
      }

      return false;
    }
  }

  static Future<http.Response> get(
    String path, {
    bool customUrl = false,
    BuildContext? context,
    Map<String, dynamic>? queryParameters,
  }) =>
      _request(path, 'GET',
          context: context,
          customUrl: customUrl,
          queryPar: queryParameters);

  static Future<http.Response> post(
    String path,
    Map<String, dynamic> body, {
    bool customUrl = false,
    BuildContext? context,
    Map<String, dynamic>? queryParameters,
  }) =>
      _request(path, 'POST',
          context: context,
          body: jsonEncode(body),
          customUrl: customUrl,
          queryPar: queryParameters);

  static Future<http.Response> put(
    String path,
    Map<String, dynamic> body, {
    bool customUrl = false,
    BuildContext? context,
    Map<String, dynamic>? queryParameters,
  }) =>
      _request(path, 'PUT',
          context: context,
          body: jsonEncode(body),
          customUrl: customUrl,
          queryPar: queryParameters);

  static Future<http.Response> patch(
    String path,
    Map<String, dynamic> body, {
    bool customUrl = false,
    BuildContext? context,
    Map<String, dynamic>? queryParameters,
  }) =>
      _request(path, 'PATCH',
          context: context,
          body: jsonEncode(body),
          customUrl: customUrl,
          queryPar: queryParameters);

  static Future<http.Response> delete(
    String path,
    Map<String, dynamic> body, {
    bool customUrl = false,
    BuildContext? context,
    Map<String, dynamic>? queryParameters,
  }) =>
      _request(path, 'DELETE',
          context: context,
          body: jsonEncode(body),
          customUrl: customUrl,
          queryPar: queryParameters);
}