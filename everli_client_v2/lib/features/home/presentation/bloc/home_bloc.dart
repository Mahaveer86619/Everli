import 'package:everli_client_v2/common/app_user_cubit/app_user_cubit_cubit.dart';
import 'package:everli_client_v2/features/auth/domain/entities/app_user_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AppUserCubit _appUserCubit;
  final Logger _logger;

  HomeBloc({
    required AppUserCubit appUserCubit,
    required Logger logger,
  })  : _appUserCubit = appUserCubit,
        _logger = logger,
        super(HomeSuccess(status: HomeStatus.initial, message: '')) {
    on<GetUserInfoEvent>(_onGetUserInfo);
  }

  Future<void> _onGetUserInfo(
      GetUserInfoEvent event, Emitter<HomeState> emit) async {
    try {
      final userMap = await _appUserCubit.getUser();
      if (userMap != null) {
        final user = AppUserEntity.fromJson(userMap);
        emit(HomeUserInfoFetched(
          status: HomeStatus.loaded,
          message: 'User info fetched successfully',
          user: user,
        ));
      } else {
        emit(HomeError(
          status: HomeStatus.error,
          message: 'User info not found',
        ));
      }
    } catch (e) {
      _logger.e('Error fetching user info: $e');
      emit(HomeError(
        status: HomeStatus.error,
        message: 'Failed to fetch user info',
      ));
    }
  }
}
