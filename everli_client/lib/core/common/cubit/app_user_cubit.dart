import 'dart:convert';

import 'package:everli_client/core/common/constants/app_constants.dart';
import 'package:everli_client/core/common/models/app_user.dart';
import 'package:everli_client/core/common/repository/app_user_repository.dart';
import 'package:everli_client/core/resources/data_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  final SharedPreferences _sharedPreferences;
  final AppUserRepository _appUserRepository;
  final FirebaseAuth _firebaseAuth;

  AppUserCubit({
    required SharedPreferences sharedPreferences,
    required AppUserRepository appUserRepository,
    required FirebaseAuth firebaseAuth,
  })  : _firebaseAuth = firebaseAuth,
        _appUserRepository = appUserRepository,
        _sharedPreferences = sharedPreferences,
        super(AppUserInitial());

  Future<void> authenticateUser(String userId) async {
    final user = await _appUserRepository.getUser(userId);
    if (user.data!.id != '') {
      saveUserDetails(user.data!);
      emit(AppUserAuthenticated());
    } else {
      emit(AppUserInitial());
    }
  }

  Future<bool> createUser(AppUser user) async {
    debugPrint('(cubit)user: $user');
    final res = await _appUserRepository.createUser(user);
    if (res is DataSuccess) {
      debugPrint('User created');
      saveUserDetails(res.data!);
      emit(AppUserAuthenticated());
      return true;
    } else {
      debugPrint('Failed to create user, error: ${res.error}');
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
    await _sharedPreferences.setString(prefUserKey, jsonEncode(user.toJson()));
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
