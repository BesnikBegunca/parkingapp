class Vehicle {
  final String mark;
  final String licensePlate;
  final String userId;
  final DateTime timestamp;

  Vehicle({
    required this.mark,
    required this.licensePlate,
    required this.userId,
    required this.timestamp,
  });

  // Convert a Vehicle object to a Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'mark' : mark,
      'license_plate': licensePlate,
      'user_id': userId,
      'timestamp': timestamp,
    };
  }
}
