import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:task_tracker_app/src/app/model/task.dart';
import 'package:task_tracker_app/src/app/repository/task_repository.dart';

part 'task_create_bloc.freezed.dart';

@freezed
abstract class TaskCreateState with _$TaskCreateState {
  const factory TaskCreateState.initial() = _Initial;
  const factory TaskCreateState.loading() = _Loading;
  const factory TaskCreateState.success() = _Success;
  const factory TaskCreateState.failure({String? message}) = _Failure;
}

@freezed
abstract class TaskCreateEvent with _$TaskCreateEvent {
  const factory TaskCreateEvent.create({required Task task}) = _Create;
}

class TaskCreateBloc extends Bloc<TaskCreateEvent, TaskCreateState> {
  TaskCreateBloc() : super(const _Initial()) {
    on<TaskCreateEvent>((event, emit) async {
      await event.when(
        create: (task) async {
          emit(const _Loading());
          try {
            await TaskRepository.instance.createTask(task: task);
            emit(const _Success());
          } catch (error) {
            emit(_Failure(message: error.toString()));
          }
        },
      );
    });
  }
}
