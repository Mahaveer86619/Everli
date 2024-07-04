import 'package:everli_client/core/common/cubit/app_user_cubit.dart';
import 'package:everli_client/core/common/notifications/notifications.dart';
import 'package:everli_client/core/themes/theme.dart';
import 'package:everli_client/features/auth/bloc/auth_bloc.dart';
import 'package:everli_client/features/auth/view/screens/splash_screen.dart';
import 'package:everli_client/firebase_options.dart';
import 'package:everli_client/injection_container.dart' as di;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

void main() async {
  await setup();
  runApp(const MyApp());
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load(fileName: '.env');
  await di.registerDependencies();

  await setupNotificationChannels();

  final appUserCubit = di.sl<AppUserCubit>();
  await appUserCubit.loadUser();

  //* Test connection
  final response = await http.get(
    Uri.parse(
      "${dotenv.get('BASE_URL')}/",
    ),
  );
  debugPrint(response.body);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppUserCubit>(
          create: (context) => di.sl<AppUserCubit>(),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => di.sl<AuthBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Everli',
        theme: lightMode,
        darkTheme: darkMode,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}


