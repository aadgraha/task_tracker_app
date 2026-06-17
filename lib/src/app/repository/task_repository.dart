import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:task_tracker_app/src/app/model/task.dart';
import 'package:task_tracker_app/src/app/repository/base_api.dart';

class TaskRepository {
  TaskRepository({required this.dio});

  final Dio dio;

  static TaskRepository instance = TaskRepository(dio: Api.dio);

  Future<List<Task>> listTask() async {
    final response = await dio.get('/tasks');
    final data = response.data as List<dynamic>;
    return data.map((e) => Task.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> createTask({required Task task}) async {
    await dio.post<Map<String, dynamic>>(
      '/tasks',
      data: jsonEncode({'title': task.title, 'description': task.description}),
    );
  }

  Future<void> changeStatus({required int id, required String status}) async {
    await dio.patch<Map<String, dynamic>>(
      '/tasks/$id/status',
      data: jsonEncode({'status': status}),
    );
  }
}
