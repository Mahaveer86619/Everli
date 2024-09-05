import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class AppUserRepository {
  final Logger _logger;

  AppUserRepository({
    required Logger logger,
  }) : _logger = logger;

  Future<void> saveUser(Map<String, dynamic> user) async {
    // TODO: Implement this method
  }

  Future<Map<String, dynamic>?> getUser() async {
    // TODO: Implement this method
    return null;
  }

  Future<void> deleteUser() async {
    // TODO: Implement this method
  }

  Future<void> updateUser(Map<String, dynamic> user) async {
    // TODO: Implement this method
  }

  Future<bool> RefreshToken(String token, String refreshToken) async {
    // TODO: Implement this method
    return false;
  }
}
