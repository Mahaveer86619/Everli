import 'package:everli_client_v2/common/app_user_cubit/app_user_cubit_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final AppUserCubit _appUserCubit;
  final Logger _logger;

  ChatBloc({
    required AppUserCubit appUserCubit,
    required Logger logger,
  })  : _appUserCubit = appUserCubit,
        _logger = logger,
        super(ChatInitial()) {
    on<ChatEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
