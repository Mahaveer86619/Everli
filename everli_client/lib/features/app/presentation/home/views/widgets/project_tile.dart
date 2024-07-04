import 'package:cached_network_image/cached_network_image.dart';
import 'package:everli_client/features/app/model/event.dart';
import 'package:everli_client/features/app/presentation/home/views/widgets/chips.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventTile extends StatelessWidget {
  // event, members, creator
  final MyEvent event;
  const EventTile({super.key, required this.event});

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
      height: 350,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              width: MediaQuery.of(context).size.width * 0.8,
              imageUrl: event.imageUrl,
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
            event.title,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          Text(
            formatDate(event.creationDate),
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: 0.8,
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).colorScheme.primary,
            backgroundColor: Theme.of(context).colorScheme.surface,
          ),
          //! members Circular Avatar and Goto Button
        ],
      ),
    );
  }

  String formatDate(String iso8601String) {
    final DateTime dateTime = DateTime.parse(iso8601String);
    return DateFormat('d MMMM, yyyy').format(dateTime);
  }
}
