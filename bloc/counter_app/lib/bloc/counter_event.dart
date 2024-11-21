part of 'counter_bloc.dart';

sealed class CounterEvents {}

class CounterIncremented extends CounterEvents {}

class CounterDecremented extends CounterEvents {}
