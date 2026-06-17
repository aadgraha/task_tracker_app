import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker_app/src/app/bloc/task_fetch/task_fetch_bloc.dart';
import 'package:task_tracker_app/src/app/model/task.dart';
import 'package:task_tracker_app/src/app/view/widget/task_change_status_button.dart';
import 'package:task_tracker_app/src/app/view/widget/task_status_symbol.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task, this.onTap});
  final Task task;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(8),
        height: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          children: [
            Container(
              height: 150,
              width: 10,
              decoration: BoxDecoration(
                color: task.status.color,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(task.title, style: TextStyle(fontSize: 22)),
                        TaskStatusSymbol(task: task),
                      ],
                    ),
                    SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        task.description,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    TaskChangeStatusButton.prepare(
                      task: task,
                      onSuccess: () {
                        context.read<TaskFetchBloc>().add(
                          TaskFetchEvent.refresh(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
