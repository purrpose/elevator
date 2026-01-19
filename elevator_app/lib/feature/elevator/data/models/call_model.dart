import 'package:elevator_app/feature/elevator/domain/entities/call_entity.dart';

class CallModel extends CallEntity {
  CallModel({
    required super.floor,
  });

  factory CallModel.fromJson(Map<String, dynamic> json) {
    return CallModel(
      floor: json['floor'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'floor': floor,
    };
  }
}
