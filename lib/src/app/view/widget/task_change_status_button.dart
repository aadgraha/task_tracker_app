import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker_app/src/app/bloc/task_status/task_status_bloc.dart';
import 'package:task_tracker_app/src/app/model/task.dart';

class TaskChangeStatusButton extends StatelessWidget {
  const TaskChangeStatusButton({super.key, required this.task, this.onSuccess});

  static Widget prepare({required Task task, VoidCallback? onSuccess}) {
    return BlocProvider(
      create: (_) => TaskStatusBloc(),
      child: TaskChangeStatusButton(task: task, onSuccess: onSuccess),
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
              const SnackBar(
                content: Text('Task status changed successfully'),
                duration: Duration(seconds: 1),
              ),
            );
            onSuccess?.call();
          },
          failure: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message ?? 'Something went wrong'),
                duration: Duration(seconds: 1),
              ),
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
