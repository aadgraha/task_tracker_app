import 'package:flutter/material.dart';
import 'package:task_tracker_app/src/app/model/task.dart';
import 'package:task_tracker_app/src/app/view/widget/custom_app_bar.dart';
import 'package:task_tracker_app/src/app/view/widget/task_status_symbol.dart';

class TaskDetailPage extends StatelessWidget {
  const TaskDetailPage({super.key, required this.task});
  final Task task;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomAppBar(label: 'Task Detail', backButton: true),
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Title', style: TextStyle(color: Colors.black54)),
                        Text(task.title, style: TextStyle(fontSize: 20)),
                        SizedBox(height: 20),
                        Text(
                          'Description',
                          style: TextStyle(color: Colors.black54),
                        ),
                        Text(task.description, style: TextStyle(fontSize: 20)),
                        SizedBox(height: 20),
                        Text('Status', style: TextStyle(color: Colors.black54)),
                        SizedBox(height: 5),
                        TaskStatusSymbol(task: task),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
