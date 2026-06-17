import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker_app/src/app/bloc/menu/menu_bloc.dart';
import 'package:task_tracker_app/src/app/view/page/task_bookmark_page.dart';
import 'package:task_tracker_app/src/app/view/page/task_list_page.dart';
import 'package:task_tracker_app/src/app/view/widget/custom_bottom_navbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          switch (state.selectedIndex) {
            case 0:
              return const TaskListPage();
            case 1:
              return const TaskBookmarkPage();
            default:
              return const TaskListPage();
          }
        },
      ),
      bottomNavigationBar: const CustomBottomBar(),
    );
  }
}
