import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_app/services/auth_storage.dart';
import 'package:my_app/services/logger.dart';

class ApiClient {
  static const String _baseUrl = 'https://msapi.top-academy.ru/api/v2/';
  static final http.Client _client = http.Client();

  static Future<Map<String, String>> _getHeaders() async {
    final token = await AuthStorage.getAccessToken();
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Origin': 'https://journal.top-academy.ru',
      'Referer': 'https://journal.top-academy.ru/',
      'User-Agent': 'Mozilla/5.0',
    };
  }

  static Future<http.Response> get(
    String path, [
    bool customUrl = false,
  ]) async {
    logger.i('GET request to: $_baseUrl$path');
    final uri = customUrl ? Uri.parse(path) : Uri.parse('$_baseUrl$path');

    final response = await _client.get(uri, headers: await _getHeaders());

    _handleErrors(response);
    return response;
  }

  static Future<http.Response> post(
    String path,
    Map<String, dynamic> body, [
    bool customUrl = false,
  ]) async {
    logger.i('POST request to: $_baseUrl$path');
    final uri = customUrl ? Uri.parse(path) : Uri.parse('$_baseUrl$path');

    final response = await _client.post(
      uri,
      headers: await _getHeaders(),
      body: jsonEncode(body),
    );

    _handleErrors(response);
    return response;
  }

  static Future<http.Response> patch(String path) async {
    logger.i('PATCH request to: $_baseUrl$path');
    final uri = Uri.parse('$_baseUrl$path');

    final response = await _client.patch(uri, headers: await _getHeaders());

    _handleErrors(response);
    return response;
  }

  static Future<http.Response> put(
    String path,
    Map<String, dynamic> body,
  ) async {
    logger.i('PUT request to: $_baseUrl$path');
    final uri = Uri.parse('$_baseUrl$path');

    final response = await _client.put(
      uri,
      headers: await _getHeaders(),
      body: jsonEncode(body),
    );

    _handleErrors(response);
    return response;
  }

  static Future<http.Response> delete(
    String path, [
    bool customUrl = false,
  ]) async {
    logger.i('DELETE request to: $_baseUrl$path');
    final uri = customUrl ? Uri.parse(path) : Uri.parse('$_baseUrl$path');

    final response = await _client.delete(uri, headers: await _getHeaders());

    _handleErrors(response);
    return response;
  }

  static void _handleErrors(http.Response response) {
    if (response.statusCode == 401) {
      AuthStorage.clear();
    }
  }

  static void dispose() {
    _client.close();
  }
}
