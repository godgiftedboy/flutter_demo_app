// import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increament() {
    emit(state +
        1); //state is not a setter so we cannot use state++; instead we use emit as here
  }

  void decreament() {
    if (state == 0) {
      return;
    }
    emit(state -
        1); //state is not a setter so we cannot use state++; instead we use emit as here
  }
}
