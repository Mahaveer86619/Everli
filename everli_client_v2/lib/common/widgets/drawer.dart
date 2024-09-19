import 'package:everli_client_v2/common/app_user_cubit/app_user_cubit_cubit.dart';
import 'package:everli_client_v2/common/constants/app_constants.dart';
import 'package:everli_client_v2/core/resources/helpers.dart';
import 'package:everli_client_v2/features/auth/domain/entities/app_user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyDrawer extends StatelessWidget {
  final AppUserEntity? appUser;
  const MyDrawer({
    super.key,
    this.appUser,
  });

  _navigateScreen(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      // wrap column with padding with 20 horizontal padding
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    // handle on profile tap
                    _navigateScreen(context, '/profile');
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondary,
                            shape: BoxShape.circle,
                          ),
                          child: Image.network(
                            defaultAvatarUrl,
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appUser?.name ?? 'Guest',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color: theme.colorScheme.onBackground,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'View Profile',
                            style: theme.textTheme.bodyMedium!.copyWith(
                              color: theme.colorScheme.onBackground,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                DrawerTile(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () {},
                ),
                DrawerTile(
                  icon: Icons.info_outline,
                  title: 'App Info',
                  onTap: () {},
                ),
              ],
            ),
            Column(
              children: [
                DrawerTile(
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () {
                    context.read<AppUserCubit>().signOut();
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function() onTap;

  const DrawerTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(4),
        ),
        height: 50,
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary,
                  ),
                  width: 3,
                ),
                const SizedBox(width: 20),
                Icon(
                  icon,
                  color: theme.colorScheme.onBackground,
                ),
                const SizedBox(width: 10),
                Text(
                  formatString(title, 22),
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: theme.colorScheme.onBackground,
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.keyboard_arrow_right,
                  color: theme.colorScheme.onBackground,
                ),
                const SizedBox(width: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
