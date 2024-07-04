import 'dart:convert';

import 'package:everli_client/core/common/constants/app_constants.dart';
import 'package:everli_client/core/common/models/app_user.dart';
import 'package:everli_client/core/common/repository/app_user_repository.dart';
import 'package:everli_client/core/resources/data_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  final SharedPreferences _sharedPreferences;
  final AppUserRepository _appUserRepository;
  final FirebaseAuth _firebaseAuth;
  final Logger _logger;

  AppUserCubit({
    required SharedPreferences sharedPreferences,
    required AppUserRepository appUserRepository,
    required FirebaseAuth firebaseAuth,
    required Logger logger,
  })  : _firebaseAuth = firebaseAuth,
        _appUserRepository = appUserRepository,
        _sharedPreferences = sharedPreferences,
        _logger = logger,
        super(AppUserInitial());

  Future<void> authenticateUser(String firebaseUid) async {
    final resp = await _appUserRepository.getUser(firebaseUid);
    if (resp is DataSuccess) {
      _logger.d('(cubit)user: ${resp.data}');
      saveUserDetails(resp.data!);
      emit(AppUserAuthenticated());
    } else {
      emit(AppUserInitial());
    }
  }

  Future<bool> createUser(AppUser user) async {
    final res = await _appUserRepository.createUser(user);
    if (res is DataSuccess) {
      saveUserDetails(res.data!);
      emit(AppUserAuthenticated());
      return true;
    } else {
      _logger.e('Failed to create user, error: ${res.error}');
      emit(AppUserInitial());
      return false;
    }
  }

  Future<void> loadUser() async {
    final userJson = _sharedPreferences.getString(prefUserKey);
    if (userJson != null) {
      emit(AppUserAuthenticated());
    } else {
      emit(AppUserInitial());
    }
  }

  Future<void> signOut() async {
    await _sharedPreferences.remove(prefUserKey);
    await _firebaseAuth.signOut();
    emit(AppUserInitial());
  }

  Future<void> saveUserDetails(AppUser user) async {
    try {
      _logger.d('(cubit)user to save in shared preferences: ${user.toJson()}');
      await _sharedPreferences.setString(
        prefUserKey,
        jsonEncode(user.toJson()).toString(),
      );
      _logger.d('(cubit)code reaches here');
    } catch (e) {
      _logger.e('(cubit)error while saving user details: $e');
      rethrow;
    }
  }

  Future<AppUser> getUserDetails() async {
    final userJson = _sharedPreferences.getString(prefUserKey);
    if (userJson != null) {
      final user = AppUser.fromJson(jsonDecode(userJson));
      final res = await _appUserRepository.getUser(user.id);

      if (res is DataSuccess) {
        saveUserDetails(res.data!);
        return res.data!;
      } else {
        return AppUser(
          id: '',
          firebaseUid: '',
          username: '',
          email: '',
          avatarUrl: '',
          bio: '',
          skills: [],
        );
      }
    } else {
      return AppUser(
        id: '',
        firebaseUid: '',
        username: '',
        email: '',
        avatarUrl: '',
        bio: '',
        skills: [],
      );
    }
  }
}
