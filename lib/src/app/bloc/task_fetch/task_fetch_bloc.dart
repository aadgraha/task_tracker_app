import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:task_tracker_app/src/app/model/task.dart';
import 'package:task_tracker_app/src/app/repository/task_repository.dart';

part 'task_fetch_bloc.freezed.dart';

@freezed
abstract class TaskFetchState with _$TaskFetchState {
  const factory TaskFetchState.initial() = _Initial;
  const factory TaskFetchState.loading() = _Loading;
  const factory TaskFetchState.success({required List<Task> tasks}) = _Success;
  const factory TaskFetchState.failure({String? message}) = _Failure;
}

@freezed
abstract class TaskFetchEvent with _$TaskFetchEvent {
  const factory TaskFetchEvent.get() = _Get;
  const factory TaskFetchEvent.refresh() = _Refresh;
}

class TaskFetchBloc extends HydratedBloc<TaskFetchEvent, TaskFetchState> {
  TaskFetchBloc() : super(const TaskFetchState.initial()) {
    on<_Get>(_onGet);
    on<_Refresh>(_onRefresh);
  }

  Future<void> _onGet(_Get event, Emitter<TaskFetchState> emit) async {
    if (state is _Success) return;
    await _fetch(emit);
  }

  Future<void> _onRefresh(_Refresh event, Emitter<TaskFetchState> emit) async {
    await _fetch(emit);
  }

  Future<void> _fetch(Emitter<TaskFetchState> emit) async {
    final currentState = state;

    if (currentState is! _Success) {
      emit(const TaskFetchState.loading());
    }

    try {
      final tasks = await TaskRepository.instance.listTask();

      emit(TaskFetchState.success(tasks: tasks));
    } catch (error) {
      if (currentState is! _Success) {
        emit(TaskFetchState.failure(message: error.toString()));
      }
    }
  }

  @override
  TaskFetchState? fromJson(Map<String, dynamic> json) {
    try {
      return TaskFetchState.success(
        tasks: (json['tasks'] as List)
            .map((e) => Task.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(TaskFetchState state) {
    return state.maybeWhen(
      success: (tasks) => {'tasks': tasks.map((e) => e.toJson()).toList()},
      orElse: () => null,
    );
  }
}
