import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker_app/src/app/bloc/task_create/task_create_bloc.dart';
import 'package:task_tracker_app/src/app/model/task.dart';
import 'package:task_tracker_app/src/app/view/widget/custom_app_bar.dart';
import 'package:task_tracker_app/src/app/view/widget/custom_text_field.dart';

class TaskCreatePage extends StatefulWidget {
  const TaskCreatePage({super.key});

  static Widget prepare() {
    return BlocProvider(
      create: (_) => TaskCreateBloc(),
      child: TaskCreatePage(),
    );
  }

  @override
  State<TaskCreatePage> createState() => _TaskCreatePageState();
}

class _TaskCreatePageState extends State<TaskCreatePage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _createTask() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    context.read<TaskCreateBloc>().add(
      TaskCreateEvent.create(
        task: Task.empty().copyWith(title: title, description: description),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskCreateBloc, TaskCreateState>(
      listener: (context, state) {
        state.maybeWhen(
          success: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Task created successfully'),
                duration: Duration(seconds: 1),
              ),
            );
            Navigator.pop(context, true);
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
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              CustomAppBar(label: 'Create Task', backButton: true),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      CustomTextField(
                        label: 'Task Title',
                        hint: 'Enter task title',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Task title is required';
                          }

                          if (value.trim().length < 3) {
                            return 'Title must be at least 3 characters';
                          }

                          return null;
                        },
                        controller: _titleController,
                      ),
                      SizedBox(height: 8),
                      CustomTextField(
                        label: 'Task Description',
                        hint: 'Enter task description',
                        lines: 4,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Task description is required';
                          }

                          if (value.trim().length < 10) {
                            return 'Description must be at least 10 characters';
                          }

                          return null;
                        },
                        controller: _descriptionController,
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BlocBuilder<TaskCreateBloc, TaskCreateState>(
                          builder: (context, state) {
                            return FilledButton.icon(
                              onPressed: state.maybeWhen(
                                orElse: () => _createTask,
                                loading: null,
                              ),
                              icon: const Icon(Icons.add),
                              label: const Text('Create'),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
