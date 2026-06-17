import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:task_tracker_app/src/app/bloc/task_fetch/task_fetch_bloc.dart';
import 'package:task_tracker_app/src/app/view/page/task_create_page.dart';
import 'package:task_tracker_app/src/app/view/widget/custom_app_bar.dart';
import 'package:task_tracker_app/src/app/view/widget/empty_data.dart';
import 'package:task_tracker_app/src/app/view/widget/task_card.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> refresh() async {
      context.read<TaskFetchBloc>().add(TaskFetchEvent.refresh());
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(
              label: 'Task List',
              leadingWidget: IconButton(
                onPressed: () {
                  Navigator.push<bool?>(
                    context,
                    MaterialPageRoute(builder: (_) => TaskCreatePage.prepare()),
                  ).then((value) {
                    if (value ?? false) {
                      refresh();
                    }
                  });
                },
                icon: Icon(Icons.add_box_outlined, size: 30),
              ),
            ),
            Expanded(
              child: BlocBuilder<TaskFetchBloc, TaskFetchState>(
                builder: (context, state) {
                  return state.when(
                    initial: () => SizedBox.shrink(),
                    success: (tasks) {
                      if (tasks.isNotEmpty) {
                        return RefreshIndicator(
                          onRefresh: refresh,
                          child: Skeletonizer(
                            ignoreContainers: true,
                            enabled: state.maybeWhen(
                              orElse: () => false,
                              loading: () => true,
                            ),
                            child: ListView(
                              children: [
                                ...tasks.map((task) => TaskCard(task: task)),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return EmptyData();
                      }
                    },
                    loading: () => CircularProgressIndicator(),
                    failure: (message) =>
                        Center(child: Text(message ?? 'Something went wrong')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
