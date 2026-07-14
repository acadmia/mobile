class HistorySessionModel {
  final int sessionId;
  final String templateName;
  final DateTime startTime;
  final DateTime? endTime;
  final int totalSets;
  final double totalVolume;

  HistorySessionModel({
    required this.sessionId,
    required this.templateName,
    required this.startTime,
    this.endTime,
    required this.totalSets,
    required this.totalVolume,
  });

  factory HistorySessionModel.fromMap(Map<String, dynamic> map) {
    return HistorySessionModel(
      sessionId: map['session_id'],
      templateName: map['template_name'] ?? 'Treino Livre',
      startTime: DateTime.parse(map['start_time']),
      endTime: map['end_time'] != null ? DateTime.parse(map['end_time']) : null,
      totalSets: map['total_sets'] ?? 0,
      totalVolume: (map['total_volume'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
