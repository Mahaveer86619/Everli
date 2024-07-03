import 'dart:convert';

import 'package:everli_client/core/common/models/app_user.dart';
import 'package:everli_client/core/resources/data_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AppUserRepository {
  Future<DataState<AppUser>> createUser(AppUser user) async {
    try {
      debugPrint('user in repo: ${user.toJson()}');
      final response = await http.post(
        Uri.parse(
          '${dotenv.get('BASE_URL')}/u/create',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: {
          "id": "36743679-7de7-4b2c-ad29-68343ff4ede5",
          "username": "testUser@",
          "email": "email",
          "bio": "bio",
          "avatar_url": "avatar_url",
          "skills": ["skill1", "skill2"]
        },
      );
      if (response.statusCode == 201) {
        return DataSuccess(
          AppUser.fromJson(jsonDecode(response.body)),
        );
      }
      if (response.statusCode == 409) {
        return DataFailure('Username already exists', response.statusCode);
      }
      if (response.statusCode == 400) {
        return DataFailure('Invalid request body', response.statusCode);
      }
      debugPrint("(repo)body: ${response.body}");
      debugPrint("(repo)statusCode: ${response.statusCode}");
      return DataFailure(response.body, response.statusCode);
    } catch (e) {
      return DataFailure(e.toString(), -1);
    }
  }

  Future<DataState<AppUser>> getUser(String userId) async {
    try {
      final response = await http.post(
        Uri.parse(
          '${dotenv.get('BASE_URL')}/u/get?id=$userId',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
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
