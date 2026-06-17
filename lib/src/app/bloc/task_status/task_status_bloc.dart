import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:task_tracker_app/src/app/resource/task_api_provider.dart';

part 'task_status_bloc.freezed.dart';

@freezed
abstract class TaskStatusState with _$TaskStatusState {
  const factory TaskStatusState.initial() = _Initial;
  const factory TaskStatusState.loading() = _Loading;
  const factory TaskStatusState.success() = _Success;
  const factory TaskStatusState.failure({String? message}) = _Failure;
}

@freezed
abstract class TaskStatusEvent with _$TaskStatusEvent {
  const factory TaskStatusEvent.status({
    required int id,
    required String status,
  }) = _Status;
}

class TaskStatusBloc extends Bloc<TaskStatusEvent, TaskStatusState> {
  TaskStatusBloc() : super(const _Initial()) {
    on<TaskStatusEvent>((event, emit) async {
      await event.when(
        status: (id, status) async {
          emit(const _Loading());
          try {
            await TaskApiProvider.instance.changeStatus(id: id, status: status);
            emit(const _Success());
          } catch (error) {
            emit(_Failure(message: error.toString()));
          }
        },
      );
    });
  }
}
