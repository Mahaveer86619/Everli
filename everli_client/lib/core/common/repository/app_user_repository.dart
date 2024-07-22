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
      if (response.statusCode != 201) {
        if (response.statusCode == 409) {
          return DataFailure('Username already exists', response.statusCode);
        }
        if (response.statusCode == 400) {
          return DataFailure('Invalid request body', response.statusCode);
        }
        return DataFailure(response.body, response.statusCode);
      }
      return DataSuccess(
        AppUser.fromJson(jsonDecode(response.body)),
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
      if (response.statusCode != 200) {
        if (response.statusCode == 404) {
          return DataFailure('User not found', response.statusCode);
        }
        return DataFailure(response.body, response.statusCode);
      }
      return DataSuccess(
        AppUser.fromJson(jsonDecode(response.body)),
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
        body: user
      );
      if (response.statusCode != 200) {
        if (response.statusCode == 404) {
          return DataFailure('User not found', response.statusCode);
        }
        return DataFailure(response.body, response.statusCode);
      }
      return DataSuccess(
        AppUser.fromJson(jsonDecode(response.body)),
      );
    } catch (e) {
      return DataFailure(e.toString(), -1);
    }
  }
}
