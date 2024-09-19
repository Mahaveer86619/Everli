import 'package:everli_client_v2/common/app_user_cubit/app_user_cubit_cubit.dart';
import 'package:everli_client_v2/common/notifications/notifications.dart';
import 'package:everli_client_v2/common/routes/app_routes.dart';
import 'package:everli_client_v2/common/widgets/bottom_app_bar/bloc/navigation_bloc.dart';
import 'package:everli_client_v2/core/endpoints/app_endpoints.dart';
import 'package:everli_client_v2/core/themes/theme.dart';
import 'package:everli_client_v2/features/assignments/presentation/bloc/assignment_bloc.dart';
import 'package:everli_client_v2/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:everli_client_v2/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:everli_client_v2/features/home/presentation/bloc/home_bloc.dart';
import 'package:everli_client_v2/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:everli_client_v2/injection_container.dart' as di;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await setup();
  runApp(const MainApp());
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  await di.registerDependencies();

  await setupNotificationChannels();

  // Test connection and make headers as json
  final response = await http.get(
    Uri.parse(
      "${dotenv.get('BASE_URL')}${AppEndpoints.test}",
    ),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  );
  debugPrint(response.body);
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppUserCubit>(
          create: (context) => di.sl<AppUserCubit>(),
        ),
        BlocProvider<NavigationBloc>(
          create: (context) => di.sl<NavigationBloc>(),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => di.sl<AuthBloc>(),
        ),
        BlocProvider<HomeBloc>(
          create: (context) => di.sl<HomeBloc>(),
        ),
        BlocProvider<AssignmentBloc>(
          create: (context) => di.sl<AssignmentBloc>(),
        ),
        BlocProvider<ChatBloc>(
          create: (context) => di.sl<ChatBloc>(),
        ),
        BlocProvider<SettingsBloc>(
          create: (context) => di.sl<SettingsBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Everli',
        theme: lightMode,
        darkTheme: darkMode,
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: routes,
      ),
    );
  }
}
