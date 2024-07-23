import 'package:everli_client/core/common/constants/app_constants.dart';
import 'package:everli_client/core/common/models/app_user.dart';
import 'package:everli_client/core/common/widgets/error_screen.dart';
import 'package:everli_client/core/common/widgets/loading_screen.dart';
import 'package:everli_client/features/app/model/assignments.dart';
import 'package:everli_client/features/app/model/event.dart';
import 'package:everli_client/features/app/presentation/home/bloc/home_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:everli_client/features/app/presentation/home/views/widgets/project_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int taskCount = 3;

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
      SnackBar(content: Text(message)),
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
        },
        builder: (context, state) {
          if (state is HomeLoading) {
            return const LoadingScreen();
          }
          if (state is HomeError) {
            return ErrorScreen(error: state.error);
          }
          if (state is HomeLoaded) {
            return _buildBody(state.user);
          }
          return Container();
        },
      ),
    );
  }

  _buildBody(AppUser user) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
          child: Column(
            children: [
              _buildHeader(user),
              const SizedBox(height: 32),
              _buildProjectSection(),
              const SizedBox(height: 32),
              _buildTodaysTasks(),
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
                imageUrl: defaultAvatarUrl,
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            const SizedBox(width: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.username,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
                Text(
                  'You have $taskCount tasks today',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.5),
                      ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        IconButton(
          icon: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          onPressed: () {},
        ),
        _moreIcon(),
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

  _buildProjectSection() {
    final List<MyEvent> events = getEvents();
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
            '${events.length} events joined',
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
          height: 350,
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

  _buildTodaysTasks() {
    final List<MyAssignments> assignments = getAssignments();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'Today\'s tasks',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
        ),
      ],
    );
  }
}

List<MyEvent> getEvents() {
  return [
    MyEvent(
      id: 'id',
      creatorId: "creatorId",
      title: "Mobile app design",
      description: "Design a mobile app for a startup in India",
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
      tags: ["High Priority", "In Progress", "Tech", "Design"],
    ),
    MyEvent(
      id: 'id',
      creatorId: "creatorId",
      title: "Mobile app design",
      description: "Design a mobile app for a startup in India",
      imageUrl:
          "https://www.9series.com/img/services/design/leading%20Mobile%20app%20design%20company%20in%20India.jpeg",
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
      tags: ["High Priority", "In Progress"],
    ),
    MyEvent(
      id: 'id',
      creatorId: "creatorId",
      title: "Mobile app design",
      description: "Design a mobile app for a startup in India",
      imageUrl:
          "https://www.9series.com/img/services/design/leading%20Mobile%20app%20design%20company%20in%20India.jpeg",
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
      tags: ["High Priority", "In Progress"],
    ),
    MyEvent(
      id: 'id',
      creatorId: "creatorId",
      title: "Mobile app design",
      description: "Design a mobile app for a startup in India",
      imageUrl:
          "https://www.9series.com/img/services/design/leading%20Mobile%20app%20design%20company%20in%20India.jpeg",
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
      tags: ["High Priority", "In Progress"],
    ),
  ];
}

List<MyAssignments> getAssignments() {
  return [
    MyAssignments(
      id: 'id',
      eventId: 'eventId',
      memberId: 'memberId',
      goal: 'Onboarding of mobile app',
      description: 'description',
      dueDate: DateTime.now(),
      isCompleted: false,
    ),
    MyAssignments(
      id: 'id',
      eventId: 'eventId',
      memberId: 'memberId',
      goal: 'goal',
      description: 'description',
      dueDate: DateTime.now(),
      isCompleted: false,
    ),
    MyAssignments(
      id: 'id',
      eventId: 'eventId',
      memberId: 'memberId',
      goal: 'goal',
      description: 'description',
      dueDate: DateTime.now(),
      isCompleted: false,
    ),
    MyAssignments(
      id: 'id',
      eventId: 'eventId',
      memberId: 'memberId',
      goal: 'goal',
      description: 'description',
      dueDate: DateTime.now(),
      isCompleted: false,
    ),
  ];
}
