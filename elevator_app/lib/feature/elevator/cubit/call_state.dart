class CallState {
  const CallState({
    required this.floor,
    this.countdown,
  });

  final int floor;
  final int? countdown;

  factory CallState.initial() {
    return const CallState(
      floor: 8,
      countdown: null,
    );
  }

  CallState copyWith({
    int? floor,
    int? countdown,
  }) {
    return CallState(
      floor: floor ?? this.floor,
      countdown: countdown,
    );
  }
}
