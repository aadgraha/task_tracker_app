import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker_app/src/app/bloc/menu/menu_bloc.dart';
import 'package:task_tracker_app/src/app/bloc/task_fetch/task_fetch_bloc.dart';
import 'package:task_tracker_app/src/app/bloc/task_status/task_status_bloc.dart';
import 'package:task_tracker_app/src/app/view/page/task_list_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: ((_) => TaskFetchBloc()..add(TaskFetchEvent.get())),
        ),
        BlocProvider(create: (_) => MenuBloc()),
        BlocProvider(create: (_) => TaskStatusBloc()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
          brightness: Brightness.light,
        ),
        home: TaskListPage(),
      ),
    );
  }
}
