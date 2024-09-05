import 'package:bloc/bloc.dart';
import 'package:everli_client_v2/common/repository/app_user_repository.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
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
        super(AppUserCubitInitial());

  // Sign in
  // Sign up
  // sign out
  // update user
  // delete user
  // refresh token
  // save user
  // get user
  // save token
  // get token

}
