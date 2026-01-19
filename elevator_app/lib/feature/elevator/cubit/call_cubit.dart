import 'dart:async';

import 'package:elevator_app/feature/elevator/cubit/call_state.dart';
import 'package:elevator_app/feature/elevator/domain/repository/call_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CallCubit extends Cubit<CallState> {
  final CallRepository _callRepository;
  Timer? _timer;

  CallCubit(this._callRepository) : super(CallState.initial());

  Future<void> callLift(int floor) async {
    try {
      await _callRepository.callLift(floor);
      emit(state.copyWith(floor: floor));
    } catch (e) {
      emit(state.copyWith(floor: -1));
    }
  }

  Future<void> getLiftStatus(int floor) async {
    try {
      final callEntity = await _callRepository.getLiftStatus(floor);
      emit(state.copyWith(
        floor: callEntity.floor,
      ));
    } catch (e) {
      emit(state.copyWith(floor: -1));
    }
  }

  void startCountdown() {
    _timer?.cancel();
    int counter = state.floor * 3;

    emit(state.copyWith(countdown: counter));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      counter--;
      if (counter < 0) {
        timer.cancel();
        emit(state.copyWith(countdown: null));
      } else {
        emit(state.copyWith(countdown: counter));
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
