import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:my_app/network/settings/settings_api.dart';
import 'package:my_app/screens/login_screen.dart';
import 'package:my_app/services/auth_storage.dart';
import 'package:my_app/services/logger.dart';
import 'package:my_app/services/user_storage.dart';

// Класс для Api клиента
class ApiClient {
  // Создаем url и http клиента
  static final String _baseUrl = ADDRESS_SERVER;
  static final http.Client _client = http.Client();

  // Функция для запроса
  static Future<http.Response> _request(
    String path,
    String method, {
    BuildContext? context,
    String? body,
    bool customUrl = false,
    bool authCheck = true,
    Map<String, dynamic>? queryPar = null,
  }) async {
    final uri = customUrl ? Uri.parse(path) : Uri.parse('$_baseUrl$path');
    final token = await AuthStorage.getAccessToken();

    // Логер для http запросов
    if (debugLog)
      logger.i('HTTP $method -> $uri \nBody: ${body ?? {}}');

    late http.Response response;

    try {
      // Свитч кейс для методов запросов
      switch (method.toUpperCase()) {
        case 'GET':
          response = await _client.get(uri.replace(
            queryParameters: queryPar
          ), headers: _headers(token));
          break;
        case 'POST':
          response =
              await _client.post(uri.replace(
            queryParameters: queryPar
          ), headers: _headers(token), body: body);
          break;
        case 'PUT':
          response =
              await _client.put(uri.replace(
            queryParameters: queryPar
          ), headers: _headers(token), body: body);
          break;
        case 'PATCH':
          response = await _client.patch(uri.replace(
            queryParameters: queryPar
          ), headers: _headers(token), body: body);
          break;
        case 'DELETE':
          response = await _client.delete(uri.replace(
            queryParameters: queryPar
          ), headers: _headers(token), body: body);
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }

      if (response.statusCode == 401 && authCheck) {
        final password = await UserStorage.getPassword();
        final username = await UserStorage.getUsername();
        final response2 = await _client.post(
          Uri.parse('${_baseUrl}auth/login'), 
          headers: _headers(token), 
          body: jsonEncode({
           "application_key": "6a56a5df2667e65aab73ce76d1dd737f7d1faef9c52e8b8c55ac75f565d8e8a6",
            "id_city": null,
            "password": password,
            "username": username,
          })
        );
        if (response2.statusCode == 200) {
          final body2 = jsonDecode(response2.body);

          await AuthStorage.saveTokens(
            body2['access_token'], 
            body2['refresh_token']
          );

          response = await ApiClient.get("settings/user-info");
          if (response.statusCode == 200) {
            final data = await jsonDecode(response.body);
            await UserStorage.clearAll();
            await UserStorage.saveUserInfo(
              data: data,
            );
          }

          return _request(path, method, context: context, body: body, customUrl: customUrl, authCheck: false);
        } else {
          if (context == null) return response; 
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (_, _, _) => const Loginscreen(),
            )
          );
          if (debugLog) {
            logger.e('Login failed: ${response2.body}');
            logger.e('Status code: ${response2.statusCode}');
          }
        }
      }

      // Логер для получения обратного ответа от сервера
      if (debugLog)
        logger.i('HTTP $method <- ${response.statusCode}\nBody: ${response.body}');
      return response;
    } catch (e) {
      // Логер для ошибки запроса
      if (debugLog)
        logger.e('HTTP $method error: $e');
      return Response('', 503);
    }
  }

  // Функция для Header
  static Map<String, String> _headers(String? token) => {
    'Authorization': (token != null && token.isNotEmpty) ? "Bearer $token" : '',
    'Content-Type': 'application/json',
    'Origin': 'https://journal.top-academy.ru',
    'Referer': 'https://journal.top-academy.ru/',
    'User-Agent': 'Mozilla/5.0',
  };

  // Функция GET запроса
  static Future<http.Response> get(String path, {bool customUrl = false, BuildContext? context, Map<String, dynamic>? queryParameters}) =>
      _request(path, 'GET', context: context, customUrl: customUrl, queryPar: queryParameters);

  // Функция POST запроса
  static Future<http.Response> post(String path, Map<String, dynamic> body,
          {bool customUrl = false, BuildContext? context, Map<String, dynamic>? queryParameters}) =>
      _request(path, 'POST', context: context, body: jsonEncode(body), customUrl: customUrl, queryPar: queryParameters);

  // Функция PUT запроса
  static Future<http.Response> put(String path, Map<String, dynamic> body, 
          {bool customUrl = false, BuildContext? context, Map<String, dynamic>? queryParameters}) =>
      _request(path, 'PUT', context: context, body: jsonEncode(body), customUrl: customUrl, queryPar: queryParameters);

  // Функция PATCH запроса
  static Future<http.Response> patch(String path, Map<String, dynamic> body, 
          {bool customUrl = false, BuildContext? context, Map<String, dynamic>? queryParameters}) => 
      _request(path, 'PATCH', context: context, body: jsonEncode(body), customUrl: customUrl, queryPar: queryParameters);

  // Функция DELETE запроса
  static Future<http.Response> delete(String path, Map<String, dynamic> body, {bool customUrl = false, BuildContext? context, Map<String, dynamic>? queryParameters}) =>
      _request(path, 'DELETE', context: context, body: jsonEncode(body), customUrl: customUrl, queryPar: queryParameters);
}
