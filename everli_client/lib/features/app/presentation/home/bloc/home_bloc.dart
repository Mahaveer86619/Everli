import 'package:everli_client/core/common/cubit/app_user_cubit.dart';
import 'package:everli_client/core/common/models/app_user.dart';
import 'package:everli_client/core/resources/data_state.dart';
import 'package:everli_client/core/common/models/assignments.dart';
import 'package:everli_client/core/common/models/checkpoint.dart';
import 'package:everli_client/features/app/model/joined_events.dart';
import 'package:everli_client/features/app/presentation/home/repository/home_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;
  final AppUserCubit _appUserCubit;
  final Logger _logger;

  HomeBloc({
    required HomeRepository homeRepository,
    required AppUserCubit appUserCubit,
    required Logger logger,
  })  : _homeRepository = homeRepository,
        _appUserCubit = appUserCubit,
        _logger = logger,
        super(HomeInitial()) {
    on<HomeEvent>((_, emit) => emit(HomeLoading()));
    on<FetchAll>(_fetchAll);
    on<FetchAppUser>(_fetchAppUser);
    on<JoinEvent>(_joinEvent);
    on<Logout>(_logout);
  }

  Future<void> _fetchAll(
    FetchAll event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final events = await _fetchMyEvents(event.userId);
      final assignments = await _fetchMyAssignments(event.userId);
      final urgentAssignments = _getUrgentAssignments(assignments);

      emit(HomeLoaded(
        events: events,
        assignments: urgentAssignments,
      ));
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

  Future<List<JoinedEventsModel>> _fetchMyEvents(String userId) async {
    try {
      final eventsResponse = await _homeRepository.getMyEvents(userId);

      if (eventsResponse is DataSuccess) {
        final eventIds = eventsResponse.data!.map((event) => event.id).toList();
        final joinedEventsFuture = Future.wait(
            eventIds.map((eventId) async => _joinedEventData(eventId)));
        final joinedEvents = await joinedEventsFuture;

        return joinedEvents;
      } else {
        _logger.e("Error fetching my events");
        return [];
      }
    } catch (e) {
      _logger.e("Error fetching my assignments: $e");
      return [];
    }
  }

  Future<JoinedEventsModel> _joinedEventData(String eventId) async {
    final event = await _homeRepository.getEventDetails(eventId);
    final members = await _homeRepository.getEventMembers(eventId);

    if (event is DataSuccess && members is DataSuccess) {
      return JoinedEventsModel(
        event: event.data!,
        members: members.data!,
      );
    } else {
      _logger.e("Error Joining datas");
      return JoinedEventsModel.empty();
    }
  }

  List<MyAssignment> _getUrgentAssignments(List<MyAssignment> assignments) {
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));

    return assignments
        .where((assignment) =>
            assignment.dueDate.isBefore(now) ||
            assignment.dueDate.isAtSameMomentAs(now) ||
            assignment.dueDate.isAtSameMomentAs(tomorrow))
        .toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  Future<List<MyAssignment>> _fetchMyAssignments(String userId) async {
    try {
      final assignments = await _homeRepository.getMyAssignments(userId);
      if (assignments is DataSuccess) {
        return assignments.data!;
      } else {
        return [];
      }
    } catch (e) {
      _logger.e("Error fetching my assignments: $e");
      return [];
    }
  }

  Future<void> _joinEvent(
    JoinEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final resp = await _homeRepository.joinEvent(
        event.userId,
        event.code,
      );
      if (resp is DataSuccess) {
        // go to event screen
      } else {
        emit(HomeError(error: resp.message!));
      }
    } catch (e) {
      _logger.e("Error joining event: $e");
    }
  }

  Future<void> _logout(Logout event, Emitter<HomeState> emit) async {
    await _appUserCubit.signOut();
    emit(HomeInitial());
  }
}
