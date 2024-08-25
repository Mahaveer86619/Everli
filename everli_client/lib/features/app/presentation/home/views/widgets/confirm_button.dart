import 'package:flutter/material.dart';

class ConfirmButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final MaterialColor? color;

  const ConfirmButton({
    super.key,
    required this.text,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color == null
              ? Theme.of(context).colorScheme.surface
              : color!.withOpacity(0.8),
          border: Border.all(
            color:
                color == null ? Theme.of(context).colorScheme.surface : color!,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Text(
              text,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_rounded,
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}
