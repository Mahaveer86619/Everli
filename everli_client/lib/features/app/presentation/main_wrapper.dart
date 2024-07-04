import 'package:everli_client/features/app/presentation/todo/views/screens/assignment_screen.dart';
import 'package:everli_client/features/app/presentation/chat/views/screens/chat_screen.dart';
import 'package:everli_client/features/app/presentation/home/views/screens/home_screen.dart';
import 'package:everli_client/features/app/presentation/profile/views/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int currentScreen = 0;

  List<Widget> screens = [
    const HomeScreen(),
    const AssignmentsScreen(),
    const ChatScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: _bottomNavBar(),
        body: screens[currentScreen],
      ),
    );
  }

  _bottomNavBar() {
    return NavigationBar(
      backgroundColor: Theme.of(context).colorScheme.background,
      elevation: 1,
      selectedIndex: currentScreen,
      onDestinationSelected: (int index) {
        setState(() {
          currentScreen = index;
        });
      },
      indicatorColor: Theme.of(context).colorScheme.tertiary,
      destinations: [
        NavigationDestination(
          icon: Icon(
            Icons.home,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          selectedIcon: Icon(
            Icons.home,
            color: Theme.of(context).colorScheme.onTertiary,
          ),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.assignment,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          selectedIcon: Icon(
            Icons.assignment,
            color: Theme.of(context).colorScheme.onTertiary,
          ),
          label: 'Todos',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.chat,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          selectedIcon: Icon(
            Icons.chat,
            color: Theme.of(context).colorScheme.onTertiary,
          ),
          label: 'Chat',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.person,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          selectedIcon: Icon(
            Icons.person,
            color: Theme.of(context).colorScheme.onTertiary,
          ),
          label: 'Profile',
        ),
      ],
    );
  }
}
