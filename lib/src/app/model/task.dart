import 'package:flutter/material.dart';

class Task {
  final int id;
  final String title;
  final String description;
  final TaskStatus status;
  final DateTime createdAt;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
  });

  Task copyWith({
    int? id,
    String? title,
    String? description,
    TaskStatus? status,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Task.empty() {
    return Task(
      id: 0,
      title: '',
      description: '',
      status: TaskStatus.pending,
      createdAt: DateTime.now(),
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: TaskStatus.fromString(json['status']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status.name, // pending or done
      'created_at': createdAt.toIso8601String(),
    };
  }
}

enum TaskStatus {
  pending(label: 'Pending', color: Colors.orange),
  done(label: 'Done', color: Colors.green);

  const TaskStatus({required this.label, required this.color});

  final String label;
  final Color color;

  static TaskStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'done':
        return TaskStatus.done;
      case 'pending':
      default:
        return TaskStatus.pending;
    }
  }
}
