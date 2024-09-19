import 'package:everli_client_v2/common/app_user_cubit/app_user_cubit_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final AppUserCubit _appUserCubit;
  final Logger _logger;

  SettingsBloc({
    required AppUserCubit appUserCubit,
    required Logger logger,
  })  : _appUserCubit = appUserCubit,
        _logger = logger,
        super(SettingsInitial()) {
    on<SettingsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
