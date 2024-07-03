import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AlternateAuthCard extends StatelessWidget {
  final String text;
  final String iconPath;
  final VoidCallback onTap;

  const AlternateAuthCard({
    super.key,
    required this.text,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            // Border
            color: Theme.of(context).colorScheme.onBackground,
            width: 2.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          child: Row(
            children: [
              // Icon
              SvgPicture.asset(
                iconPath,
                theme: SvgTheme(
                  currentColor: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              // Text
              const SizedBox(
                width: 16,
              ),
              Text(
                text,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
