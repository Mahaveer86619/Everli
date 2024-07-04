import 'package:everli_client/core/common/cubit/app_user_cubit.dart';
import 'package:everli_client/core/common/models/app_user.dart';
import 'package:everli_client/features/app/presentation/home/repository/home_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;
  final AppUserCubit _appUserCubit;

  HomeBloc({
    required HomeRepository homeRepository,
    required AppUserCubit appUserCubit,
  })  : _homeRepository = homeRepository,
        _appUserCubit = appUserCubit,
        super(HomeInitial()) {
    on<HomeEvent>((_, emit) => emit(HomeLoading()));
    on<FetchAppUser>(_fetchAppUser);
  }

  Future<void> _fetchAppUser(
    FetchAppUser event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final user = await _appUserCubit.getUser();
      emit(HomeLoaded(user: user));
    } catch (e) {
      emit(HomeError(error: 'Error fetching app user'));
    }
  }
}
