import 'dart:convert';

import 'package:everli_client_v2/common/constants/app_constants.dart';
import 'package:everli_client_v2/common/repository/app_user_repository.dart';
import 'package:everli_client_v2/features/auth/data/models/app_user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_user_cubit_state.dart';

class AppUserCubit extends Cubit<AppUserCubitState> {
  final SharedPreferences _sharedPreferences;
  final AppUserRepository _appUserRepository;
  final Logger _logger;

  AppUserCubit({
    required SharedPreferences sharedPreferences,
    required AppUserRepository appUserRepository,
    required Logger logger,
  })  : _appUserRepository = appUserRepository,
        _sharedPreferences = sharedPreferences,
        _logger = logger,
        super(AppUserInitial());

  // authenticate user
  Future<void> authenticateUser(
    AppUserModel user,
  ) async {
    final token = user.token;
    final refreshToken = user.refreshToken;
    final Map<String, dynamic> userMap = {
      'id': user.id,
      'email': user.email,
      'name': user.name,
    };

    await saveUser(userMap);
    await saveToken(token);
    await saveRefreshToken(refreshToken);

    emit(AppUserAuthenticated());
  }

  // load user
  Future<void> loadUser() async {
    final user = await getUser();
    if (user != null) {
      emit(AppUserAuthenticated());
    } else {
      emit(AppUserInitial());
    }
  }

  // save user
  Future<void> saveUser(Map<String, dynamic> userMap) async {
    try {
      await _sharedPreferences.setString(prefUserKey, jsonEncode(userMap));
      _logger.i('User saved successfully');
    } catch (e) {
      _logger.e('Error saving user: $e');
      rethrow;
    }
  }

  // get user
  Future<Map<String, dynamic>?> getUser() async {
    try {
      final userString = _sharedPreferences.getString(prefUserKey);
      if (userString != null) {
        return jsonDecode(userString);
      } else {
        _logger.i('User is null');
        return null;
      }
    } catch (e) {
      _logger.e('Error getting user: $e');
      return null;
    }
  }

  // remove user
  Future<void> signOut() async {
    await _sharedPreferences.remove(prefUserKey);
    removeTokens();
    emit(AppUserInitial());
  }

  // save token
  Future<void> saveToken(String token) async {
    try {
      await _sharedPreferences.setString(prefTokenKey, token);
      _logger.i('Token saved successfully');
    } catch (e) {
      _logger.e('Error saving token: $e');
      rethrow;
    }
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    try {
      await _sharedPreferences.setString(prefRefreshTokenKey, refreshToken);
      _logger.i('Refresh token saved successfully');
    } catch (e) {
      _logger.e('Error saving refresh token: $e');
      rethrow;
    }
  }

  // get token
  Future<String?> getToken() async {
    try {
      final tokenString = _sharedPreferences.getString(prefTokenKey);
      if (tokenString != null) {
        return tokenString;
      } else {
        return null;
      }
    } catch (e) {
      _logger.e('Error getting token: $e');
      return null;
    }
  }

  Future<String?> getRefreshToken() async {
    try {
      final refreshTokenString =
          _sharedPreferences.getString(prefRefreshTokenKey);
      if (refreshTokenString != null) {
        return refreshTokenString;
      } else {
        return null;
      }
    } catch (e) {
      _logger.e('Error getting refresh token: $e');
      return null;
    }
  }

  // refresh token
  Future<void> refreshToken() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken != null) {
        _logger.i('Refreshing token');
        _logger.i('refreshToken: $refreshToken');
        final newToken =
            await _appUserRepository.refreshToken("", refreshToken);
        await saveToken(newToken.data!['tokenKey']);
      } else {
        _logger.e('Token or refresh token is null');
      }
    } catch (e) {
      _logger.e('Error refreshing token: $e');
      rethrow;
    }
  }

  // remove tokens
  Future<void> removeTokens() async {
    await _sharedPreferences.remove(prefTokenKey);
    await _sharedPreferences.remove(prefRefreshTokenKey);
  }
}
