import 'package:flutter_bloc/flutter_bloc.dart';

abstract class MenuEvent {}

class MenuChanged extends MenuEvent {
  final int index;
  MenuChanged(this.index);
}

class MenuState {
  final int selectedIndex;
  const MenuState({required this.selectedIndex});
}

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc() : super(const MenuState(selectedIndex: 0)) {
    on<MenuChanged>((event, emit) {
      emit(MenuState(selectedIndex: event.index));
    });
  }
}