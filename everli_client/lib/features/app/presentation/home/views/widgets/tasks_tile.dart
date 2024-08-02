import 'package:everli_client/core/resources/helpers.dart';
import 'package:everli_client/core/common/models/assignments.dart';
import 'package:flutter/material.dart';

class TasksTile extends StatelessWidget {
  final MyAssignment assignment;
  const TasksTile({
    super.key,
    required this.assignment,
  });

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
      width: MediaQuery.of(context).size.width * 0.93,
      height: 105,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formatString(
                assignment.goal,
                25,
              ),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 18,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.8),
                  ),
            ),
            Text(
              formatString(
                assignment.description,
                40,
              ),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 12,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.4),
                  ),
            ),
            const SizedBox(height: 8),
            Divider(
              height: 1,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
            ),
            const SizedBox(height: 8),
            Text(
              formatDate(assignment.dueDate.toIso8601String()),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 12,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.4),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
