import '../entities/call_entity.dart';

abstract class CallRepository {
  Future<void> callLift(int floor);
  Future<CallEntity> getLiftStatus(int floor);
}
