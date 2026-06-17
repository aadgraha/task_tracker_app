import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker_app/src/app/bloc/menu/menu_bloc.dart';

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuBloc, MenuState>(
      builder: (context, state) {
        return SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _item(
                context,
                index: 0,
                isSelected: state.selectedIndex == 0,
                selectedIcon: Icons.task,
                unselectedIcon: Icons.task_outlined,
              ),
              _item(
                context,
                index: 1,
                isSelected: state.selectedIndex == 1,
                selectedIcon: Icons.bookmark,
                unselectedIcon: Icons.bookmark_outline,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _item(
    BuildContext context, {
    required int index,
    required bool isSelected,
    required IconData selectedIcon,
    required IconData unselectedIcon,
  }) {
    return GestureDetector(
      onTap: () {
        context.read<MenuBloc>().add(MenuChanged(index));
      },
      child: Icon(isSelected ? selectedIcon : unselectedIcon),
    );
  }
}
