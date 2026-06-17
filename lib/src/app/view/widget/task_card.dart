import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker_app/src/app/bloc/task_fetch/task_fetch_bloc.dart';
import 'package:task_tracker_app/src/app/bloc/task_status/task_status_bloc.dart';
import 'package:task_tracker_app/src/app/model/task.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task});
  final Task task;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                      StatusSymbol(task: task),
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
                  ChangeStatusButton.prepare(
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
    );
  }
}

class StatusSymbol extends StatelessWidget {
  const StatusSymbol({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        border: Border.all(color: task.status.color, width: 1.5),
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
      child: Text(
        task.status.label,
        style: TextStyle(
          color: task.status.color,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ChangeStatusButton extends StatelessWidget {
  const ChangeStatusButton({super.key, required this.task, this.onSuccess});

  static Widget prepare({required Task task, VoidCallback? onSuccess}) {
    return BlocProvider(
      create: (_) => TaskStatusBloc(),
      child: ChangeStatusButton(task: task, onSuccess: onSuccess),
    );
  }

  final Task task;
  final VoidCallback? onSuccess;

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskStatusBloc, TaskStatusState>(
      listener: (context, state) {
        state.maybeWhen(
          success: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Task status changed successfully')),
            );
            onSuccess?.call();
          },
          failure: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message ?? 'Something went wrong')),
            );
          },
          orElse: () {},
        );
      },
      child: Align(
        alignment: Alignment.centerRight,
        child: BlocBuilder<TaskStatusBloc, TaskStatusState>(
          builder: (context, state) {
            final isDone = task.status == TaskStatus.done;
            void changeStatus() {
              context.read<TaskStatusBloc>().add(
                TaskStatusEvent.status(
                  id: task.id,
                  status: !isDone ? 'done' : 'pending',
                ),
              );
            }

            return OutlinedButton.icon(
              onPressed: state.maybeWhen(
                orElse: () => changeStatus,
                loading: () => null,
              ),
              label: Text(!isDone ? 'mark as done' : 'mark as pending'),
              icon: SizedBox(
                width: 20,
                height: 20,
                child: state.maybeWhen(
                  orElse: () => Icon(!isDone ? Icons.done : Icons.pending),
                  loading: () => CircularProgressIndicator(strokeWidth: 2.5),
                ),
              ),
              //icon: ,
            );
          },
        ),
      ),
    );
  }
}
