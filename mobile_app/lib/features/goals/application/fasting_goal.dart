class FastingGoal {
  final int? id;
  final String label;
  final int targetCount;
  final DateTime startDate;
  final DateTime endDate;

  FastingGoal({
    this.id,
    required this.label,
    required this.targetCount,
    required this.startDate,
    required this.endDate,
  });

  factory FastingGoal.fromJson(Map<String, dynamic> json) {
    return FastingGoal(
      id: json['id'],
      label: json['label'],
      targetCount: json['target_count'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'target_count': targetCount,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
    };
  }
}
