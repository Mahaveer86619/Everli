import 'package:everli_client_v2/common/app_user_cubit/app_user_cubit_cubit.dart';
import 'package:everli_client_v2/common/notifications/notifications.dart';
import 'package:everli_client_v2/injection_container.dart' as di;
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

  final appUserCubit = di.sl<AppUserCubit>();
  // await appUserCubit.loadUser();

  // Test connection and make headers as json
  final response = await http.get(
    Uri.parse(
      "${dotenv.get('BASE_URL')}/",
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
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
