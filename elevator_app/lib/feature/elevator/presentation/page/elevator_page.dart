import 'package:elevator_app/feature/elevator/cubit/call_cubit.dart';
import 'package:elevator_app/feature/elevator/cubit/call_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ElevatorPage extends StatelessWidget {
  const ElevatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Вызов лифта'),
        centerTitle: true,
      ),
      body: BlocBuilder<CallCubit, CallState>(
        builder: (context, state) {
          final isError = state.floor == -1;
          final floorText =
              isError ? 'Ошибка вызова' : 'Этаж вызова: ${state.floor}';

          final countdownText = state.countdown != null
              ? '⏳ Осталось: ${state.countdown} сек'
              : '⏳ Ожидание...';

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(
                  floorText,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isError ? Colors.red : Colors.black,
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () async {
                    await context.read<CallCubit>().callLift(1);
                    context.read<CallCubit>().startCountdown();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 80),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(fontSize: 24),
                  ),
                  child: const Text('Вызвать на 1 этаж'),
                ),
                const SizedBox(height: 60),
                Container(
                  height: 60,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    countdownText,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
