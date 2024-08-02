import 'package:everli_client/core/common/cubit/app_user_cubit.dart';
import 'package:everli_client/core/common/models/app_user.dart';
import 'package:everli_client/core/resources/data_state.dart';
import 'package:everli_client/core/common/models/assignments.dart';
import 'package:everli_client/core/common/models/checkpoint.dart';
import 'package:everli_client/core/common/models/event.dart';
import 'package:everli_client/features/app/model/joined_events.dart';
import 'package:everli_client/features/app/presentation/home/cubit/home_cubit.dart';
import 'package:everli_client/features/app/presentation/home/repository/home_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;
  final HomeCubit _homeCubit;
  final AppUserCubit _appUserCubit;
  final Logger _logger;

  HomeBloc({
    required HomeRepository homeRepository,
    required HomeCubit homeCubit,
    required AppUserCubit appUserCubit,
    required Logger logger,
  })  : _homeRepository = homeRepository,
        _homeCubit = homeCubit,
        _appUserCubit = appUserCubit,
        _logger = logger,
        super(HomeInitial()) {
    on<HomeEvent>((_, emit) => emit(HomeLoading()));
    on<FetchAll>(_fetchAll);
    on<FetchAppUser>(_fetchAppUser);
    on<FetchMyEvents>(_fetchMyEvents);
    on<FetchEventMembers>(_fetchEventMembers);
    on<FetchMyAssignments>(_fetchMyAssignments);
    on<FetchMyCheckpoints>(_fetchMyCheckpoints);
  }

  Future<void> _fetchAll(
    FetchAll event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final eventsResponse = await _homeRepository.getMyEvents(
        event.userId,
      );
      final assignmentsResponse = await _homeRepository.getMyAssignments(
        event.userId,
      );
      final checkpointsResponse = await _homeRepository.getMyCheckpoints(
        event.userId,
      );
      if (eventsResponse is DataSuccess &&
          assignmentsResponse is DataSuccess &&
          checkpointsResponse is DataSuccess) {
        final events = eventsResponse.data!;
        final assignments = assignmentsResponse.data!;
        final checkpoints = checkpointsResponse.data!;
        emit(HomeLoaded(
          events: events,
          assignments: assignments,
          checkpoints: checkpoints,
        ));
      } else {
        emit(HomeError(error: 'Error fetching data'));
      }
    } catch (e) {
      _logger.e(e.toString());
      emit(HomeError(error: 'Error fetching data: $e'));
    }
  }

  Future<void> _fetchAppUser(
    FetchAppUser event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final user = await _appUserCubit.getUser();
      emit(HomeUserLoaded(user: user));
    } catch (e) {
      emit(HomeError(error: 'Error fetching app user'));
    }
  }

  Future<void> _fetchMyEvents(
    FetchMyEvents event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final eventsResponse = await _homeRepository.getMyEvents(event.userId);

      if (eventsResponse is DataSuccess) {
        final eventIds = eventsResponse.data!.map((event) => event.id).toList();
        final joinedEventsFuture = Future.wait(
            eventIds.map((eventId) async => _joinEventData(eventId)));
        final joinedEvents = await joinedEventsFuture;

        

        emit(HomeEventLoaded(events: joinedEvents));
      } else {
        emit(HomeError(error: 'Error fetching my events'));
      }
    } catch (e) {
      emit(HomeError(error: 'Error fetching my events: $e'));
    }
  }

  Future<JoinedEventsModel> _joinEventData(String eventId) async {
    final event = await _homeRepository.getEventDetails(eventId);
    final members = await _homeRepository.getEventMembers(eventId);

    if (event is DataSuccess && members is DataSuccess) {
      final joinedEvents = JoinedEventsModel(
        event: event.data!,
        members: members.data!,
      );
      _logger.i("Joined Events: ${joinedEvents.toJson().toString()}");
      return JoinedEventsModel(
        event: event.data!,
        members: members.data!,
      );
    } else {
      print("Error Joining datas");
      _logger.e("Error Joining datas");
      return JoinedEventsModel.empty();
    }
  }

  Future<void> _fetchEventMembers(
    FetchEventMembers event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final members = await _homeRepository.getEventMembers(event.eventId);
      if (members is DataSuccess) {
        emit(HomeEventMembersLoaded(members: members.data!));
      } else {
        emit(HomeError(error: 'Error fetching event members'));
      }
    } catch (e) {
      emit(HomeError(error: 'Error fetching event members: $e'));
    }
  }

  Future<void> _fetchMyAssignments(
    FetchMyAssignments event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final assignments = await _homeRepository.getMyAssignments(event.userId);
      if (assignments is DataSuccess) {
        emit(HomeAssignmentsLoaded(assignments: assignments.data!));
      } else {
        emit(HomeError(error: 'Error fetching my assignments'));
      }
    } catch (e) {
      emit(HomeError(error: 'Error fetching my assignments: $e'));
    }
  }

  Future<void> _fetchMyCheckpoints(
    FetchMyCheckpoints event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final checkpoints = await _homeRepository.getMyCheckpoints(event.userId);
      if (checkpoints is DataSuccess) {
        emit(HomeCheckpointsLoaded(checkpoints: checkpoints.data!));
      } else {
        emit(HomeError(error: 'Error fetching my checkpoints'));
      }
    } catch (e) {
      emit(HomeError(error: 'Error fetching my checkpoints: $e'));
    }
  }
}
