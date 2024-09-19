import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:everli_client_v2/core/endpoints/app_endpoints.dart';
import 'package:everli_client_v2/core/resources/data_state.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class AppUserRepository {
  final Logger _logger;

  AppUserRepository({
    required Logger logger,
  }) : _logger = logger;

  Future<DataState<Map<String, dynamic>>?> getUser() async {
    // TODO: Implement this method
    return null;
  }

  Future<DataState<void>?> deleteUser() async {
    // TODO: Implement this method
    return null;
  }

  Future<DataState<void>?> updateUser(Map<String, dynamic> user) async {
    // TODO: Implement this method
    return null;
  }

  Future<DataState<Map<String, dynamic>>> refreshToken(
    String token,
    String refreshToken,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(
          '${dotenv.get('BASE_URL')}${AppEndpoints.refreshToken}',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: {
          "token": token,
          "refresh_token": refreshToken,
        },
      );

      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      final statusCode = response.statusCode;
      final message = jsonData['message'];

      if (statusCode != 200) {
        if (statusCode == 401) {
          return DataFailure(
            'Unauthorized',
            statusCode,
          );
        }
        if (statusCode == 400) {
          return DataFailure(
            'Invalid data',
             statusCode,
          );
        }
        return DataFailure(
          message,
          statusCode,
        );
      }

      final data = jsonDecode(response.body);
      final tokenResponse = data['data']['token'];
      final refreshTokenResponse = data['data']['refresh_token'];

      _logger.i('Token: $tokenResponse');
      _logger.i('Refresh token: $refreshTokenResponse');

      return DataSuccess(
        jsonData,
        message,
      );
    } catch (e) {
      if (e is SocketException || e is TimeoutException) {
        return DataFailure('Network error: $e', -1);
      } else {
        return DataFailure('Unknown error: $e', -1);
      }
    }
  }
}
