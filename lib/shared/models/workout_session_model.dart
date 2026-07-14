class WorkoutSessionModel {
  final int? id;
  final int? templateId;
  final DateTime startTime;
  final DateTime? endTime;
  final double totalVolume;

  WorkoutSessionModel({
    this.id,
    this.templateId,
    required this.startTime,
    this.endTime,
    this.totalVolume = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'template_id': templateId,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'total_volume': totalVolume,
    };
  }

  factory WorkoutSessionModel.fromMap(Map<String, dynamic> map) {
    return WorkoutSessionModel(
      id: map['id'],
      templateId: map['template_id'],
      startTime: DateTime.parse(map['start_time']),
      endTime: map['end_time'] != null ? DateTime.parse(map['end_time']) : null,
      totalVolume: (map['total_volume'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
