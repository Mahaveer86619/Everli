import 'dart:convert';

import 'package:everli_client/core/common/models/app_user.dart';
import 'package:everli_client/core/resources/data_state.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class AppUserRepository {
  final Logger _logger;

  AppUserRepository({required Logger logger}) : _logger = logger;

  Future<DataState<AppUser>> createUser(AppUser user) async {
    try {
      final response = await http.post(
        Uri.parse(
          '${dotenv.get('BASE_URL')}/api/v1/users',
        ),
        body: const JsonEncoder().convert(user.toJson()),
      );

      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      final statusCode = response.statusCode;

      if (statusCode != 201) {
        if (statusCode == 409) {
          return DataFailure('Username already exists', statusCode);
        }
        if (statusCode == 400) {
          return DataFailure('Invalid request body', statusCode);
        }
        return DataFailure(jsonData['message'], statusCode);
      }

      return DataSuccess(
        AppUser.fromJson(jsonData['data']),
        jsonData['message'],
      );
    } catch (e) {
      _logger.e(e.toString());
      return DataFailure(e.toString(), -1);
    }
  }

  Future<DataState<AppUser>> getUser(String firebaseUid) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${dotenv.get('BASE_URL')}/api/v1/users/firebase_uid?firebase_uid=$firebaseUid',
        ),
      );

      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      final statusCode = response.statusCode;

      if (statusCode != 200) {
        if (statusCode == 404) {
          return DataFailure('User not found', statusCode);
        }
        return DataFailure(jsonData['message'], statusCode);
      }
      return DataSuccess(
        AppUser.fromJson(jsonDecode(response.body)),
        jsonData['message'],
      );
    } catch (e) {
      return DataFailure(e.toString(), -1);
    }
  }

  Future<DataState<AppUser>> updateUser(AppUser user) async {
    try {
      final response = await http.patch(
        Uri.parse(
          '${dotenv.get('BASE_URL')}/api/v1/users',
        ),
        body: const JsonEncoder().convert(user.toJson()),
      );

      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      final statusCode = response.statusCode;

      if (statusCode != 200) {
        if (statusCode == 404) {
          return DataFailure('User not found', statusCode);
        }
        return DataFailure(jsonData['message'], statusCode);
      }
      return DataSuccess(
        AppUser.fromJson(jsonDecode(response.body)),
        jsonData['message'],
      );
    } catch (e) {
      return DataFailure(e.toString(), -1);
    }
  }
}
