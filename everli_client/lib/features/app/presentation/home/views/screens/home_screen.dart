import 'package:everli_client/core/common/models/app_user.dart';
import 'package:everli_client/core/common/widgets/error_screen.dart';
import 'package:everli_client/core/common/widgets/loading_screen.dart';
import 'package:everli_client/core/common/models/assignments.dart';
import 'package:everli_client/core/common/models/event.dart';
import 'package:everli_client/core/resources/helpers.dart';
import 'package:everli_client/features/app/presentation/home/bloc/home_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:everli_client/features/app/presentation/home/views/widgets/project_tile.dart';
import 'package:everli_client/features/app/presentation/home/views/widgets/tasks_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int taskCount = 3;
  AppUser user = AppUser.empty();

  _changeScreen(Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
      ),
    );
  }

  _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onError,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(FetchAppUser());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeError) {
            _showMessage(state.error);
          }
          if (state is HomeUserLoaded) {
            user = state.user;

            context.read<HomeBloc>().add(FetchAll(userId: user.id));

            // context.read<HomeBloc>().add(FetchMyEvents(userId: user.id));
          }
        },
        builder: (context, state) {
          if (state is HomeLoading) {
            return const LoadingScreen();
          }
          if (state is HomeError) {
            return ErrorScreen(error: state.error);
          }
          if (state is HomeUserLoaded) {
            return _buildLoadingScreen(state.user);
          }
          if (state is HomeLoaded) {
            return _buildBody(state);
          }
          return Container();
        },
      ),
    );
  }

  _buildBody(HomeLoaded state) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
          child: Column(
            children: [
              _buildHeader(user),
              const SizedBox(height: 16),
              _buildProjectSection(state.events),
              const SizedBox(height: 32),
              _buildUpcomingTasks(state.assignments),
            ],
          ),
        ),
      ),
    );
  }

  _buildLoadingScreen(AppUser user) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
          child: Column(
            children: [
              _buildHeader(user),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                backgroundColor: Theme.of(context).colorScheme.background,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildHeader(AppUser user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CachedNetworkImage(
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                imageUrl: user.avatarUrl,
                errorWidget: (context, url, error) => const Icon(
                  Icons.error,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello,',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.7),
                      ),
                ),
                Text(
                  formatString(user.username, 18),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
              ],
            ),
            const SizedBox(width: 8),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                // _changeScreen(
                //   const NotificationScreen(),
                // );
              },
              icon: Icon(
                Icons.notifications,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            const SizedBox(width: 8),
            _moreIcon(),
            const SizedBox(width: 8),
          ],
        )
      ],
    );
  }

  _moreIcon() {
    return PopupMenuButton(
      color: Theme.of(context).colorScheme.background,
      onSelected: (value) {
        switch (value) {
          case 0:
            debugPrint('Settings');
            break;
          case 1:
            debugPrint('About');
            break;
          case 2:
            debugPrint('Logout');
            break;
        }
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Settings',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                  Icon(
                    Icons.settings,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ],
              ),
            ),
          ),
          PopupMenuItem(
            value: 1,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'About us',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                  Icon(
                    Icons.info,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ],
              ),
            ),
          ),
          PopupMenuItem(
            value: 2,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Logout',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                  ),
                  Icon(
                    Icons.logout,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ],
              ),
            ),
          ),
        ];
      },
      child: const Icon(
        Icons.more_vert,
      ),
    );
  }

  _buildProjectSection(List<MyEvent> events) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'Events',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            '${events.length} ${events.length == 1 ? 'Event' : 'Events'} joined',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.5),
                ),
          ),
        ),
        const SizedBox(height: 16, width: double.infinity),
        SizedBox(
          height: 330,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: events.length,
            itemBuilder: (context, index) {
              int tileIndex = index % events.length;
              MyEvent event = events[tileIndex];
              return EventTile(event: event);
            },
          ),
        ),
      ],
    );
  }

  _buildUpcomingTasks(List<MyAssignment> assignments) {
    final assignment = MyAssignment(
      id: "id",
      eventId: "eventId",
      goal: "Onboarding Screen",
      description: "Make Onboarding Screen of Everli app.",
      dueDate: DateTime.now(),
      isCompleted: false,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Upcoming tasks',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 12,
          width: double.infinity,
        ),
        TasksTile(
          assignment: assignment,
        ),
        const SizedBox(height: 8),
        TasksTile(
          assignment: assignment,
        ),
      ],
    );
  }
}
