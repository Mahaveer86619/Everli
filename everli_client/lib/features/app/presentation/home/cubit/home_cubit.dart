import 'package:everli_client/core/common/cubit/app_user_cubit.dart';
import 'package:everli_client/core/common/models/app_user.dart';
import 'package:everli_client/core/resources/data_state.dart';
import 'package:everli_client/features/app/presentation/home/repository/home_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

part 'home_cubit_state.dart';

class HomeCubit extends Cubit<HomeCubitState> {
  final HomeRepository _homeRepository;
  final AppUserCubit _appUserCubit;
  final Logger _logger;

  HomeCubit({
    required HomeRepository homeRepository,
    required AppUserCubit appUserCubit,
    required Logger logger,
  })  : _homeRepository = homeRepository,
        _appUserCubit = appUserCubit,
        _logger = logger,
        super(HomeCubitInitial());

  Future<void> fetchEventMembers(String eventId) async {
    emit(HomeCubitLoading());
    try {
      final members = await _homeRepository.getEventMembers(eventId);
      if (members is DataSuccess) {
        emit(HomeEventMembersLoaded(members: members.data!));
      } else {
        emit(HomeCubitError(message: 'Error fetching event members'));
      }
    } catch (e) {
      emit(HomeCubitError(message: 'Error fetching event members'));
    }
  }
}
