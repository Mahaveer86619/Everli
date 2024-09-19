import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:everli_client_v2/core/endpoints/app_endpoints.dart';
import 'package:everli_client_v2/core/resources/data_state.dart';
import 'package:everli_client_v2/features/auth/data/models/user_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class AuthDataSource {
  final Logger logger;
  AuthDataSource({required this.logger});

  Future<DataState<Map<String, dynamic>>> authenticateUser(
    String email,
    String password,
  ) async {
    try {
      logger.i('Authenticating user');

      final bodyToSend = {
        "email": email,
        "password": password,
      };

      final response = await http.post(
        Uri.parse(
          '${dotenv.get('BASE_URL')}${AppEndpoints.authenticateUser}',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: const JsonEncoder().convert(bodyToSend),
      );

      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      final Map<String, dynamic> jsonBody = jsonData['data'];
      final statusCode = response.statusCode;
      final message = jsonData['message'];

      if (statusCode != 200) {
        if (statusCode == 404) {
          return DataFailure('No user found', statusCode);
        }
        if (statusCode == 400) {
          return DataFailure('Invalid data', statusCode);
        }
        if (statusCode == 500) {
          return DataFailure('Server error', statusCode);
        }
        return DataFailure(message, statusCode);
      }

      return DataSuccess(jsonBody, message);
    } catch (error) {
      if (error is SocketException || error is TimeoutException) {
        return DataFailure('Network error: $error', -1);
      } else {
        return DataFailure('Unknown error: $error', -1);
      }
    }
  }

  Future<DataState<Map<String, dynamic>>> registerUser(
    String username,
    String email,
    String password,
  ) async {
    try {
      logger.i('Registering user');

      final bodyToSend = {
        "username": username,
        "email": email,
        "password": password,
      };

      final response = await http.post(
        Uri.parse(
          '${dotenv.get('BASE_URL')}${AppEndpoints.registerUser}',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: const JsonEncoder().convert(bodyToSend),
      );

      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      final Map<String, dynamic> jsonBody = jsonData['data'];
      final statusCode = response.statusCode;
      final message = jsonData['message'];

      if (statusCode != 200) {
        if (statusCode == 409) {
          return DataFailure('User already exists', statusCode);
        }
        if (statusCode == 400) {
          return DataFailure('Invalid data', statusCode);
        }
        return DataFailure(message, statusCode);
      }

      return DataSuccess(jsonBody, message);
    } catch (error) {
      if (error is SocketException || error is TimeoutException) {
        return DataFailure('Network error: $error', -1);
      } else {
        return DataFailure('Unknown error: $error', -1);
      }
    }
  }

  Future<DataState<String>> sendOtp(
    String email,
  ) async {
    try {
      logger.i('Verifying email');

      final bodyToSend = {
        "email": email,
      };

      final response = await http.post(
        Uri.parse(
          '${dotenv.get('BASE_URL')}${AppEndpoints.sendPassResetCode}',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: const JsonEncoder().convert(bodyToSend),
      );

      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      // final Map<String, dynamic> jsonBody = jsonData['data'];
      final statusCode = response.statusCode;
      final message = jsonData['message'];

      if (statusCode != 200) {
        if (statusCode == 404) {
          return DataFailure('No user found', statusCode);
        }
        if (statusCode == 400) {
          return DataFailure('Invalid data', statusCode);
        }
        if (statusCode == 500) {
          return DataFailure('Server error', statusCode);
        }
        return DataFailure(message, statusCode);
      }

      return DataSuccess(message, message);
    } catch (error) {
      if (error is SocketException || error is TimeoutException) {
        return DataFailure('Network error: $error', -1);
      } else {
        return DataFailure('Unknown error: $error', -1);
      }
    }
  }

  Future<DataState<String>> verifyOtp(
    String code,
    String email,
  ) async {
    try {
      logger.i('Verifying code');

      final bodyToSend = {
        "email": email,
        "code": code,
      };

      final response = await http.post(
        Uri.parse(
          '${dotenv.get('BASE_URL')}${AppEndpoints.checkResetPassCode}',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: const JsonEncoder().convert(bodyToSend),
      );

      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      // final Map<String, dynamic> jsonBody = jsonData['data'];
      final statusCode = response.statusCode;
      final message = jsonData['message'];

      if (statusCode != 200) {
        if (statusCode == 404) {
          return DataFailure('email not found', statusCode);
        }
        if (statusCode == 400) {
          return DataFailure('Invalid data', statusCode);
        }
        if (statusCode == 500) {
          return DataFailure('Server error', statusCode);
        }
        return DataFailure(message, statusCode);
      }

      return DataSuccess(message, message);
    } catch (error) {
      if (error is SocketException || error is TimeoutException) {
        return DataFailure('Network error: $error', -1);
      } else {
        return DataFailure('Unknown error: $error', -1);
      }
    }
  }

  Future<DataState<String>> resetPass(
    String email,
    String password,
  ) async {
    try {
      logger.i('Verifying code');

      final bodyToSend = {
        "email": email,
        "password": password,
      };

      final response = await http.post(
        Uri.parse(
          '${dotenv.get('BASE_URL')}${AppEndpoints.updatePass}',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: const JsonEncoder().convert(bodyToSend),
      );

      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      // final Map<String, dynamic> jsonBody = jsonData['data'];
      final statusCode = response.statusCode;
      final message = jsonData['message'];

      if (statusCode != 200) {
        if (statusCode == 404) {
          return DataFailure('email not found', statusCode);
        }
        if (statusCode == 400) {
          return DataFailure('Invalid data', statusCode);
        }
        if (statusCode == 500) {
          return DataFailure('Server error', statusCode);
        }
        return DataFailure(message, statusCode);
      }

      return DataSuccess(message, message);
    } catch (error) {
      if (error is SocketException || error is TimeoutException) {
        return DataFailure('Network error: $error', -1);
      } else {
        return DataFailure('Unknown error: $error', -1);
      }
    }
  }

  Future<DataState<String>> createUser(
    UserModel user,
    String token,
  ) async {
    try {
      logger.i('Creating user profile');

      final response = await http.post(
        Uri.parse(
          '${dotenv.get('BASE_URL')}${AppEndpoints.createUser}',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: const JsonEncoder().convert(user.toJson()),
      );

      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      // final Map<String, dynamic> jsonBody = jsonData['data'];
      final statusCode = response.statusCode;
      final message = jsonData['message'];

      if (statusCode != 201) {
        if (statusCode == 404) {
          return DataFailure('email not found', statusCode);
        }
        if (statusCode == 400) {
          return DataFailure('Invalid data', statusCode);
        }
        if (statusCode == 500) {
          return DataFailure('Server error', statusCode);
        }
        return DataFailure(message, statusCode);
      }

      return DataSuccess(message, message);
    } catch (error) {
      if (error is SocketException || error is TimeoutException) {
        return DataFailure('Network error: $error', -1);
      } else {
        return DataFailure('Unknown error: $error', -1);
      }
    }
  }
}
