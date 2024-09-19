import 'package:everli_client_v2/common/widgets/bottom_app_bar/bloc/navigation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyBottomAppBar extends StatelessWidget {
  final List<BottomNavigationBarItem> items;
  final int currentIndex;

  const MyBottomAppBar({
    super.key,
    required this.items,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: items,
      currentIndex: currentIndex,
      onTap: (index) {
        context.read<NavigationBloc>().add(NavigateTo(index: index));
      },
      type: BottomNavigationBarType.fixed,
      elevation: 1,
      selectedLabelStyle: TextStyle(
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}
