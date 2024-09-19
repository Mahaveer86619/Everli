import 'package:everli_client_v2/common/app_user_cubit/app_user_cubit_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

part 'assignment_event.dart';
part 'assignment_state.dart';

class AssignmentBloc extends Bloc<AssignmentEvent, AssignmentState> {
  final AppUserCubit _appUserCubit;
  final Logger _logger;

  AssignmentBloc({
    required AppUserCubit appUserCubit,
    required Logger logger,
  })  : _appUserCubit = appUserCubit,
        _logger = logger,
        super(AssignmentInitial()) {
    on<AssignmentEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
