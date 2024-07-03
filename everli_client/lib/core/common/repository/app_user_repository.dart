import 'dart:convert';

import 'package:everli_client/core/common/models/app_user.dart';
import 'package:everli_client/core/resources/data_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AppUserRepository {
  Future<DataState<AppUser>> createUser(AppUser user) async {
    try {
      debugPrint('user sending: ${const JsonEncoder().convert(user.toJson())}');
      final response = await http.post(
        Uri.parse(
          '${dotenv.get('BASE_URL')}/u/create',
        ),
        body: const JsonEncoder().convert(user.toJson()),
      );
      if (response.statusCode == 201) {
        debugPrint('code works till here');
        debugPrint('user in response: ${response.body}');
        debugPrint(
            'user in response after json decode: ${jsonDecode(response.body)}');
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
      debugPrint(e.toString());
      return DataFailure(e.toString(), -1);
    }
  }

  Future<DataState<AppUser>> getUser(String userId) async {
    try {
      final response = await http.post(
        Uri.parse(
          '${dotenv.get('BASE_URL')}/u/get?id=$userId',
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
}
