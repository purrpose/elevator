import 'package:elevator_app/feature/elevator/cubit/call_cubit.dart';
import 'package:elevator_app/feature/elevator/data/repository/call_repository_impl.dart';
import 'package:elevator_app/feature/elevator/domain/repository/call_repository.dart';
import 'package:elevator_app/feature/elevator/presentation/page/elevator_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/network/http_client.dart';

void main() {
  // Инициализируем зависимости
  final httpClient = HttpClient();
  final CallRepository callRepository = CallRepositoryImpl(httpClient);

  runApp(MyApp(callRepository: callRepository));
}

class MyApp extends StatelessWidget {
  final CallRepository callRepository;

  const MyApp({super.key, required this.callRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CallCubit>(
      create: (_) => CallCubit(callRepository),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Elevator App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const ElevatorPage(),
      ),
    );
  }
}

