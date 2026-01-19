import 'package:dio/dio.dart';
import '../../../../core/network/http_client.dart';
import '../../domain/entities/call_entity.dart';
import '../models/call_model.dart';
import '../../domain/repository/call_repository.dart';

class CallRepositoryImpl implements CallRepository {
  final HttpClient http;

  CallRepositoryImpl(this.http);

  @override
  Future<void> callLift(int floor) async {
    try {
      await http.dio.post(
        '/call',
        data: {'floor': floor},
      );
    } on DioException catch (e) {
      throw Exception('Lift call failed: ${e.message}');
    }
  }

  @override
  Future<CallEntity> getLiftStatus(int floor) async {
    try {
      final response = await http.dio.get('/status/$floor');
      return CallModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Status fetch failed: ${e.message}');
    }
  }
}
