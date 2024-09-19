import 'package:everli_client_v2/common/widgets/bottom_app_bar/bloc/navigation_bloc.dart';
import 'package:everli_client_v2/common/widgets/bottom_app_bar/widgets/my_bottom_app_bar.dart';
import 'package:everli_client_v2/features/assignments/presentation/screens/assignments_screen.dart';
import 'package:everli_client_v2/features/chat/presentation/screens/chat_screen.dart';
import 'package:everli_client_v2/features/home/presentation/screens/home_screen.dart';
import 'package:everli_client_v2/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<Widget> pages = [
    const HomeScreen(), // home
    const AssignmensScreen(), // Assignments
    const ChatScreen(), // Chat
    const SettingScreen(), // Profile
  ];

  BottomNavigationBarItem _createBottomNavItem({
    required IconData inactiveIcon,
    required IconData activeIcon,
    required bool isActive,
    required String label,
    required BuildContext context,
  }) {
    return BottomNavigationBarItem(
      icon: Icon(inactiveIcon),
      activeIcon: Icon(activeIcon),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<NavigationBloc, NavigationState>(
          builder: (context, state) {
            if (state is NavigationChanged) {
              return pages[state.index];
            }
            return pages[0];
          },
        ),
        bottomNavigationBar: BlocBuilder<NavigationBloc, NavigationState>(
          builder: (context, state) {
            int currentIndex = 0;
            if (state is NavigationChanged) {
              currentIndex = state.index;
            }

            final List<BottomNavigationBarItem> bottomNavItems = [
              _createBottomNavItem(
                inactiveIcon: Icons.home_outlined,
                activeIcon: Icons.home,
                isActive: currentIndex == 0,
                context: context,
                label: 'Home',
              ),
              _createBottomNavItem(
                inactiveIcon: Icons.list_outlined,
                activeIcon: Icons.list,
                isActive: currentIndex == 1,
                context: context,
                label: 'Assignments',
              ),
              _createBottomNavItem(
                inactiveIcon: Icons.chat_outlined,
                activeIcon: Icons.chat,
                isActive: currentIndex == 2,
                context: context,
                label: 'Chat',
              ),
              _createBottomNavItem(
                inactiveIcon: Icons.person_outlined,
                activeIcon: Icons.person,
                isActive: currentIndex == 3,
                context: context,
                label: 'Profile',
              ),
            ];

            return MyBottomAppBar(
              items: bottomNavItems,
              currentIndex: currentIndex,
            );
          },
        ),
      ),
    );
  }
}
