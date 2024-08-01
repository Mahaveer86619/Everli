import 'package:cached_network_image/cached_network_image.dart';
import 'package:everli_client/core/common/constants/app_constants.dart';
import 'package:everli_client/core/common/models/app_user.dart';
import 'package:everli_client/core/resources/helpers.dart';
import 'package:everli_client/features/app/model/event.dart';
import 'package:everli_client/features/app/presentation/home/cubit/home_cubit.dart';
import 'package:everli_client/features/app/presentation/home/views/widgets/chips.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventTile extends StatefulWidget {
  final MyEvent event;
  const EventTile({super.key, required this.event});

  @override
  State<EventTile> createState() => _EventTileState();
}

class _EventTileState extends State<EventTile> {
  List<AppUser> members = [];

  @override
  void initState() {
    context.read<HomeCubit>().fetchEventMembers(widget.event.id);
    super.initState();
  }

  @override
  void dispose() {
    members.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surface.withOpacity(0.3),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
        ),
      ),
      width: MediaQuery.of(context).size.width * 0.7,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(8),
      child:
          BlocConsumer<HomeCubit, HomeCubitState>(listener: (context, state) {
        if (state is HomeCubitError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onError,
                ),
              ),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }, builder: (context, state) {
        if (state is HomeEventMembersLoaded) {
          members = state.members;
        }
        return _buildCard(
          context,
          widget.event,
          members,
        );
      }),
    );
  }

  _buildCard(BuildContext context, MyEvent event, List<AppUser> members) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            width: MediaQuery.of(context).size.width * 0.8,
            imageUrl: event.imageUrl ?? defaultEventImageUrl,
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        // chips
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: event.tags.map((tag) => MyChips(title: tag)).toList(),
            ),
          ),
        ),
        // Title and description
        const SizedBox(height: 12),
        Text(
          formatString(event.title, 22),
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        Text(
          formatDate(event.createdAt),
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildOverlappingAvatars(members),
            CircleAvatar(
              radius: 18,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(
                Icons.arrow_forward,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  _buildOverlappingAvatars(List<AppUser> members) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          for (int i = 0; i < members.length; i++)
            Align(
              widthFactor: 0.7,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: CachedNetworkImage(
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                  imageUrl: members[i].avatarUrl,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            )
        ],
      ),
    );
  }
}
