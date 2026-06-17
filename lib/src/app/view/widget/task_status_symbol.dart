import 'package:flutter/material.dart';
import 'package:task_tracker_app/src/app/model/task.dart';

class TaskStatusSymbol extends StatelessWidget {
  const TaskStatusSymbol({super.key, required this.task});

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
